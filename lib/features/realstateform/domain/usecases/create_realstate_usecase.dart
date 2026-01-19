import 'package:oreed_clean/features/realstateform/domain/entities/real_state_response_entity.dart';
import 'package:oreed_clean/features/realstateform/domain/entities/realstate_entity.dart';
import 'package:oreed_clean/features/realstateform/domain/repositories/realstate_repo.dart';

class CreatePropertyUseCase {
  final PropertyRepository repository;
  CreatePropertyUseCase(this.repository);

  Future<PropertyResponseEntity> call(PropertyEntity property) {
    return repository.createProperty(property);
  }
}
