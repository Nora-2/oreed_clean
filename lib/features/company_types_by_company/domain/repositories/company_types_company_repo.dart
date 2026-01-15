import 'package:oreed_clean/features/company_types_by_company/domain/entities/company_types_entity.dart';

abstract class CompanyTypesCompanyRepository {
  Future<List<CompanyTypeCompanyEntity>> getCompanyTypesByCompany(
    String companyId,
    Map? filter,
  );
}
