import 'package:oreed_clean/features/company_types_by_company/domain/entities/company_types_entity.dart';
import 'package:oreed_clean/features/company_types_by_company/domain/repositories/company_types_company_repo.dart';

class GetCompanyTypesByCompanyUseCase {
  final CompanyTypesCompanyRepository repository;

  GetCompanyTypesByCompanyUseCase(this.repository);

  Future<List<CompanyTypeCompanyEntity>> call(String companyId, Map? filter) {
    return repository.getCompanyTypesByCompany(companyId, filter);
  }
}
