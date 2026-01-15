
import 'package:oreed_clean/features/ads/domain/repositories/ads_repo.dart';
import 'package:oreed_clean/features/companyprofile/data/models/delete_ad_result.dart';

class DeleteTechnicianAdUseCase {
  final AdsRepository repository;
  DeleteTechnicianAdUseCase(this.repository);

  Future<DeleteAdResult> call(int adId) {
    return repository.deleteTechnician(adId);
  }
}
