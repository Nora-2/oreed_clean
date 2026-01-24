import 'package:oreed_clean/features/home/domain/entities/related_ad_entity.dart';

import '../../domain/entities/sub_category_entity.dart';
import '../../domain/entities/company_type_entity.dart';
import '../../domain/repositories/sub_category_repository.dart';
import '../datasources/sub_category_remote_data_source.dart';

class SubCategoryRepositoryImpl implements SubCategoryRepository {
  final SubCategoryRemoteDataSource remote;
  SubCategoryRepositoryImpl(this.remote);

  @override
  Future<List<SubCategoryEntity>> getSubCategories(int sectionId) =>
      remote.getSubCategories(sectionId);

  @override
  Future<List<CompanyTypeEntity>> getCompanyTypes(int sectionId) =>
      remote.getCompanyTypes(sectionId);

  @override
  Future<List<RelatedAdEntity>> getAds(
          {required int sectionId, int page = 1, String? searchText}) =>
      remote.getAds(sectionId: sectionId, page: page, searchText: searchText);
}