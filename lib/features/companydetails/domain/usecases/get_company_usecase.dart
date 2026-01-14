import 'package:oreed_clean/features/companydetails/domain/repositories/company_details_repo.dart';
import '../entities/company_entity.dart';

class GetCompanyDetailsUseCase {
  final CompanyDetailsRepository repository;

  GetCompanyDetailsUseCase(this.repository);

  Future<CompanyDetailsEntity> call(int companyId) {
    return repository.getCompanyDetails(companyId);
  }
}
