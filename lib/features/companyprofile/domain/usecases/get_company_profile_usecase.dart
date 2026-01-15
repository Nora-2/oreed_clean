import 'package:oreed_clean/features/companyprofile/domain/repositories/company_profile_repo.dart';
import '../entities/company_profile_entity.dart';

class GetCompanyProfileUseCase {
  final CompanyProfileRepository repository;
  GetCompanyProfileUseCase(this.repository);

  Future<CompanyProfileEntity> call(int companyId) {
    return repository.getCompanyProfile(companyId);
  }
}
