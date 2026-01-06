import 'package:oreed_clean/features/home/domain/entities/product_entity.dart';

class ProductModel {
  final String id;
  final String name;
  final String image;
  final double price;
  final String category;
  final String government;
  final String city;
  final DateTime createdAt;
  ProductModel({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.category,
    required this.government,
    required this.city,
    required this.createdAt,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      price: (json['price'] as num).toDouble(),
      category: json['category'], government: json['government'] , city: json['city'] , createdAt: json['createdAt'] ,
    );
  }

  ProductEntity toEntity() {
    return ProductEntity(
      id: id,
      name: name,
      image: image,
      price: price,
      category: category,
      government: government,
      city: city,
      createdAt: createdAt,
    );
  }
}
