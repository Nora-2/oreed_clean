import 'package:oreed_clean/core/network/api_result.dart';
import 'package:oreed_clean/features/login/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<ApiResult<UserEntity>> login({
    required String phone,
    required String password,
    required String fcmToken,
  });

  Future<ApiResult<void>> register({
    required String name,
    required String phone,
    required String password,
    required String accountType,
    required String fcmToken,
  });

  Future<ApiResult<void>> completeRegistration({
    required String phone,
    required String otp,
  });

  Future<ApiResult<bool>> checkUser(String phone);

  Future<ApiResult<UserEntity>> updateProfile(Map<String, dynamic> body);

  Future<ApiResult<UserEntity>> getUserData(int id);

  Future<ApiResult<void>> changePassword(Map<String, dynamic> body);

  Future<ApiResult<void>> resetPassword(String phone);

  Future<ApiResult<void>> updatePasswordWithOtp({
    required String phone,
    required String otp,
    required String password,
  });
}