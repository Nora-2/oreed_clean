import 'package:oreed_clean/features/settings/data/models/page_model.dart';
import 'package:oreed_clean/networking/optimized_api_client.dart';

class MoreRepository {
  factory MoreRepository() => _dataRepository;
  static final MoreRepository _dataRepository = MoreRepository._internal();

  MoreRepository._internal();

  final OptimizedApiClient _provider = OptimizedApiClient();

  Future<List<PageModel>> fetchPages() async {
    try {
      final response = await _provider.get("/api/v1/pages");
      final data = response.data;

      // Handle the API response structure
      List<PageModel> list = [];

      // Check if data has 'data' key (new API response format)
      if (data is Map<String, dynamic> && data.containsKey('data')) {
        final pagesList = data['data'] as List?;
        if (pagesList != null) {
          for (var _page in pagesList) {
            PageModel pageModel = PageModel.fromJson(_page);
            list.add(pageModel);
          }
        }
      }
      // Check if data has 'pages' key (old API response format)
      else if (data is Map<String, dynamic> && data.containsKey('pages')) {
        final pagesList = data['pages'] as List?;
        if (pagesList != null) {
          for (var _page in pagesList) {
            PageModel pageModel = PageModel.fromJson(_page);
            list.add(pageModel);
          }
        }
      }

      return list;
    } catch (e) {
      print('Error fetching pages: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> sendContactUsMsg({required Map body}) async {
    print(body);
    // New API requires Bearer token and multipart/form-data
    final response = await _provider.post(
      "/api/contactus",
      body,
      hasToken: true,
    );

    // Return decoded JSON map for easier consumption by callers
    final data = response.data;

    if (data is Map<String, dynamic>) return data;
    // Fallback: wrap non-map responses
    return {"status": true, "data": data};
  }

  Future<Map<String, dynamic>> deleteAccount() async {
    final response = await _provider.delete<Map<String, dynamic>>(
      "/api/delete_account",
      hasToken: true,
    );
    final data = response.data;
    if (data is Map<String, dynamic>) return data;
    return {"status": true, "data": data};
  }
}
