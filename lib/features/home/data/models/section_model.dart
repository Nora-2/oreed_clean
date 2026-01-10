import '../../domain/entities/section_entity.dart';

class SectionModel extends SectionEntity {
  const SectionModel({required super.id, required super.name, required super.image});

  factory SectionModel.fromJson(Map<String, dynamic> json) => SectionModel(
        id: json['id'] ?? 0,
        name: json['name'] ?? '',
        image: json['image'] ?? '',
      );
}