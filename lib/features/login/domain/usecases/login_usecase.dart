import 'package:oreed_clean/features/login/domain/repositories/auth_repo.dart';
import '../entities/user_entity.dart';
class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<UserEntity> call({
    required String phone,
    required String password,
    required String fcmToken,
  }) async {
    return await repository.login(
      phone: phone,
      password: password,
      fcmToken: fcmToken,
    );
  }
}
