import 'package:oreed_clean/features/banners/domain/repositories/banner_repo.dart';

import '../../domain/entities/banner_entity.dart';
import '../datasources/banner_remote_data_source.dart';

class BannerRepositoryImpl implements BannerRepository {
  final BannerRemoteDataSource remote;

  BannerRepositoryImpl(this.remote);

  @override
  Future<List<BannerEntity>> getBanners(int? sectionId) {
    return remote.fetchBanners(sectionId: sectionId);
  }
}