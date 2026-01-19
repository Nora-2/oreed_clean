import 'package:oreed_clean/features/realstateform/domain/entities/realstate_detailes_entity.dart';
import 'package:oreed_clean/features/realstateform/domain/repositories/realstate_repo.dart';

class GetPropertyDetailsUseCase {
  final PropertyRepository repo;
  GetPropertyDetailsUseCase(this.repo);

  Future<PropertyDetailsEntity> call(int id, {String language = 'ar'}) {
    return repo.getDetails(id, language: language);
  }
}
