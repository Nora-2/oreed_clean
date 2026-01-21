import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:oreed_clean/core/app_shared_prefs.dart';
import 'package:oreed_clean/features/carform/data/models/cardetailes_model.dart';
import '../../domain/entities/brand_entity.dart';
import '../../domain/entities/car_model_entity.dart';
import '../models/car_response_model.dart';

class CarAdsRemoteDataSource {
  static const String baseUrl = 'https://oreedo.net/api/v1';

  Map<String, String> _buildHeaders({bool hasToken = false}) {
    final prefs = AppSharedPreferences();
    final headers = <String, String>{
      HttpHeaders.acceptHeader: 'application/json',
      "locale": AppSharedPreferences().languageCode ?? 'ar',
      // DO NOT set Content-Type here for multipart; the request will set it.
    };

    if (hasToken && prefs.userToken != null && prefs.userToken!.isNotEmpty) {
      print(prefs.userToken);
      headers[HttpHeaders.authorizationHeader] = 'Bearer ${prefs.userToken}';
    }
    return headers;
  }

  Future<List<BrandEntity>> getBrands(int sectionId) async {
    final res = await http.get(
        Uri.parse('$baseUrl/../section_brands/$sectionId'),
        headers: _buildHeaders());
    if (res.statusCode != 200) throw Exception('Failed to load brands');
    final data = json.decode(res.body);
    final list = (data['data'] as List);
    return list
        .map(
            (e) => BrandEntity(id: e['id'], name: e['name'], image: e['image']))
        .toList();
  }

  Future<List<CarModelEntity>> getModels(int brandId) async {
    final res = await http.get(
        Uri.parse('$baseUrl/../brand_carmodels/$brandId'),
        headers: _buildHeaders());
    if (res.statusCode != 200) throw Exception('Failed to load models');
    final data = json.decode(res.body);
    final list = (data['data'] as List);
    return list
        .map((e) => CarModelEntity(id: e['id'], name: e['name']))
        .toList();
  }

  Future<CarResponseModel> createCarAd({
    required String titleAr,
    required String descriptionAr,
    required String price,
    required int userId,
    required int sectionId,
    required int categoryId,
    required int subCategoryId,
    required int brandId,
    required int carModelId,
    required int stateId,
    required int cityId,
    required String color,
    required String year,
    required String kilometers,
    required String engineSize,
    required String condition,
    required String fuelType,
    required String transmission,
    required String paintCondition,
    required File mainImage,
    required List<File> certImages,
    required List<File> galleryImages,
    int? companyId,
    int? companyTypeId,
  }) async {
    debugLog('CREATE CAR AD', 'Started');

    final uri = Uri.parse('$baseUrl/create_car');
    debugLog('REQUEST URL', uri);

    final request = http.MultipartRequest('POST', uri);

    /// 🔐 Headers
    final headers = _buildHeaders(hasToken: true);
    request.headers.addAll(headers);
    debugLog('HEADERS', headers);

    /// 📝 Fields
    final fields = <String, String>{
      'title_ar': titleAr,
      'description_ar': descriptionAr,
      'price': price,
      'user_id': '$userId',
      'section_id': '$sectionId',
      'brand_id': '$brandId',
      'car_model_id': '$carModelId',
      'state_id': '$stateId',
      'city_id': '$cityId',
      'color': color,
      'year': year,
      'kilometers': kilometers,
      'engine_size': engineSize,
      'condition': condition,
      'fuel_type': fuelType,
      'transmission': transmission,
      'paint_condition': paintCondition,
    };

    if (companyId != null) {
      fields.addAll({
        'company_id': '$companyId',
        'company_type_id': '$companyTypeId',
      });
    } else {
      fields.addAll({
        'category_id': '$categoryId',
        'sub_category_id': '$subCategoryId',
      });
    }

    request.fields.addAll(fields);
    debugLog('FIELDS', fields);

    /// 🖼️ Main Image
    debugLog('MAIN IMAGE', mainImage.path);
    request.files.add(
      await http.MultipartFile.fromPath('image', mainImage.path),
    );

    /// 🧾 Certificate Images
    for (final cert in certImages) {
      debugLog('CERT IMAGE', cert.path);
      request.files.add(
        await http.MultipartFile.fromPath('image_cert', cert.path),
      );
    }

    /// 🖼️ Gallery Images
    for (final img in galleryImages) {
      debugLog('GALLERY IMAGE', img.path);
      request.files.add(
        await http.MultipartFile.fromPath('images[]', img.path),
      );
    }

    /// 🚀 SEND REQUEST
    debugLog('REQUEST SEND', 'Sending...');
    final res = await request.send();

    debugLog('STATUS CODE', res.statusCode);

    final body = await res.stream.bytesToString();
    debugLog('RESPONSE BODY', body);

    /// ✅ Handle Response
    if (res.statusCode == 200 || res.statusCode == 400) {
      return CarResponseModel.fromJson(json.decode(body));
    } else if (res.statusCode == 401) {
      throw Exception('Unauthorized – Token مشكلة');
    } else {
      throw Exception('Upload failed: ${res.reasonPhrase}');
    }
  }

