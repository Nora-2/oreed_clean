import '../entities/brand_entity.dart';
import 'package:oreed_clean/features/carform/domain/repositories/car_form_repo.dart';
class GetBrandsUseCase {
  final CarAdsRepository repository;

  GetBrandsUseCase(this.repository);

  Future<List<BrandEntity>> call(int sectionId) => repository.getBrands(sectionId);
}