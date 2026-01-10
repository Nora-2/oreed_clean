import 'package:oreed_clean/features/personal_register/domain/repositories/personal_register_repo.dart';
import '../../domain/entities/register_response_entity.dart';
import '../datasources/personal_register_remote_data_source.dart';

class PersonalRegisterRepositoryImpl implements PersonalRegisterRepository {
  final PersonalRegisterRemoteDataSource remoteDataSource;

  PersonalRegisterRepositoryImpl(this.remoteDataSource);

  @override
  Future<RegisterResponseEntity> registerPersonal({
    required String name,
    required String phone,
    required String password,
    required String fcmToken,
  }) async {
    return await remoteDataSource.registerPersonal(
      name: name,
      phone: phone,
      password: password,
      fcmToken: fcmToken,
    );
  }
}