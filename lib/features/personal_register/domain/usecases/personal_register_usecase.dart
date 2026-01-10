import 'package:oreed_clean/features/personal_register/domain/repositories/personal_register_repo.dart';

import '../entities/register_response_entity.dart';

class PersonalRegisterUseCase {
  final PersonalRegisterRepository repository;

  PersonalRegisterUseCase(this.repository);

  Future<RegisterResponseEntity> call({
    required String name,
    required String phone,
    required String password,
    required String fcmToken,
  }) {
    return repository.registerPersonal(
      name: name,
      phone: phone,
      password: password,
      fcmToken: fcmToken,
    );
  }
}