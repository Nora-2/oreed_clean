import '../../domain/entities/car_model_entity.dart';

class CarModelModel extends CarModelEntity {
  const CarModelModel({
    required super.id,
    required super.name,
  });

  factory CarModelModel.fromJson(Map<String, dynamic> json) {
    return CarModelModel(
      id: json['id'],
      name: json['name'] ?? '',
    );
  }
}