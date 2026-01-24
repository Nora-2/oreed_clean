import 'package:oreed_clean/features/home/domain/entities/related_ad_entity.dart';
import '../entities/sub_subcategory_entity.dart';

abstract class SubSubcategoryRepository {
  Future<List<SubSubcategoryEntity>> getSubSubcategories(int categoryId);

  Future<List<RelatedAdEntity>> getSubSubcategoryAds({
    required int sectionId,
    required int subCategoryId,
    int page,
    int perPage,
    String? searchText,
  });
}
