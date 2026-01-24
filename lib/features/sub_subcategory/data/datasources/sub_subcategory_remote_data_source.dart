import 'dart:convert';
import 'dart:io' show HttpHeaders;
import 'package:http/http.dart' as http;
import 'package:oreed_clean/core/app_shared_prefs.dart';
import 'package:oreed_clean/features/home/data/models/related_ad_model.dart';
import 'package:oreed_clean/features/home/domain/entities/related_ad_entity.dart';
import 'package:oreed_clean/networking/api_provider.dart';
import '../models/sub_subcategory_model.dart';

class SubSubcategoryRemoteDataSource {
  Map<String, String> _buildHeaders({bool hasToken = false}) {
    final prefs = AppSharedPreferences();
    final headers = <String, String>{
      HttpHeaders.acceptHeader: 'application/json',
      "locale": AppSharedPreferences().languageCode ?? 'ar',
    };

    if (hasToken && prefs.userToken != null && prefs.userToken!.isNotEmpty) {
      headers[HttpHeaders.authorizationHeader] = 'Bearer ${prefs.userToken}';
    }
    return headers;
  }

  Future<List<SubSubcategoryModel>> getSubSubcategories(int categoryId) async {
    final url = Uri.parse(
      '${ApiProvider.baseUrl}/api/category_subcategories/$categoryId',
    );
    final response = await http.get(url, headers: _buildHeaders());

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List data = jsonData['data'] ?? [];
      return data.map((e) => SubSubcategoryModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to fetch sub-subcategories');
    }
  }

  Future<List<RelatedAdEntity>> getSubSubcategoryAds({
    required int sectionId,
    required int subCategoryId,
    int page = 1,
    int perPage = 10,
    String? searchText,
  }) async {
    // Build query parameters
    final queryParams = {
      'section_id': sectionId.toString(),
      'category_id': subCategoryId.toString(),
      'is_random': '1',
      'paginate': 'enabled',
      'per_page': perPage.toString(),
      'page': page.toString(),
    };

    // Add search text if provided
    if (searchText != null && searchText.isNotEmpty) {
      queryParams['texts'] = searchText;
    }

    final url = Uri.parse(
      '${ApiProvider.baseUrl}/api/advanced_filter',
    ).replace(queryParameters: queryParams);

    final response = await http.get(url, headers: _buildHeaders());

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List data = jsonData['data'] ?? [];
      return data.map((e) => RelatedAdModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to fetch ads');
    }
  }
}
