import 'package:oreed_clean/features/companyprofile/domain/entities/company_ad_entity.dart';
import 'package:oreed_clean/features/companyprofile/domain/repositories/company_profile_repo.dart';
import '../../domain/entities/company_profile_entity.dart';
import '../datasources/company_profile_remote_data_source.dart';

class CompanyProfileRepositoryImpl implements CompanyProfileRepository {
  final CompanyProfileRemoteDataSource remoteDataSource;

  CompanyProfileRepositoryImpl(this.remoteDataSource);

  @override
  Future<CompanyProfileEntity> getCompanyProfile(int companyId) {
    return remoteDataSource.getCompanyProfile(companyId);
  }

  @override
  Future<List<CompanyAdEntity>> getCompanyAds({
    required int companyId,
    required int sectionId,
    required int page,
  }) {
    return remoteDataSource.getCompanyAds(
      companyId: companyId,
      sectionId: sectionId,
      page: page,
    );
  }
}
