part of 'sub_category_cubit.dart';

enum SubCategoryStatus { idle, loading, success, error }

class SubCategoryState extends Equatable {
  final List<SubCategoryEntity> subCategories;
  final List<CompanyTypeEntity> companyTypes;
  final List<RelatedAdEntity> adsSection;
  final Map<int, List<SubCategoryEntity>> sectionSubcategories;
  final Map<int, SubCategoryStatus> sectionStatus;
  final SubCategoryStatus status;
  final String? error;
  final String? searchText;
  final bool adsOnlyMode;
  final int currentPage;
  final bool isLastPage;

  const SubCategoryState({
    this.subCategories = const [],
    this.companyTypes = const [],
    this.adsSection = const [],
    this.sectionSubcategories = const {},
    this.sectionStatus = const {},
    this.status = SubCategoryStatus.idle,
    this.error,
    this.searchText,
    this.adsOnlyMode = false,
    this.currentPage = 1,
    this.isLastPage = false,
  });

  SubCategoryState copyWith({
    List<SubCategoryEntity>? subCategories,
    List<CompanyTypeEntity>? companyTypes,
    List<RelatedAdEntity>? adsSection,
    Map<int, List<SubCategoryEntity>>? sectionSubcategories,
    Map<int, SubCategoryStatus>? sectionStatus,
    SubCategoryStatus? status,
    String? error,
    String? searchText,
    bool? adsOnlyMode,
    int? currentPage,
    bool? isLastPage,
  }) {
    return SubCategoryState(
      subCategories: subCategories ?? this.subCategories,
      companyTypes: companyTypes ?? this.companyTypes,
      adsSection: adsSection ?? this.adsSection,
      sectionSubcategories: sectionSubcategories ?? this.sectionSubcategories,
      sectionStatus: sectionStatus ?? this.sectionStatus,
      status: status ?? this.status,
      error: error,
      searchText: searchText ?? this.searchText,
      adsOnlyMode: adsOnlyMode ?? this.adsOnlyMode,
      currentPage: currentPage ?? this.currentPage,
      isLastPage: isLastPage ?? this.isLastPage,
    );
  }

  @override
  List<Object?> get props => [
        subCategories,
        companyTypes,
        adsSection,
        sectionSubcategories,
        sectionStatus,
        status,
        error,
        searchText,
        adsOnlyMode,
        currentPage,
        isLastPage,
      ];
}