import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:oreed_clean/features/home/domain/entities/related_ad_entity.dart';
import '../../domain/entities/sub_subcategory_entity.dart';
import '../../domain/usecases/get_sub_subcategories_usecase.dart';
import '../../domain/usecases/get_sub_subcategory_ads_usecase.dart';

part 'sub_subcategory_state.dart';

class SubSubcategoryCubit extends Cubit<SubSubcategoryState> {
  final GetSubSubcategoriesUseCase getSubSubcategoriesUseCase;
  final GetSubSubcategoryAdsUseCase getSubSubcategoryAdsUseCase;

  SubSubcategoryCubit(
    this.getSubSubcategoriesUseCase,
    this.getSubSubcategoryAdsUseCase,
  ) : super(const SubSubcategoryState());

  /// Fetch subcategories for a given category
  Future<void> fetchSubSubcategories(int categoryId) async {
    try {
      emit(state.copyWith(
        status: SubSubcategoryStatus.loading,
        errorMessage: null,
      ));

      final subcategories = await getSubSubcategoriesUseCase.call(categoryId);
      
      emit(state.copyWith(
        subcategories: subcategories,
        status: SubSubcategoryStatus.loaded,
      ));
    } catch (e, st) {
      log('❌ SubSubcategory fetch failed: $e', stackTrace: st);
      emit(state.copyWith(
        errorMessage: e.toString(),
        status: SubSubcategoryStatus.error,
      ));
    }
  }

  /// Fetch ads for a specific subcategory
  Future<void> fetchAds({
    required int sectionId,
    required int subCategoryId,
    String? searchText,
  }) async {
    try {
      emit(state.copyWith(
        status: SubSubcategoryStatus.loading,
        errorMessage: null,
      ));

      final ads = await getSubSubcategoryAdsUseCase.call(
        sectionId: sectionId,
        subCategoryId: subCategoryId,
        searchText: searchText,
      );
      
      emit(state.copyWith(
        ads: ads,
        searchText: searchText,
        status: SubSubcategoryStatus.loaded,
      ));
    } catch (e, st) {
      log('❌ Ads fetch failed: $e', stackTrace: st);
      emit(state.copyWith(
        errorMessage: e.toString(),
        status: SubSubcategoryStatus.error,
      ));
    }
  }

  /// Refresh ads with the same search text
  Future<void> refreshAds({
    required int sectionId,
    required int subCategoryId,
  }) async {
    await fetchAds(
      sectionId: sectionId,
      subCategoryId: subCategoryId,
      searchText: state.searchText,
    );
  }

  /// Clear all data
  void clearData() {
    emit(const SubSubcategoryState());
  }

  /// Clear error message
  void clearError() {
    emit(state.copyWith(errorMessage: null));
  }
}