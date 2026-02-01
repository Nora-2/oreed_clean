import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:oreed_clean/core/network/api_constants.dart';
import 'package:oreed_clean/core/network/api_error_handler.dart';
import 'package:oreed_clean/core/network/api_result.dart';
import 'package:oreed_clean/core/network/api_services.dart';
import 'package:oreed_clean/features/login/data/models/login_response.dart';
import 'package:oreed_clean/features/login/domain/entities/user_entity.dart';
import 'package:oreed_clean/features/login/domain/repositories/auth_repo.dart';

class AuthRepositoryImpl implements AuthRepository {
  final ApiService _apiService;

  AuthRepositoryImpl(this._apiService);

  @override
  Future<ApiResult<UserEntity>> login({
    required String phone,
    required String password,
    required String fcmToken,
  }) async {
    String? token = fcmToken.isEmpty 
        ? await FirebaseMessaging.instance.getToken() 
        : fcmToken;

    final result = await _apiService.post<LoginResponse>(
      endpoint: ApiConstants.login,
      data: {
        "phone": '965$phone',
        "password": password,
        "fcm_token": token,
      },
      fromJson: (json) => LoginResponse.fromJson(json),
    );

    return result.when(
      success: (loginResponse) {
        if (loginResponse.status) {
          return ApiResult.success(loginResponse.toEntity());
        } else {
          // Handle logic error (status is false)
          return ApiResult.failure(ErrorHandler.handle(loginResponse.msg));
        }
      },
      failure: (error) => ApiResult.failure(error),
    );
  }

  @override
  Future<ApiResult<void>> register({
    required String name,
    required String phone,
    required String password,
    required String accountType,
    required String fcmToken,
  }) async {
    final result = await _apiService.post<Map<String, dynamic>>(
      endpoint: ApiConstants.register,
      data: {
        "name": name,
        "phone": phone,
        "password": password,
        "account_type": accountType,
        "fcm_token": fcmToken,
      },
      fromJson: (json) => json as Map<String, dynamic>,
    );

    return result.when(
      success: (data) {
        if (data['status'] == true) {
          return const ApiResult.success(null);
        } else {
          return ApiResult.failure(ErrorHandler.handle(data['msg'] ?? "Registration Failed"));
        }
      },
      failure: (error) => ApiResult.failure(error),
    );
  }

  @override
  Future<ApiResult<void>> completeRegistration({
    required String phone,
    required String otp,
  }) async {
    final result = await _apiService.post<Map<String, dynamic>>(
      endpoint: ApiConstants.completeRegistration,
      data: {"phone": phone, "otp": otp},
      fromJson: (json) => json as Map<String, dynamic>,
    );

    return result.when(
      success: (data) {
        if (data['status'] == true) return const ApiResult.success(null);
        return ApiResult.failure(ErrorHandler.handle(data['msg'] ?? "OTP Failed"));
      },
      failure: (error) => ApiResult.failure(error),
    );
  }

  @override
  Future<ApiResult<bool>> checkUser(String phone) async {
    final result = await _apiService.post<Map<String, dynamic>>(
      endpoint: ApiConstants.checkUser,
      data: {"phone1": phone},
      fromJson: (json) => json as Map<String, dynamic>,
    );

    return result.when(
      success: (data) => ApiResult.success(data['status'] ?? false),
      failure: (error) => ApiResult.failure(error),
    );
  }

  @override
  Future<ApiResult<UserEntity>> updateProfile(Map<String, dynamic> body) async {
    final result = await _apiService.post<LoginResponse>(
      endpoint: ApiConstants.editProfile,
      data: body,
      fromJson: (json) => LoginResponse.fromJson(json),
    );

    return result.when(
      success: (loginResponse) {
        if (loginResponse.status) return ApiResult.success(loginResponse.toEntity());
        return ApiResult.failure(ErrorHandler.handle(loginResponse.msg));
      },
      failure: (error) => ApiResult.failure(error),
    );
  }

  @override
  Future<ApiResult<UserEntity>> getUserData(int id) async {
    final result = await _apiService.get<LoginResponse>(
      endpoint: "/api/profile/$id",
      fromJson: (json) => LoginResponse.fromJson(json),
    );

    return result.when(
      success: (loginResponse) => ApiResult.success(loginResponse.toEntity()),
      failure: (error) => ApiResult.failure(error),
    );
  }

  @override
  Future<ApiResult<void>> changePassword(Map<String, dynamic> body) async {
    final result = await _apiService.post<Map<String, dynamic>>(
      endpoint: ApiConstants.changePassword,
      data: body,
      fromJson: (json) => json as Map<String, dynamic>,
    );

    return result.when(
      success: (data) {
        if (data['status'] == true) return const ApiResult.success(null);
        return ApiResult.failure(ErrorHandler.handle(data['msg']));
      },
      failure: (error) => ApiResult.failure(error),
    );
  }

  @override
  Future<ApiResult<void>> resetPassword(String phone) async {
    final result = await _apiService.post<Map<String, dynamic>>(
      endpoint: ApiConstants.resetPassword,
      data: {"phone": phone},
      fromJson: (json) => json as Map<String, dynamic>,
    );

    return result.when(
      success: (data) {
        if (data['status'] == true) return const ApiResult.success(null);
        return ApiResult.failure(ErrorHandler.handle(data['msg']));
      },
      failure: (error) => ApiResult.failure(error),
    );
  }

  @override
  Future<ApiResult<void>> updatePasswordWithOtp({
    required String phone,
    required String otp,
    required String password,
  }) async {
    final result = await _apiService.post<Map<String, dynamic>>(
      endpoint: ApiConstants.updatePassword,
      data: {"phone": phone, "otp": otp, "password": password},
      fromJson: (json) => json as Map<String, dynamic>,
    );

    return result.when(
      success: (data) {
        if (data['status'] == true) return const ApiResult.success(null);
        return ApiResult.failure(ErrorHandler.handle(data['msg']));
      },
      failure: (error) => ApiResult.failure(error),
    );
  }
}