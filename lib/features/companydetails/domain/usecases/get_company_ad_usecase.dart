import 'package:oreed_clean/features/companydetails/domain/repositories/company_details_repo.dart';
import 'package:oreed_clean/features/home/domain/entities/related_ad_entity.dart';

class GetCompanyAdsUseCase {
  final CompanyDetailsRepository repository;

  GetCompanyAdsUseCase(this.repository);

  Future<List<RelatedAdEntity>> call(int companyId, int sectionId, {String? searchText}) {
    return repository.getCompanyAds(companyId, sectionId, searchText: searchText);
  }
}
