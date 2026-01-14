import 'package:oreed_clean/features/companydetails/domain/entities/company_entity.dart';
import 'package:oreed_clean/features/companydetails/domain/repositories/company_details_repo.dart';
import 'package:oreed_clean/features/home/domain/entities/related_ad_entity.dart';
import '../datasources/company_details_remote_data_source.dart';

class CompanyDetailsRepositoryImpl implements CompanyDetailsRepository {
  final CompanyDetailsRemoteDataSource remoteDataSource;

  CompanyDetailsRepositoryImpl(this.remoteDataSource);

  @override
  Future<CompanyDetailsEntity> getCompanyDetails(int companyId) {
    return remoteDataSource.getCompanyDetails(companyId);
  }

  @override
  Future<List<RelatedAdEntity>> getCompanyAds(int companyId, int sectionId, {String? searchText}) {
    return remoteDataSource.getCompanyAds(companyId, sectionId, searchText: searchText);
  }
}
