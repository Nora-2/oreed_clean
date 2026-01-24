import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:oreed_clean/features/home/domain/entities/related_ad_entity.dart';
import 'package:oreed_clean/features/home/domain/usecases/get_related_ad_usecase.dart';
import '../../domain/entities/company_type_entity.dart';
import '../../domain/entities/sub_category_entity.dart';
import '../../domain/usecases/get_company_types_usecase.dart';
import '../../domain/usecases/get_sub_categories_usecase.dart';
import '../../domain/usecases/get_sub_category_ads_usecase.dart';

part 'sub_category_state.dart';

class SubCategoryCubit extends Cubit<SubCategoryState> {
  final GetSubCategoriesUseCase getSubCategories;
  final GetCompanyTypesUseCase getCompanyTypes;
  final GetSubCategoryAdsUseCase getSubCategoryAds;
  final GetRelatedAdsUseCase getRelatedAdsUseCase;

  SubCategoryCubit(
    this.getSubCategories,
    this.getCompanyTypes,
    this.getSubCategoryAds,
    this.getRelatedAdsUseCase,
  ) : super(const SubCategoryState());

  /// Clear all data
  void clearData() {
    emit(state.copyWith(
      subCategories: [],
      companyTypes: [],
      adsSection: [],
      status: SubCategoryStatus.idle,
      error: null,
    ));
  }

  /// Get subcategories for a specific section
  List<SubCategoryEntity> getSubCategoriesForSection(int sectionId) {
    return state.sectionSubcategories[sectionId] ?? [];
  }

  /// Get loading status for a specific section
  SubCategoryStatus getStatusForSection(int sectionId) {
    return state.sectionStatus[sectionId] ?? SubCategoryStatus.idle;
  }

  /// Load section data (categories + companies)
  Future<void> fetchData(int sectionId) async {
    emit(state.copyWith(
      subCategories: [],
      companyTypes: [],
      adsSection: [],
      status: SubCategoryStatus.loading,
      error: null,
    ));

    try {
      final fetchedSubs = await getSubCategories(sectionId);
      final fetchedCompanies = await getCompanyTypes(sectionId);

      emit(state.copyWith(
        subCategories: fetchedSubs,
        companyTypes: fetchedCompanies,
        status: SubCategoryStatus.success,
      ));
    } catch (e, st) {
      log("❌ SubCategory fetch failed: $e", stackTrace: st);
      emit(state.copyWith(
        error: e.toString(),
        status: SubCategoryStatus.error,
      ));
    }
  }

  /// Fetch subcategories for a specific section
  Future<void> fetchSectionCategory(int sectionId) async {
    // Update section-specific status
    final updatedSectionStatus = Map<int, SubCategoryStatus>.from(state.sectionStatus);
    updatedSectionStatus[sectionId] = SubCategoryStatus.loading;

    emit(state.copyWith(
      sectionStatus: updatedSectionStatus,
    ));

    try {
      final fetchedSubs = await getSubCategories(sectionId);

      // Update section-specific data
      final updatedSectionSubcategories = Map<int, List<SubCategoryEntity>>.from(state.sectionSubcategories);
      updatedSectionSubcategories[sectionId] = fetchedSubs;

      updatedSectionStatus[sectionId] = SubCategoryStatus.success;

      emit(state.copyWith(
        sectionSubcategories: updatedSectionSubcategories,
        subCategories: fetchedSubs, // Update main list for backward compatibility
        sectionStatus: updatedSectionStatus,
        status: SubCategoryStatus.success,
      ));
    } catch (e, st) {
      log("❌ SubCategory fetch failed for section $sectionId: $e", stackTrace: st);
      
      updatedSectionStatus[sectionId] = SubCategoryStatus.error;
      
      emit(state.copyWith(
        error: e.toString(),
        sectionStatus: updatedSectionStatus,
        status: SubCategoryStatus.error,
      ));
    }
  }

  /// Load first page of related ads
  Future<void> fetchRelatedAds(int sectionId, {String? searchText}) async {
    try {
      final result = await getSubCategoryAds.call(
        sectionId: sectionId,
        page: 1,
        searchText: searchText,
      );

      emit(state.copyWith(
        adsSection: result,
        searchText: searchText,
        currentPage: 1,
        isLastPage: false,
      ));
    } catch (e, st) {
      log("❌ Related ads fetch failed: $e", stackTrace: st);
      emit(state.copyWith(
        error: e.toString(),
        status: SubCategoryStatus.error,
      ));
    }
  }

  /// Pagination for related ads
  Future<void> loadMoreRelatedAds(int sectionId) async {
    if (state.isLastPage) return;

    final nextPage = state.currentPage + 1;

    try {
      final result = await getSubCategoryAds.call(
        sectionId: sectionId,
        page: nextPage,
        searchText: state.searchText,
      );

      if (result.isEmpty) {
        emit(state.copyWith(
          isLastPage: true,
          currentPage: nextPage,
        ));
      } else {
        emit(state.copyWith(
          adsSection: [...state.adsSection, ...result],
          currentPage: nextPage,
        ));
      }
    } catch (e, st) {
      log('Pagination failed: $e', stackTrace: st);
    }
  }

  /// Refresh ads list
  Future<void> refreshRelatedAds(int sectionId) async {
    emit(state.copyWith(
      currentPage: 1,
      isLastPage: false,
      adsSection: [],
    ));

    await fetchRelatedAds(sectionId, searchText: state.searchText);
  }

  /// Set ads only mode
  void setAdsOnlyMode(bool value) {
    emit(state.copyWith(adsOnlyMode: value));
  }
}