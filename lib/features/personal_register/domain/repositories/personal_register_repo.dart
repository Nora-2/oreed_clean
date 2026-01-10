import '../entities/register_response_entity.dart';

abstract class PersonalRegisterRepository {
  Future<RegisterResponseEntity> registerPersonal({
    required String name,
    required String phone,
    required String password,
    required String fcmToken,
  });
}