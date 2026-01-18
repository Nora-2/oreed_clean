import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:oreed_clean/core/app_shared_prefs.dart';
import 'package:oreed_clean/features/forms/data/models/technican_detailes_mode.dart';
import 'package:oreed_clean/features/forms/data/models/technican_response_model.dart';
import 'package:oreed_clean/networking/api_provider.dart';
import '../../domain/entities/city_entity.dart';
import '../../domain/entities/state_entity.dart';
class TechnicianRemoteDataSource {
  static final String baseUrl = ApiProvider.baseUrl + '/api';

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

  Future<List<StateEntity>> getStates() async {
    print('$baseUrl/country_states/1');
    final res = await http.get(Uri.parse('$baseUrl/country_states/1'),
        headers: _buildHeaders());
    if (res.statusCode != 200) throw Exception('فشل تحميل المحافظات');
    final data = json.decode(res.body);
    final list = (data['data'] as List);
    return list.map((e) => StateEntity(id: e['id'], name: e['name'])).toList();
  }

  Future<List<CityEntity>> getCities(int stateId) async {
    final res = await http.get(Uri.parse('$baseUrl/state_cities/$stateId'),
        headers: _buildHeaders());
    if (res.statusCode != 200) throw Exception('فشل تحميل المدن');
    final data = json.decode(res.body);
    final list = (data['data'] as List);
    return list.map((e) => CityEntity(id: e['id'], name: e['name'])).toList();
  }

  Future<TechnicianResponseModel> createTechnicianAd({
    required String name,
    required String description,
    required String phone,
    required String whatsapp,
    required int userId,
    required int sectionId,
    required int categoryId,
    required int stateId,
    required int cityId,
    required File mainImage,
    required List<File> galleryImages,
    int? companyId,
    int? companyTypeId,
  }) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/v1/create_a_technician'),
    );
    print(companyId != null);
    print(companyId);
    print(companyTypeId);

    if (companyId != null) {
      request.fields.addAll({
        'company_id': '$companyId',
        'company_type_id': '$companyTypeId',
      });
    } else {
      request.fields.addAll({
        'category_id': '$categoryId',
        // 'sub_category_id': property.subCategoryId.toString(),
      });
    }
    request.fields.addAll({
      'name_ar': name,
      'description_ar': description,

      'user_id': '$userId',
      'section_id': '$sectionId',
      // 'category_id': '$categoryId',
      'state_id': '$stateId',
      'city_id': '$cityId',
    });

    request.files
        .add(await http.MultipartFile.fromPath('image', mainImage.path));
    for (final img in galleryImages) {
      request.files
          .add(await http.MultipartFile.fromPath('images[]', img.path));
    }
    print(request.fields);
    final res = await request.send();
    final body = await res.stream.bytesToString();
    print(body);
    print(body);
    if (res.statusCode == 200) {
      final jsonBody = json.decode(body);
      return TechnicianResponseModel.fromJson(jsonBody);
    } else {
      throw Exception('فشل الإرسال: ${res.reasonPhrase}');
    }
  }

  Future<TechnicianDetailsModel> getTechnicianDetails(int id) async {
    final url = Uri.parse('$baseUrl/v1/get_technician/$id');
    final res = await http.get(url, headers: _buildHeaders());
    if (res.statusCode != 200) {
      throw Exception('فشل تحميل بيانات الإعلان');
    }
    final jsonBody = json.decode(res.body);
    return TechnicianDetailsModel.fromJson(jsonBody);
  }

  Future<TechnicianResponseModel> editTechnicianAd({
    required int id,
    required String name,
    required String description,
    required String phone,
    required String whatsapp,
    required int userId,
    required int sectionId,
    required int categoryId,
    required int stateId,
    required int cityId,
    File? mainImage,
    List<File> galleryImages = const [],
    int? companyId,
    int? companyTypeId,
  }) async {
    print('editTechnicianAd');
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/v1/edit_technician'),
    );

    // same fields as create + id
    if (companyId != null) {
      request.fields.addAll({
        'company_id': '$companyId',
        'company_type_id': '${companyTypeId ?? ''}',
      });
    }
    request.headers.addAll(_buildHeaders());
    request.fields.addAll({
      'ad_id': '$id',
      'name_ar': name,
      'description_ar': description,
      'section_id': sectionId.toString(),
      'state_id': '$stateId',
      'city_id': '$cityId',
    });

    // On edit: images are optional. Only attach if user changed them.
    if (mainImage != null) {
      request.files.add(
        await http.MultipartFile.fromPath('image', mainImage.path),
      );
    }
    if (galleryImages.isNotEmpty) {
      for (final img in galleryImages) {
        request.files.add(
          await http.MultipartFile.fromPath('images[]', img.path),
        );
      }
    }

    print(request.fields.toString());
    request.headers.addAll(_buildHeaders(hasToken: true));

    final res = await request.send();
    final body = await res.stream.bytesToString();
    print(json.decode(body));
    if (res.statusCode == 200) {
      final jsonBody = json.decode(body);
      return TechnicianResponseModel.fromJson(jsonBody);
    } else {
      throw Exception('فشل التعديل: ${res.reasonPhrase}');
    }
  }
}
