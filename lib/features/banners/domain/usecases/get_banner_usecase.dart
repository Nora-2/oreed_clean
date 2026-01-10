import 'package:oreed_clean/features/banners/domain/repositories/banner_repo.dart';

import '../entities/banner_entity.dart';

class GetBannersUseCase {
  final BannerRepository repository;
  GetBannersUseCase(this.repository);

  Future<List<BannerEntity>> call(int? sectionId) {
    return repository.getBanners(sectionId);
  }
}