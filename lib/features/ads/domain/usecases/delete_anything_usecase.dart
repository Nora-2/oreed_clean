
import 'package:oreed_clean/features/ads/domain/repositories/ads_repo.dart';
import 'package:oreed_clean/features/companyprofile/data/models/delete_ad_result.dart';
class DeleteAnythingAdUseCase {
  final AdsRepository repository;
  DeleteAnythingAdUseCase(this.repository);

  Future<DeleteAdResult> call({
    required int adId,
    required int sectionId,
  }) {
    return repository.deleteAnything(adId, sectionId);
  }
}
