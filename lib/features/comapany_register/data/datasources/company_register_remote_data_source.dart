import 'dart:io';
import 'package:oreed_clean/features/comapany_register/data/models/category_model.dart';
import 'package:oreed_clean/features/comapany_register/data/models/country_model.dart';
import 'package:oreed_clean/features/comapany_register/data/models/register_response_model.dart';
import 'package:oreed_clean/features/comapany_register/data/models/state_model.dart';
import 'package:oreed_clean/networking/api_provider.dart';

import '../../../home/data/models/section_model.dart';


class CompanyRegisterRemoteDataSource {
  final ApiProvider apiProvider;

  CompanyRegisterRemoteDataSource(this.apiProvider);

  Future<List<CountryModel>> fetchCountries() async {
    final res = await apiProvider.get(
      "/api/country_states/1",
      parser: (json) => json,
    );

    final list = (res.data?['data'] as List?) ?? [];
    return list.map((e) => CountryModel.fromJson(e)).toList();
  }

  // ✅ Fetch all sections dynamically
  Future<List<SectionModel>> fetchSections() async {
    final res = await apiProvider.get(
      "/api/get_sections",
      parser: (json) => json,
    );

    final list = (res.data?['data'] as List?) ?? [];
    return list.map((e) => SectionModel.fromJson(e)).toList();
  }

  /// ✅ Fetch states (governorates) for a country
  Future<List<StateModel>> fetchStates(int countryId) async {
    final res = await apiProvider.get(
      "/api/state_cities/$countryId",
      parser: (json) => json,
    );

    final list = (res.data?['data'] as List?) ?? [];
    return list.map((e) => StateModel.fromJson(e)).toList();
  }

  /// ✅ Fetch categories by main section (1=cars, 2=properties)
  Future<List<CategoryModel>> fetchCategoriesBySection(int sectionId) async {
    final res = await apiProvider.get(
      "/api/section_company_types/$sectionId",
      parser: (json) => json,
    );

    final list = (res.data?['data'] as List?) ?? [];
    return list.map((e) => CategoryModel.fromJson(e)).toList();
  }
  Future<RegisterResponseModelcomapny> registerCompany(
      Map<String, dynamic> body) async {
    // Detect if an image file is present and ensure it's handled correctly
    body.values.any((v) => v is File);

    final res = await apiProvider.post(
      "/api/register",
      body,
      hasToken: false,
      parser: (json) => json,
    );
  
    // ✅ Defensive check — sometimes API returns {status, msg}, sometimes {data: {...}}
    final data = res.data is Map<String, dynamic>
        ? (res.data as Map<String, dynamic>)
        : (res.data?['data'] ?? {});
   

    return RegisterResponseModelcomapny.fromJson(data);
  }
}
