import 'package:oreed_clean/features/companyprofile/domain/entities/company_ad_entity.dart';
import '../entities/company_profile_entity.dart';

abstract class CompanyProfileRepository {
  Future<CompanyProfileEntity> getCompanyProfile(int companyId);
  Future<List<CompanyAdEntity>> getCompanyAds({
    required int companyId,
    required int sectionId,
    required int page,
  });
}
