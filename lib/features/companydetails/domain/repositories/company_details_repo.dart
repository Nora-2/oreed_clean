import 'package:oreed_clean/features/home/domain/entities/related_ad_entity.dart';
import '../entities/company_entity.dart';

abstract class CompanyDetailsRepository {
  Future<CompanyDetailsEntity> getCompanyDetails(int companyId);

  Future<List<RelatedAdEntity>> getCompanyAds(int companyId, int sectionId, {String? searchText});
}
