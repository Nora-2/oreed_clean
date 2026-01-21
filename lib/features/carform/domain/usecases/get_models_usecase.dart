import '../entities/car_model_entity.dart';
import 'package:oreed_clean/features/carform/domain/repositories/car_form_repo.dart';
class GetModelsUseCase {
  final CarAdsRepository repository;

  GetModelsUseCase(this.repository);

  Future<List<CarModelEntity>> call(int brandId) =>
      repository.getModels(brandId);
}
