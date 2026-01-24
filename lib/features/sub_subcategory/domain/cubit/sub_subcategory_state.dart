part of 'sub_subcategory_cubit.dart';

enum SubSubcategoryStatus { idle, loading, loaded, error }

class SubSubcategoryState extends Equatable {
  final List<SubSubcategoryEntity> subcategories;
  final List<RelatedAdEntity> ads;
  final SubSubcategoryStatus status;
  final String? errorMessage;
  final String? searchText;

  const SubSubcategoryState({
    this.subcategories = const [],
    this.ads = const [],
    this.status = SubSubcategoryStatus.idle,
    this.errorMessage,
    this.searchText,
  });

  SubSubcategoryState copyWith({
    List<SubSubcategoryEntity>? subcategories,
    List<RelatedAdEntity>? ads,
    SubSubcategoryStatus? status,
    String? errorMessage,
    String? searchText,
  }) {
    return SubSubcategoryState(
      subcategories: subcategories ?? this.subcategories,
      ads: ads ?? this.ads,
      status: status ?? this.status,
      errorMessage: errorMessage,
      searchText: searchText ?? this.searchText,
    );
  }

  @override
  List<Object?> get props => [
        subcategories,
        ads,
        status,
        errorMessage,
        searchText,
      ];
}