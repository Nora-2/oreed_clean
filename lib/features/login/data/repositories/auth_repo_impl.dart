import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:oreed_clean/features/login/domain/repositories/auth_repo.dart';

import '../../../../networking/optimized_api_client.dart';
import '../../domain/entities/user_entity.dart';
import '../models/login_response.dart';

class AuthRepositoryImpl implements AuthRepository {
  final OptimizedApiClient apiProvider;

  AuthRepositoryImpl(this.apiProvider);

  @override
  Future<UserEntity> login({
    required String phone,
    required String password,
    required String fcmToken,
  }) async {
    String? token = await FirebaseMessaging.instance.getToken();
    final response = await apiProvider.post("/api/login", {
      "phone": '965$phone',
      "password": password,
      "fcm_token": token,
    });
    print('cmkslcjiuehiuh3278fh23ifuc23');
    final res = LoginResponse.fromJson(response.data);
    log('Login response parsed: ${res.msg}');

    if (!res.status) {
      print('jicuewhcwjhebcehcw');
      print(res.msg);
      print(res.data);
      throw Exception(res.msg);
    }

    return res.toEntity();
  }
}
