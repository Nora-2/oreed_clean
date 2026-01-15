// lib/features/ads/data/datasources/ads_remote_data_source.dart
import 'package:dio/dio.dart';
import 'package:oreed_clean/core/app_shared_prefs.dart';
import 'package:oreed_clean/features/companyprofile/data/models/delete_ad_result.dart';
import 'package:oreed_clean/networking/api_pathes.dart';

abstract class AdsRemoteDataSource {
  Future<DeleteAdResult> deleteCar(int adId);

  Future<DeleteAdResult> deleteProperty(int adId);

  Future<DeleteAdResult> deleteTechnician(int adId);

  Future<DeleteAdResult> deleteAnything(int adId, int sectionId);
}

class AdsRemoteDataSourceImpl implements AdsRemoteDataSource {
  final Dio dio;

  AdsRemoteDataSourceImpl(this.dio);

  Future<Map<String, String>> _buildHeaders() async {
    final token = AppSharedPreferences().getUserToken;
    return {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<DeleteAdResult> _delete({
    required String url,
    required Map<String, dynamic> data,
  }) async {
    final headers = await _buildHeaders();

    final response = await dio.post(
      'https://oreedo.net$url',
      data: FormData.fromMap(data),
      options: Options(headers: headers),
    );

    final json = response.data;
    final success = json['status'] == true;
    final msg = json['msg'] ?? 'حدث خطأ ما';

    return DeleteAdResult(success: success, message: msg);
  }

  @override
  Future<DeleteAdResult> deleteCar(int adId) async =>
      _delete(url: ApiPaths.deleteCar, data: {'ad_id': adId});

  @override
  Future<DeleteAdResult> deleteProperty(int adId) async =>
      _delete(url: ApiPaths.deleteProperty, data: {'ad_id': adId});

  @override
  Future<DeleteAdResult> deleteTechnician(int adId) async =>
      _delete(url: ApiPaths.deleteTechnician, data: {'ad_id': adId});

  @override
  Future<DeleteAdResult> deleteAnything(int adId, int sectionId) async =>
      _delete(url: ApiPaths.deleteAnything, data: {
        'ad_id': adId,
        'section_id': sectionId,
      });
}
