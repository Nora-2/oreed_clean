import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:oreed_clean/core/app_shared_prefs.dart';
import 'package:oreed_clean/features/favourite/domain/entities/favourite_action_entity.dart';
import 'package:oreed_clean/features/favourite/domain/entities/favourite_ad_entity.dart';
import 'package:oreed_clean/features/favourite/domain/usecases/get_favourite.dart';
import 'package:oreed_clean/features/favourite/domain/usecases/toggel_favourite.dart';
import 'package:oreed_clean/features/favourite/domain/usecases/toggel_favouriteparams.dart';

part 'favourite_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  final ToggleFavorite _toggleFavorite;
  final GetFavorites _getFavorites;
  final AppSharedPreferences _prefs;

  FavoritesCubit(this._toggleFavorite, this._getFavorites, this._prefs)
      : super(const FavoritesState());

  bool isFavorite(int adId) => state.favoriteIds.contains(adId);
  bool isPending(int adId) => state.pendingIds.contains(adId);

  /// Load favorites from API
  Future<void> loadFavorites() async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final data = await _getFavorites();
      final ids = data.map((e) => e.id).toSet();
      
      emit(state.copyWith(
        items: data,
        favoriteIds: ids,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: 'locale.error_try_again'));
    }
  }

  /// Toggle Favorite with Optimistic UI Update
  Future<FavoriteActionResult> toggleFavorite({
    required int sectionId,
    required int adId,
  }) async {
    final token = _prefs.getUserToken;
    final currentUserId = _prefs.getUserId;

    // Check Login Status
    if (token == null || token.isEmpty || currentUserId == null || currentUserId == 0) {
      return const FavoriteActionResult(
        success: false,
        messageKey: '⚠️ من فضلك قم بتسجيل الدخول أولاً لتتمكن من الإضافة إلى المفضلة',
      );
    }

    // Prevent multiple clicks for the same ID
    if (state.pendingIds.contains(adId)) {
      return const FavoriteActionResult(success: false, messageKey: 'locale.please_wait');
    }

    // 1. Prepare Optimistic Change
    final isCurrentlyFav = state.favoriteIds.contains(adId);
    final newFavoriteIds = Set<int>.from(state.favoriteIds);
    final newItems = List<FavoriteAdEntity>.from(state.items);
    final newPendingIds = Set<int>.from(state.pendingIds)..add(adId);

    if (isCurrentlyFav) {
      newFavoriteIds.remove(adId);
      newItems.removeWhere((item) => item.id == adId);
    } else {
      newFavoriteIds.add(adId);
      // Note: We don't have the full object yet, so we just update the ID set
    }

    // 2. Emit Optimistic State
    emit(state.copyWith(
      favoriteIds: newFavoriteIds,
      items: newItems,
      pendingIds: newPendingIds,
    ));

    try {
      final result = await _toggleFavorite(
        ToggleFavoriteParams(
          sectionId: sectionId,
          adId: adId,
          userId: currentUserId,
        ),
      );

      // Clean up pending status
      final finalPending = Set<int>.from(state.pendingIds)..remove(adId);
      emit(state.copyWith(pendingIds: finalPending));
      
      return result;
    } catch (_) {
      // 3. Rollback on Failure
      final rollbackFavoriteIds = Set<int>.from(state.favoriteIds);
      final rollbackPending = Set<int>.from(state.pendingIds)..remove(adId);
      
      if (isCurrentlyFav) {
        rollbackFavoriteIds.add(adId);
        // Refresh full list since we lost the removed object
        unawaited(loadFavorites());
      } else {
        rollbackFavoriteIds.remove(adId);
      }

      emit(state.copyWith(
        favoriteIds: rollbackFavoriteIds,
        pendingIds: rollbackPending,
      ));

      return const FavoriteActionResult(
        success: false, 
        messageKey: 'locale.error_try_again',
      );
    }
  }

  void syncFavorites(Iterable<int> ids) {
    emit(state.copyWith(favoriteIds: ids.toSet()));
  }
}