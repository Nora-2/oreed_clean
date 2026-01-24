import 'package:oreed_clean/features/home/domain/entities/related_ad_entity.dart';
import '../../domain/entities/sub_subcategory_entity.dart';
import '../../domain/repositories/sub_subcategory_repository.dart';
import '../datasources/sub_subcategory_remote_data_source.dart';

class SubSubcategoryRepositoryImpl implements SubSubcategoryRepository {
  final SubSubcategoryRemoteDataSource remoteDataSource;

  SubSubcategoryRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<SubSubcategoryEntity>> getSubSubcategories(int categoryId) {
    return remoteDataSource.getSubSubcategories(categoryId);
  }

  @override
  Future<List<RelatedAdEntity>> getSubSubcategoryAds({
    required int sectionId,
    required int subCategoryId,
    int page = 1,
    int perPage = 10,
    String? searchText,
  }) {
    return remoteDataSource.getSubSubcategoryAds(
      sectionId: sectionId,
      subCategoryId: subCategoryId,
      page: page,
      perPage: perPage,
      searchText: searchText,
    );
  }
}
