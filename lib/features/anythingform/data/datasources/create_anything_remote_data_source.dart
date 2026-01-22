import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:oreed_clean/core/app_shared_prefs.dart';
import 'package:oreed_clean/networking/api_provider.dart';
import '../../domain/usecases/edit_anything_usecase.dart';
import '../models/anything_details_model.dart';
import '../models/create_anything_response_model.dart';

class CreateAnythingRemoteDataSource {
  static final _baseUrl = ApiProvider.baseUrl + '/api/v1';

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

  Future<CreateAnythingResponseModel> createAnythingAd({
    required String nameAr,
    required String descriptionAr,
    required String price,
    required int userId,
    required int sectionId,
    required int categoryId,
    required int subCategoryId,
    required int stateId,
    required int cityId,
    required Map<String, dynamic> dynamicFields,
    required File mainImage,
    required List<File> galleryImages,
    int? companyId,
    int? companyTypeId,
  }) async {
    final uri = Uri.parse(_baseUrl + '/create_anything');
    final request = http.MultipartRequest('POST', uri);
    request.headers['Accept'] = 'application/json';

    if (companyId != null) {
      request.fields.addAll({
        'company_id': '$companyId',
        'company_type_id': '$companyTypeId',
      });
    } else {
      request.fields.addAll({
        'category_id': '$categoryId',
        // 'sub_category_id': '$subCategoryId',
      });
    }
    request.fields.addAll({
      'name_ar': nameAr,
      'price': price,
      'description_ar': descriptionAr,
      'user_id': userId.toString(),
      'section_id': sectionId.toString(),
      // 'category_id': categoryId.toString(),
      // 'sub_category_id': subCategoryId.toString(),
      'state_id': stateId.toString(),
      'city_id': cityId.toString(),
    });

    // ✅ Add dynamic fields
    dynamicFields.forEach((key, value) {
      if (value != null && value.toString().isNotEmpty) {
        request.fields[key] = value.toString();
      }
    });

    // ✅ Add main image
    request.files
        .add(await http.MultipartFile.fromPath('image', mainImage.path));

    // ✅ Add gallery images
    for (final file in galleryImages) {
      request.files
          .add(await http.MultipartFile.fromPath('images[]', file.path));
    }
    print(request.fields);

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    print(response.statusCode);
    print(json.decode(response.body));
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      return CreateAnythingResponseModel.fromJson(decoded);
    } else {
      throw Exception('Failed to create ad: ${response.reasonPhrase}');
    }
  }

  Future<CreateAnythingResponseModel> edit(EditAnythingParams p) async {
    final req = http.MultipartRequest('POST', Uri.parse(_baseUrl + '/edit_anything'));
    req.headers.addAll(_buildHeaders(hasToken: true));

    req.fields['ad_id'] = '${p.adId}';
    req.fields['section_id'] = '${p.sectionId}';
    if (p.nameAr != null) req.fields['name_ar'] = p.nameAr!;
    if (p.descriptionAr != null) {
      req.fields['description_ar'] = p.descriptionAr!;
    }
    if (p.price != null) req.fields['price'] = p.price!;
    if (p.categoryId != null) req.fields['category_id'] = '${p.categoryId}';
    if (p.subCategoryId != null) {
      req.fields['sub_category_id'] = '${p.subCategoryId}';
    }
    if (p.stateId != null) req.fields['state_id'] = '${p.stateId}';
    if (p.cityId != null) req.fields['city_id'] = '${p.cityId}';
    if (p.dynamicFields != null) {
      p.dynamicFields!.forEach((k, v) {
        if (v != null && v.toString().isNotEmpty) req.fields[k] = v.toString();
      });
    }
    if (p.mainImage != null) {
      req.files
          .add(await http.MultipartFile.fromPath('image', p.mainImage!.path));
    }
    if (p.galleryImages != null) {
      for (final f in p.galleryImages!) {
        req.files.add(await http.MultipartFile.fromPath('images[]', f.path));
      }
    }
    print(req.fields);
    final res = await req.send();
    print(res.statusCode);
    final body = await res.stream.bytesToString();
    print('edit response: ${json.decode(body)}');
    if (res.statusCode == 200) {
      return CreateAnythingResponseModel.fromJson(json.decode(body));
    }
    throw Exception('Edit failed: ${res.reasonPhrase}');
  }

  Future<AnythingDetailsModel> getDetails(
      {required int adId, required int sectionId}) async {
    final uri =
        Uri.parse('$_baseUrl/get_anything/?section_id=$sectionId&ad_id=$adId');
    final res = await http.get(uri, headers: _buildHeaders(hasToken: false));
    if (res.statusCode == 200) {
      final decoded = json.decode(res.body);
      return AnythingDetailsModel.fromJson(decoded);
    }
    throw Exception('Details failed: ${res.reasonPhrase}');
  }
}
