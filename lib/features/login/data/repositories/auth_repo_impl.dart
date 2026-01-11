
import 'package:firebase_messaging/firebase_messaging.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repo.dart';
import '../models/login_response.dart';
import '../../../../networking/optimized_api_client.dart';

class AuthRepositoryImpl implements AuthRepository {
  final OptimizedApiClient apiProvider;

  AuthRepositoryImpl(this.apiProvider);

  @override
  Future<UserEntity> login({
    required String phone,
    required String password,
    required String fcmToken,
  }) async {
    // If token isn't passed, try to fetch it
    String? token = fcmToken.isEmpty 
        ? await FirebaseMessaging.instance.getToken() 
        : fcmToken;

    final response = await apiProvider.post("/api/login", {
      "phone": '965$phone', // Note: Country code prefixing
      "password": password,
      "fcm_token": token,
    });

    final res = LoginResponse.fromJson(response.data);

    if (!res.status) {
      throw Exception(res.msg);
    }

    return res.toEntity();
  }

  @override
  Future<void> register({
    required String name,
    required String phone,
    required String password,
    required String accountType,
    required String fcmToken,
  }) async {
    final response = await apiProvider.post("/api/register", {
      "name": name,
      "phone": phone,
      "password": password,
      "account_type": accountType,
      "fcm_token": fcmToken,
    });

    if (response.data['status'] == false) {
      throw Exception(response.data['msg'] ?? "Registration Failed");
    }
  }

  @override
  Future<void> completeRegistration({required String phone, required String otp}) async {
    final response = await apiProvider.post("/api/complete_registration", {
      "phone": phone,
      "otp": otp,
    });

    if (response.data['status'] == false) {
      throw Exception(response.data['msg'] ?? "OTP Verification Failed");
    }
  }

  @override
  Future<bool> checkUser(String phone) async {
    final response = await apiProvider.post("/api/check_user", {"phone1": phone});
    return response.data['status'] ?? false;
  }

  @override
  Future<UserEntity> updateProfile(Map<String, dynamic> body) async {
    final response = await apiProvider.post(
      "/api/edit_profile",
      body,
      hasToken: true,
      // isPut: true, // If your API client handles custom logic for PUT
    );
    
    final res = LoginResponse.fromJson(response.data);
    if (!res.status) throw Exception(res.msg);
    return res.toEntity();
  }

  @override
  Future<UserEntity> getUserData(int id) async {
    final response = await apiProvider.get("/api/profile/$id");
    final res = LoginResponse.fromJson(response.data);
    return res.toEntity();
  }

  @override
  Future<void> changePassword(Map<String, dynamic> body) async {
    final response = await apiProvider.post(
      "/api/change_password",
      body,
      // isPut: true,
    );
    if (response.data['status'] == false) {
      throw Exception(response.data['msg']);
    }
  }

  @override
  Future<void> resetPassword(String phone) async {
    final response = await apiProvider.post("/api/reset_password", {"phone": phone});
    if (response.data['status'] == false) {
      throw Exception(response.data['msg']);
    }
  }

  @override
  Future<void> updatePasswordWithOtp({
    required String phone,
    required String otp,
    required String password,
  }) async {
    final response = await apiProvider.post("/api/update_password", {
      "phone": phone,
      "otp": otp,
      "password": password,
    });
    if (response.data['status'] == false) {
      throw Exception(response.data['msg']);
    }
  }
}