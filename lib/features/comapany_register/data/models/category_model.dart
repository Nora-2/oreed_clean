import 'package:oreed_clean/features/comapany_register/domain/entities/category_entity.dart';

// 1. Add "extends CategoryEntity"
class CategoryModel extends CategoryEntity {
  
  // 2. Use "super" in the constructor
  CategoryModel({
    required super.id,
    required super.name,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      name: json['name'],
    );
  }
  
  // You can keep toEntity() or remove it, as the Model is now also an Entity
}