  void debugLog(String title, dynamic data) {
    if (kDebugMode) {
      debugPrint('================ $title ================');
      debugPrint(data.toString());
      debugPrint('========================================');
    }
  }

  Future<CarDetailsModel> getCarDetails(int id) async {
    print('getCarDetails');
    final res = await http.get(
      Uri.parse('$baseUrl/get_car/$id'),
    );
    print(res.statusCode);
    print(res.body);
    print(res.request!.url);
    if (res.statusCode != 200) {
      throw Exception('Failed to load car details');
    }
    final data = json.decode(res.body);
    return CarDetailsModel.fromJson(data);
  }

  Future<CarResponseModel> editCarAd({
    required int id,
    required String titleAr,
    required String descriptionAr,
    required String price,
    required int userId,
    required int sectionId,
    required int categoryId,
    required int subCategoryId,
    required int brandId,
    required int carModelId,
    required int stateId,
    required int cityId,
    required String color,
    required String year,
    required String kilometers,
    required String engineSize,
    required String condition,
    required String fuelType,
    required String transmission,
    required String paintCondition,
    File? mainImage,
    List<File> certImages = const [],
    List<File> galleryImages = const [],
    int? companyId,
    int? companyTypeId,
  }) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/edit_car'),
    );

    if (companyId != null) {
      request.fields.addAll({
        'company_id': '$companyId',
        'company_type_id': '${companyTypeId ?? ''}',
      });
    }

    request.fields.addAll({
      'ad_id': '$id', // IMPORTANT
      'title_ar': titleAr,
      'description_ar': descriptionAr,
      'price': price,
      'brand_id': '$brandId',
      'car_model_id': '$carModelId',
      'state_id': '$stateId',
      'city_id': '$cityId',
      'color': color,
      'year': year,
      'kilometers': kilometers,
      'engine_size': engineSize,
      'condition': condition,
      'fuel_type': fuelType,
      'transmission': transmission,
      'paint_condition': paintCondition,
    });
    print(request.fields);
    // Optional files on edit: only attach if user changed/added them
    if (mainImage != null) {
      request.files
          .add(await http.MultipartFile.fromPath('image', mainImage.path));
    }
    if (certImages.isNotEmpty) {
      for (final cert in certImages) {
        request.files
            .add(await http.MultipartFile.fromPath('image_cert', cert.path));
      }
    }
    if (galleryImages.isNotEmpty) {
      for (final img in galleryImages) {
        request.files
            .add(await http.MultipartFile.fromPath('images[]', img.path));
      }
    }

    request.headers.addAll(_buildHeaders(hasToken: true));
    print('-------------=======================---------------');
    print(request.fields);
    final res = await request.send();
    final body = await res.stream.bytesToString();
    print(json.decode(body));

    if (res.statusCode == 200) {
      return CarResponseModel.fromJson(json.decode(body));
    } else {
      throw Exception('Edit failed: ${res.reasonPhrase}');
    }
  }
}
