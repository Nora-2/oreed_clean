
import 'package:oreed_clean/features/ads/data/datasources/ads_reomte_data_source.dart';
import 'package:oreed_clean/features/ads/domain/repositories/ads_repo.dart';
import 'package:oreed_clean/features/companyprofile/data/models/delete_ad_result.dart';

class AdsRepositoryImpl implements AdsRepository {
  final AdsRemoteDataSource remoteDataSource;

  AdsRepositoryImpl(this.remoteDataSource);

  @override
  Future<DeleteAdResult> deleteCar(int adId) =>
      remoteDataSource.deleteCar(adId);

  @override
  Future<DeleteAdResult> deleteProperty(int adId) =>
      remoteDataSource.deleteProperty(adId);

  @override
  Future<DeleteAdResult> deleteTechnician(int adId) =>
      remoteDataSource.deleteTechnician(adId);

  @override
  Future<DeleteAdResult> deleteAnything(int adId, int sectionId) =>
      remoteDataSource.deleteAnything(adId, sectionId);
}
