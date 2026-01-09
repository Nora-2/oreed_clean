// lib/repository/advanced_search_repository.dart

import 'dart:developer';

import 'package:oreed_clean/features/AdvancedSearch/data/models/advanced_search_model.dart';
import 'package:oreed_clean/networking/optimized_api_client.dart';

class AdvancedSearchRepository {
  static final AdvancedSearchRepository _instance =
      AdvancedSearchRepository._internal();
  factory AdvancedSearchRepository() => _instance;
  AdvancedSearchRepository._internal();

  final OptimizedApiClient _provider = OptimizedApiClient();

  Future<AdvancedSearchResponse> advancedSearch({
    required String searchText,
    int page = 1,
    int perPage = 10,
  }) async {
    try {
      // Build the URL with query parameters
      final url =
          '/api/AdvancedSearch?texts=$searchText&paginate=enabled&per_page=$perPage&page=$page';

      log('🔍 Advanced Search Request: $url');

      final response = await _provider.get(
        url,
        hasToken: false, // Change to true if authentication is required
      );

      log('✅ Advanced Search Response: ${response.data}');

      // Parse the response
      final searchResponse = AdvancedSearchResponse.fromJson(response.data);
      return searchResponse;
    } catch (e, stackTrace) {
      log('❌ Advanced Search Error: $e');
      log('Stack Trace: $stackTrace');
      rethrow;
    }
  }

  /// Get more details if needed (optional - for future expansion)
  Future<Map<String, dynamic>> getCompanyDetails(int companyId) async {
    try {
      final url = '/api/companies/$companyId';
      final response = await _provider.get(url, hasToken: false);
      return response.data;
    } catch (e) {
      log('❌ Get Company Details Error: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getCategoryDetails(int categoryId) async {
    try {
      final url = '/api/categories/$categoryId';
      final response = await _provider.get(url, hasToken: false);
      return response.data;
    } catch (e) {
      log('❌ Get Category Details Error: $e');
      rethrow;
    }
  }
}

