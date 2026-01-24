import 'dart:developer';
import 'package:oreed_clean/features/home/data/models/related_ad_model.dart';
import 'package:oreed_clean/features/home/domain/entities/related_ad_entity.dart';
import 'package:oreed_clean/networking/api_provider.dart';

import '../../domain/entities/company_type_entity.dart';
import '../../domain/entities/sub_category_entity.dart';

class SubCategoryRemoteDataSource {
  final ApiProvider api;

  SubCategoryRemoteDataSource(this.api);

  Future<List<SubCategoryEntity>> getSubCategories(int sectionId) async {
    final res = await api.get('/api/get_categories_by_section/$sectionId');
    final data = res.data?['data'] ?? [];
    return List<SubCategoryEntity>.from(
      data.map((e) => SubCategoryEntity(
            id: e['id'],
            name: e['name'],
            image: e['image'] ?? '',
          )),
    );
  }

  Future<List<CompanyTypeEntity>> getCompanyTypes(int sectionId) async {
    final res = await api.get('/api/section_company_types/$sectionId');
    final data = res.data?['data'] ?? [];
    return List<CompanyTypeEntity>.from(
      data.map((e) =>
          CompanyTypeEntity(id: e['id'], name: e['name'], image: e['image'])),
    );
  }

  Future<List<RelatedAdEntity>> getAds({
    required int sectionId,
    int page = 1,
    String? searchText,
  }) async {
    // Build URL with optional search text
    String url = '/api/advanced_filter?section_id=$sectionId&paginate=enabled&per_page=10&page=$page';
    if (searchText != null && searchText.trim().isNotEmpty) {
      url += '&texts=${Uri.encodeComponent(searchText.trim())}';
      log('Fetching ads with search text: $searchText');
    }

    final res = await api.get(url);
    final data = res.data?['data'] ?? [];
    log('Fetched ${data.length} ads for section $sectionId');
    return List<RelatedAdEntity>.from(
      data.map((e) => RelatedAdModel.fromJson(e)),
    );
  }
}
