import 'package:oreed_clean/features/forms/domain/repositories/technican_repo.dart';
import '../entities/city_entity.dart';

class GetCitiesUseCase {
  final TechnicianRepository repository;

  GetCitiesUseCase(this.repository);

  Future<List<CityEntity>> call(int stateId) => repository.getCities(stateId);
}
