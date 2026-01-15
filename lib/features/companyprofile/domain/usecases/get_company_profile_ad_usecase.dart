import 'package:oreed_clean/features/companyprofile/domain/entities/company_ad_entity.dart';
import 'package:oreed_clean/features/companyprofile/domain/repositories/company_profile_repo.dart';

class GetCompanyProfileAdsUseCase {
  final CompanyProfileRepository repository;
  GetCompanyProfileAdsUseCase(this.repository);

  Future<List<CompanyAdEntity>> call({
    required int companyId,
    required int sectionId,
    required int page,
  }) {
    return repository.getCompanyAds(
      companyId: companyId,
      sectionId: sectionId,
      page: page,
    );
  }
}
