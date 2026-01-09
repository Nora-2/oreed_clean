import 'package:dio/dio.dart';
import 'package:oreed_clean/networking/api_provider.dart';
import '../../../../networking/optimized_api_client.dart';
import '../models/login_response.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login({required String phone, required String password, String? fcmToken});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final OptimizedApiClient apiProvider;

  AuthRemoteDataSourceImpl(this.apiProvider);

  @override
  Future<UserModel> login({required String phone, required String password, String? fcmToken}) async {
    // Guard: ensure baseUrl is configured (not the placeholder)
    final base = ApiProvider.baseUrl;
    if (base.contains('example.com') || base.trim().isEmpty) {
      throw DioException(
        requestOptions: RequestOptions(path: '/api/login'),
        error: 'API baseUrl not configured. Please set baseUrl in lib/injection_container.dart to your API host.',
        type: DioExceptionType.badResponse,
      );
    }

    final response = await apiProvider.post('/api/login', {
      'phone': phone,
      'password': password,
      if (fcmToken != null) 'fcm_token': fcmToken,
    });

    final res = LoginResponse.fromJson(response.data as Map<String, dynamic>);
    if (!res.status) {
      throw DioException(
        requestOptions: RequestOptions(path: '/api/login'),
        error: res.msg,
        type: DioExceptionType.badResponse,
      );
    }

    return res.toModel();
  }
}
