import 'package:oreed_clean/features/home/domain/entities/related_ad_entity.dart';
import '../entities/sub_category_entity.dart';
import '../entities/company_type_entity.dart';

abstract class SubCategoryRepository {
  Future<List<SubCategoryEntity>> getSubCategories(int sectionId);
  Future<List<CompanyTypeEntity>> getCompanyTypes(int sectionId);
  Future<List<RelatedAdEntity>> getAds({required int sectionId, int page = 1, String? searchText});
}