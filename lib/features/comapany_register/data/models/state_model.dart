import '../../domain/entities/state_entity.dart';

class StateModel extends StateEntity {
  const StateModel({required super.id, required super.name});

  factory StateModel.fromJson(Map<String, dynamic> json) => StateModel(
        id: json['id'] ?? 0,
        name: json['name'] ?? '',
      );
}