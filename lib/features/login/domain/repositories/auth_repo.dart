import 'package:oreed_clean/features/login/domain/entities/user_entity.dart';
import 'package:oreed_clean/core/utils/either.dart';
import 'package:oreed_clean/core/error/failures.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> login(String phoneNumber, String password);
}