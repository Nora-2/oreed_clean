import '../../domain/entities/banner_entity.dart';
import '../../domain/repositories/banner_repository.dart';
import '../datasources/banner_remote_data_source.dart';

class BannerRepositoryImpl implements BannerRepository {
  final BannerRemoteDataSource remote;

  BannerRepositoryImpl(this.remote);

  @override
  Future<List<BannerEntity>> getBanners(int? sectionId) {
    return remote.fetchBanners(sectionId: sectionId);
  }
}