import '../entities/dynamic_field_entity.dart';
import '../repositories/dynamic_fields_repository.dart';

class GetDynamicFieldsUseCase {
  final DynamicFieldsRepository repository;

  GetDynamicFieldsUseCase(this.repository);

  Future<List<DynamicFieldEntity>> call(int sectionId) {
    return repository.getDynamicFields(sectionId);
  }
}