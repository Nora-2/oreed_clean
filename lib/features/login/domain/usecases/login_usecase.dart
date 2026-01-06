import 'package:oreed_clean/features/login/domain/entities/user_entity.dart';
import 'package:oreed_clean/features/login/domain/repositories/auth_repo.dart';
import 'package:oreed_clean/core/utils/either.dart';
import 'package:oreed_clean/core/error/failures.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call(String phoneNumber, String password) {
    return repository.login(phoneNumber, password);
  }
}