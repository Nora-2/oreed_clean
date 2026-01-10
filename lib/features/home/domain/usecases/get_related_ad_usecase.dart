import 'package:oreed_clean/features/home/domain/repositories/home_repo.dart';
import '../entities/related_ad_entity.dart';
class GetRelatedAdsUseCase {
  final MainHomeRepository repository;

  GetRelatedAdsUseCase(this.repository);

  Future<List<RelatedAdEntity>> call({
    required int sectionId,
    int page = 1,
    int perPage = 10,
  }) {
    return repository.getRelatedAds(
      sectionId: sectionId,
      page: page,
      perPage: perPage,
    );
  }
}
