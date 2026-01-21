import '../entities/car_details_entity.dart';
import 'package:oreed_clean/features/carform/domain/repositories/car_form_repo.dart';
class GetCarDetailsUseCase {
  final CarAdsRepository repo;
  GetCarDetailsUseCase(this.repo);
  Future<CarDetailsEntity> call(int id) => repo.getCarDetails(id);
}
