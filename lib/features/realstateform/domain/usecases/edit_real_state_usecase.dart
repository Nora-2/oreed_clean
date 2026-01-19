import 'package:oreed_clean/features/realstateform/domain/entities/real_state_response_entity.dart';
import 'package:oreed_clean/features/realstateform/domain/repositories/realstate_repo.dart';

class EditPropertyUseCase {
  final PropertyRepository repo;
  EditPropertyUseCase(this.repo);

  Future<PropertyResponseEntity> call(EditPropertyParams params) {
    return repo.edit(params);
  }
}
