import '../entities/dynamic_field_entity.dart';

abstract class DynamicFieldsRepository {
  Future<List<DynamicFieldEntity>> getDynamicFields(int sectionId);
}