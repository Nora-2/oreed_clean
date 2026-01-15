import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:oreed_clean/core/app_shared_prefs.dart';
import 'package:oreed_clean/features/companyprofile/data/models/company_ad_model.dart';
import 'package:oreed_clean/networking/api_provider.dart';
import '../models/company_profile_model.dart';

class CompanyProfileRemoteDataSource {
  static final String baseUrl = '${ApiProvider.baseUrl}/api/v1';
  static final String filterUrl = '${ApiProvider.baseUrl}/api';

  Map<String, String> _buildHeaders({bool hasToken = false}) {
    final prefs = AppSharedPreferences();
    final headers = <String, String>{
      HttpHeaders.acceptHeader: 'application/json',
      "locale": AppSharedPreferences().languageCode ?? 'ar',
      // DO NOT set Content-Type here for multipart; the request will set it.
    };

    if (hasToken && prefs.userToken != null && prefs.userToken!.isNotEmpty) {
      headers[HttpHeaders.authorizationHeader] = 'Bearer ${prefs.userToken}';
    }
    return headers;
  }

  Future<CompanyProfileModel> getCompanyProfile(int companyId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/get_company/$companyId'),
      headers: _buildHeaders(),
    );
    if (response.statusCode == 200) {
      return CompanyProfileModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load company profile');
    }
  }

  Future<List<CompanyAdModel>> getCompanyAds({
    required int companyId,
    required int sectionId,
    required int page,
  }) async {
    final uri = Uri.parse(
      // '$filterUrl/advanced_filter?section_id=$sectionId&company_id=$companyId&page=$page',
      '$filterUrl/v1/adsByUserId?user_id=$companyId&paginate=enabled&per_page=100',
    );
    final response = await http.get(uri, headers: _buildHeaders());
    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'] as List;
      return data.map((e) => CompanyAdModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load company ads');
    }
  }
}
