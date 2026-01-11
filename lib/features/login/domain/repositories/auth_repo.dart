import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity> login({
    required String phone,
    required String password,
    required String fcmToken,
  });

  Future<void> register({
    required String name,
    required String phone,
    required String password,
    required String accountType,
    required String fcmToken,
  });

  Future<void> completeRegistration({
    required String phone,
    required String otp,
  });

  Future<bool> checkUser(String phone);

  Future<UserEntity> updateProfile(Map<String, dynamic> body);

  Future<UserEntity> getUserData(int id);

  Future<void> changePassword(Map<String, dynamic> body);

  Future<void> resetPassword(String phone);

  Future<void> updatePasswordWithOtp({
    required String phone,
    required String otp,
    required String password,
  });
}