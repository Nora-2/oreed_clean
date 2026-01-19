import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:oreed_clean/core/app_shared_prefs.dart';
import 'package:oreed_clean/features/realstateform/data/models/realstate_detailes_model.dart';
import 'package:oreed_clean/features/realstateform/data/models/realstate_response_model.dart';
import 'package:oreed_clean/features/realstateform/domain/entities/realstate_entity.dart';
import 'package:oreed_clean/features/realstateform/domain/repositories/realstate_repo.dart';
import 'package:oreed_clean/networking/api_provider.dart';

class PropertyRemoteDataSource {
  static final String baseUrl = ApiProvider.baseUrl + '/api/v1';

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

  Future<PropertyResponseModel> createProperty(PropertyEntity property) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/create_property'),
    );
    // headers (include token if present)
    request.headers.addAll(_buildHeaders(hasToken: true));

    // only add fields that are non-null to avoid sending 'null' strings
    final Map<String, String> fieldsMap = {};
    if (property.companyId != null) {
      fieldsMap['company_id'] = property.companyId.toString();
      if (property.companyTypeId != null) {
        fieldsMap['company_type_id'] = property.companyTypeId.toString();
      }
    } else {
      fieldsMap['category_id'] = property.categoryId.toString();
      fieldsMap['sub_category_id'] = property.subCategoryId.toString();
    }

    void addField(String key, dynamic value) {
      if (value != null) fieldsMap[key] = value.toString();
    }

    addField('title_ar', property.titleAr);
    addField('description_ar', property.descriptionAr);
    addField('address_ar', property.addressAr);
    addField('section_id', property.sectionId);
    addField('price', property.price);
    addField('rooms', property.rooms);
    addField('bathrooms', property.bathrooms);
    addField('area', property.area);
    addField('floor', property.floor);
    addField('type', property.type);
    addField('state_id', property.stateId);
    addField('city_id', property.cityId);
    addField('user_id', property.userId);

    request.fields.addAll(fieldsMap);

    // Attach files: the API expects the main image under 'image' and gallery under 'images[]'.
    if (property.imagePaths.isNotEmpty) {
      for (int i = 0; i < property.imagePaths.length; i++) {
        final path = property.imagePaths[i];
        if (i == 0) {
          // main image
          request.files.add(await http.MultipartFile.fromPath('image', path));
        } else {
          // gallery images
          request.files.add(
            await http.MultipartFile.fromPath('images[]', path),
          );
        }
      }
    }
    print('djcikvjkebvewjvwvew3');
    print(request.fields);
    final res = await request.send();
    final body = await res.stream.bytesToString();
    print(json.decode(body));

    if (res.statusCode == 200) {
      try {
        return PropertyResponseModel.fromJson(json.decode(body));
      } catch (e) {
        throw HttpException('Invalid response when creating property: $e');
      }
    }

    // include server body in the exception to ease debugging
    throw HttpException(
      'create_property failed: ${res.statusCode} ${res.reasonPhrase} \n$body',
    );
  }

  // === Details ===
  Future<PropertyDetailsModel> getDetails(
    int id, {
    String language = 'ar',
  }) async {
    final req = http.MultipartRequest(
      'GET',
      Uri.parse('$baseUrl/get_property/$id'),
    );
    req.fields['locale'] = language;
    req.headers.addAll(_buildHeaders());
    final res = await req.send();
    final body = await res.stream.bytesToString();

    if (res.statusCode == 200) {
      return PropertyDetailsModel.fromJson(json.decode(body));
    }
    throw HttpException('get_property failed: ${res.reasonPhrase}');
  }

  // === Edit (partial allowed) ===
  Future<PropertyResponseModel> edit(EditPropertyParams params) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/edit_property'),
    );
    request.headers.addAll(_buildHeaders(hasToken: true));
    request.fields['ad_id'] = params.id.toString();

    // Only send provided fields (backend accepts partial updates)
    void addField(String k, String? v) {
      if (v != null && v.trim().isNotEmpty) request.fields[k] = v.trim();
    }

    addField('title_ar', params.titleAr);
    addField('description_ar', params.descriptionAr);
    addField('address_ar', params.addressAr);
    addField('price', params.price);
    addField('rooms', params.rooms);
    addField('bathrooms', params.bathrooms);
    addField('area', params.area);
    addField('floor', params.floor);
    addField('type', params.type);
    if (params.stateId != null) {
      request.fields['state_id'] = '${params.stateId}';
    }
    if (params.cityId != null) request.fields['city_id'] = '${params.cityId}';

    if (params.mainImage != null) {
      request.files.add(
        await http.MultipartFile.fromPath('image', params.mainImage!.path),
      );
    }
    for (final f in params.galleryImages) {
      request.files.add(await http.MultipartFile.fromPath('images[]', f.path));
    }
    print(request.fields);
    final streamed = await request.send();
    final body = await streamed.stream.bytesToString();
    if (streamed.statusCode == 200) {
      return PropertyResponseModel.fromJson(json.decode(body));
    }
    throw HttpException('edit_property failed: ${streamed.reasonPhrase}');
  }

  /// Remove an image attached to an ad. Returns true on success.
  Future<bool> removeImage({required int adId, required int imageId}) async {
    final uri = Uri.parse('$baseUrl/remove_property_image');

    var request = http.MultipartRequest('POST', uri);
    request.fields.addAll({
      'ad_id': adId.toString(),
      'image_id': imageId.toString(),
    });
    request.headers.addAll(_buildHeaders(hasToken: true));

    final res = await request.send();
    final body = await res.stream.bytesToString();

    if (res.statusCode == 200) {
      try {
        final j = json.decode(body);
        return (j['status'] == true) || (j['code'] == 200);
      } catch (_) {
        return true;
      }
    }

    if (res.statusCode == 404) {
      // fallback to car endpoint
      final uri2 = Uri.parse('$baseUrl/remove_car_image');
      var request2 = http.MultipartRequest('POST', uri2);
      request2.fields.addAll({
        'ad_id': adId.toString(),
        'image_id': imageId.toString(),
      });
      request2.headers.addAll(_buildHeaders(hasToken: true));
      final res2 = await request2.send();
      final body2 = await res2.stream.bytesToString();
      if (res2.statusCode == 200) {
        try {
          final j = json.decode(body2);
          return (j['status'] == true) || (j['code'] == 200);
        } catch (_) {
          return true;
        }
      }
    }

    return false;
  }
}
