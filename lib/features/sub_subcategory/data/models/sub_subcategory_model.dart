import '../../domain/entities/sub_subcategory_entity.dart';

class SubSubcategoryModel extends SubSubcategoryEntity {
  const SubSubcategoryModel({
    required super.id,
    required super.name,
    required super.image,
  });

  factory SubSubcategoryModel.fromJson(Map<String, dynamic> json) {
    return SubSubcategoryModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      image: json['image'] ?? '',
    );
  }
}
