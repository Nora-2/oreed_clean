import '../entities/anything_details_entity.dart';
import '../repositories/create_anything_repository.dart';

class GetAnythingDetailsUseCase {
  final CreateAnythingRepository repository;

  GetAnythingDetailsUseCase(this.repository);

  Future<AnythingDetailsEntity> call(
          {required int adId, required int sectionId}) =>
      repository.getAnythingDetails(adId: adId, sectionId: sectionId);
}
