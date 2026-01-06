import 'package:oreed_clean/features/home/domain/entities/category_entity.dart';

class CategoryModel {
  final String id;
  final String name;
  final String? icon;
  final String? image;

  CategoryModel({
    required this.id,
    required this.name,
    this.icon,
    this.image,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    String name = '';
    if (json['name'] != null) name = json['name'].toString();
    else if (json['name_ar'] != null) name = json['name_ar'].toString();
    else if (json['name_en'] != null) name = json['name_en'].toString();

    return CategoryModel(
      id: json['id']?.toString() ?? '',
      name: name,
      icon: json['icon']?.toString(),
      image: json['image']?.toString(),
    );
  }

  CategoryEntity toEntity() {
    return CategoryEntity(
      id: id,
      name: name,
      icon: icon ?? '',
    );
  }
}