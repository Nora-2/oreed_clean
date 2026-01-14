
import 'package:oreed_clean/features/companydetails/data/models/company_details_model.dart';
import 'package:oreed_clean/features/home/data/models/related_ad_model.dart';
import 'package:oreed_clean/features/home/domain/entities/related_ad_entity.dart';
import 'package:oreed_clean/networking/api_provider.dart';

class CompanyDetailsRemoteDataSource {
  final ApiProvider apiProvider;

  CompanyDetailsRemoteDataSource(this.apiProvider);

  Future<CompanyDetailsModel> getCompanyDetails(int companyId) async {
    final res = await apiProvider.get<CompanyDetailsModel>(
      '/api/v1/get_company/$companyId',
      parser: (json) => CompanyDetailsModel.fromJson(json),
    );

    // ✅ Safely handle nullable data
    final data = res.data;
    if (data == null) {
      throw Exception('Empty company details response');
    }
    return data;
  }

  Future<List<RelatedAdEntity>> getCompanyAds(
      int companyId, int sectionId, {String? searchText}) async {
    // Build URL with optional search text
    String url = '/api/advanced_filter?company_id=$companyId&section_id=$sectionId';
    if (searchText != null && searchText.trim().isNotEmpty) {
      url += '&texts=${Uri.encodeComponent(searchText.trim())}';
    }

    final res = await apiProvider.get<List<RelatedAdEntity>>(
      url,
      parser: (json) {
        final List data = json['data'] ?? [];
        return data.map((e) => RelatedAdModel.fromJson(e)).toList();
      },
    );

    // ✅ Safely handle nullable list
    final data = res.data;
    if (data == null) {
      throw Exception('Empty ads list response');
    }
    return data;
  }
}
