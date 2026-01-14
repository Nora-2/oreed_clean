import 'package:oreed_clean/features/addetails/data/datasources/ad_detailes_remote_datasource.dart';
import 'package:oreed_clean/features/addetails/domain/entities/ad_detiles_entity.dart';
import 'package:oreed_clean/features/addetails/domain/repositories/ad_detailes_repo.dart';

class AdDetailesRepositoryImpl implements AdDetailesRepository {
  final AdDetailesRemoteDataSource remote;
  AdDetailesRepositoryImpl(this.remote);

  @override
  Future<AdDetailesEntity> getAdDetails(int adId, int sectionId) =>
      remote.fetchAdDetails(adId, sectionId);
}
