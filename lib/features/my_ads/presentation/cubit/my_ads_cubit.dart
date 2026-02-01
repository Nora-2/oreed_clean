import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:oreed_clean/networking/error/failures.dart';
import 'package:oreed_clean/features/ads/domain/usecases/delete_ad_use_case.dart';
import 'package:oreed_clean/features/my_ads/domain/usecases/get_use_ads_usecase.dart';
import '../../domain/entities/user_ad_entity.dart';

part 'my_ads_state.dart';

class PersonAdsCubit extends Cubit<PersonAdsState> {
  final GetUserAdsUseCase getUserAdsUseCase;
  final DeleteAdUseCase deleteAdUseCase;

  PersonAdsCubit({
    required this.getUserAdsUseCase,
    required this.deleteAdUseCase,
  }) : super(const PersonAdsState());

  /// Fetch Ads
  Future<void> fetchUserAds(int userId) async {
    emit(state.copyWith(status: PersonAdsStatus.loading));

    final result = await getUserAdsUseCase(GetUserAdsParams(userId: userId));

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: PersonAdsStatus.error,
          errorMessage: _mapFailureToMessage(failure),
        ),
      ),
      (data) =>
          emit(state.copyWith(status: PersonAdsStatus.success, ads: data)),
    );
  }

  /// Delete Ad
  Future<void> deleteAd(int adId, int sectionId) async {
    // We don't change the whole screen to loading,
    // maybe just a small internal flag if needed.
    final result = await deleteAdUseCase(adId: adId, sectionId: sectionId);

    if (result.success) {
      // Create a new list without the deleted ad
      final updatedAds = state.ads.where((ad) => ad.id != adId).toList();

      emit(
        state.copyWith(
          ads: updatedAds,
          actionMessage: "Ad deleted successfully",
        ),
      );
    } else {
      emit(state.copyWith(actionMessage: result.message));
    }

    // Reset action message after showing snackbar to prevent it showing again
    emit(state.copyWith(actionMessage: null));
  }

  /// Map Failures
  String _mapFailureToMessage(Failure failure) {
    if (failure is NetworkFailure) {
      return 'No internet connection. Please try again.';
    } else if (failure is ServerFailure) {
      return failure.message;
    } else if (failure is AuthFailure) {
      return 'Session expired. Please login again.';
    }
    return failure.message;
  }
}
