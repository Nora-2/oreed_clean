import 'package:oreed_clean/features/comapany_register/domain/entities/comapny_response_entity.dart';
import 'package:oreed_clean/features/comapany_register/domain/repositories/company_repo.dart';
import '../entities/company_entity.dart';

class CreateCompanyUseCase {
  final CompanyRepository repository;

  CreateCompanyUseCase(this.repository);

  Future<CompanyResponseEntity> call(CompanyEntity company) {
    return repository.createCompany(company);
  }
}