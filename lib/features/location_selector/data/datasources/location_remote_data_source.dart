import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:oreed_clean/core/app_shared_prefs.dart';
import 'package:oreed_clean/features/comapany_register/data/models/country_model.dart';
import 'package:oreed_clean/features/comapany_register/data/models/state_model.dart';
import 'package:oreed_clean/networking/api_provider.dart';

class LocationRemoteDataSource {
  static final _baseUrl = '${ApiProvider.baseUrl}/api/v1';
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

  Future<List<CountryModel>> getStates(int countryId) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/states/1'),
      headers: _buildHeaders(),
    );
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final List list = decoded['data'] ?? [];
      return list.map((e) => CountryModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load states');
    }
  }

  Future<List<StateModel>> getCities(int stateId) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/cities/$stateId'),
      headers: _buildHeaders(),
    );
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final List list = decoded['data'] ?? [];
      return list.map((e) => StateModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load cities');
    }
  }
}
