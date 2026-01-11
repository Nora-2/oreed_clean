import 'package:oreed_clean/features/comapany_register/domain/repositories/company_register_repo.dart';
import '../entities/register_response_entity.dart';
class RegisterCompanyUseCase {
  final CompanyRegisterRepository repository;

  RegisterCompanyUseCase(this.repository);

  Future<RegisterResponseEntity> call(Map<String, dynamic> body) =>
      repository.registerCompany(body);
}
