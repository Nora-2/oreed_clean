import 'package:oreed_clean/features/comapany_register/domain/entities/comapny_response_entity.dart';
import 'package:oreed_clean/features/comapany_register/domain/repositories/company_repo.dart';
import '../../domain/entities/company_entity.dart';
import '../datasources/company_remote_data_source.dart';

class CompanyRepositoryImpl implements CompanyRepository {
  final CompanyRemoteDataSource remoteDataSource;

  CompanyRepositoryImpl(this.remoteDataSource);

  @override
  Future<CompanyResponseEntity> createCompany(CompanyEntity company) {
    return remoteDataSource.createCompany(company);
  }
}