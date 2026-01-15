import 'package:oreed_clean/features/ads/domain/repositories/ads_repo.dart';
import 'package:oreed_clean/features/ads/domain/usecases/delete_ad_car_usecase.dart';
import 'package:oreed_clean/features/ads/domain/usecases/delete_anything_usecase.dart';
import 'package:oreed_clean/features/ads/domain/usecases/delete_properity_ad_usecase.dart';
import 'package:oreed_clean/features/ads/domain/usecases/delete_technican_ad_usecase.dart';
import 'package:oreed_clean/features/companyprofile/data/models/delete_ad_result.dart';

class DeleteAdUseCase {
  final AdsRepository repository;

  DeleteAdUseCase(this.repository);


  Future<DeleteAdResult> call({
    required int adId,
    required int sectionId,
  }) async {
    // Use strategy pattern to delegate to the appropriate use case
    switch (sectionId) {
      case 1:
        final useCase = DeleteCarAdUseCase(repository);
        return useCase(adId);
      case 2:
        final useCase = DeletePropertyAdUseCase(repository);
        return useCase(adId);
      case 3:
        final useCase = DeleteTechnicianAdUseCase(repository);
        return useCase(adId);
      default:
        final useCase = DeleteAnythingAdUseCase(repository);
        return useCase(
          adId: adId,
          sectionId: sectionId,
        );
    }
  }
}

