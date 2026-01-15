import 'package:oreed_clean/features/company_types_by_company/domain/entities/company_types_entity.dart';
import 'package:oreed_clean/features/company_types_by_company/domain/repositories/company_types_company_repo.dart';
import '../datasources/company_types_company_remote_data_source.dart';

class CompanyTypesCompanyRepositoryImpl
    implements CompanyTypesCompanyRepository {
  final CompanyTypesCompanyRemoteDataSource remoteDataSource;

  CompanyTypesCompanyRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<CompanyTypeCompanyEntity>> getCompanyTypesByCompany(
    String companyId,
    Map? filter,
  ) {
    return remoteDataSource.fetchCompanyTypesByCompany(companyId, filter);
  }
}
