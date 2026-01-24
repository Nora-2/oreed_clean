import 'package:oreed_clean/features/home/domain/entities/related_ad_entity.dart';
import '../repositories/sub_subcategory_repository.dart';

class GetSubSubcategoryAdsUseCase {
  final SubSubcategoryRepository repository;

  GetSubSubcategoryAdsUseCase(this.repository);

  Future<List<RelatedAdEntity>> call({
    required int sectionId,
    required int subCategoryId,
    int page = 1,
    int perPage = 10,
    String? searchText,
  }) {
    return repository.getSubSubcategoryAds(
      sectionId: sectionId,
      subCategoryId: subCategoryId,
      page: page,
      perPage: perPage,
      searchText: searchText,
    );
  }
}