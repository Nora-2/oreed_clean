import 'package:oreed_clean/features/home/domain/entities/related_ad_entity.dart';
import '../repositories/sub_category_repository.dart';

class GetSubCategoryAdsUseCase {
  final SubCategoryRepository repository;

  GetSubCategoryAdsUseCase(this.repository);

  Future<List<RelatedAdEntity>> call(
          {required int sectionId, int page = 1, String? searchText}) =>
      repository.getAds(
          sectionId: sectionId, page: page, searchText: searchText);
}
