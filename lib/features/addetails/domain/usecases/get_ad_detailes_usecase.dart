import 'package:oreed_clean/features/addetails/domain/entities/ad_detiles_entity.dart';
import 'package:oreed_clean/features/addetails/domain/repositories/ad_detailes_repo.dart';

class GetAdDetailsUseCase {
  final AdDetailesRepository repository;
  GetAdDetailsUseCase(this.repository);

  Future<AdDetailesEntity> call(int adId, int sectionId) =>
      repository.getAdDetails(adId, sectionId);
}
