
import 'package:oreed_clean/features/ads/domain/repositories/ads_repo.dart';
import 'package:oreed_clean/features/companyprofile/data/models/delete_ad_result.dart';
class DeleteCarAdUseCase {
  final AdsRepository repository;
  DeleteCarAdUseCase(this.repository);

  Future<DeleteAdResult> call(int adId) {
    return repository.deleteCar(adId);
  }
}
