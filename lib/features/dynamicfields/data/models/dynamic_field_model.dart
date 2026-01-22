import '../../domain/entities/dynamic_field_entity.dart';

class DynamicFieldModel extends DynamicFieldEntity {
  const DynamicFieldModel({
    required super.key,
    required super.label,
  });

  factory DynamicFieldModel.fromJson(MapEntry<String, dynamic> entry) {
    return DynamicFieldModel(
      key: entry.key,
      label: entry.value.toString(),
    );
  }
}
