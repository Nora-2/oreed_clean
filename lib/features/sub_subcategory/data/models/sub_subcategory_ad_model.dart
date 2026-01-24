import '../../domain/entities/sub_subcategory_ad_entity.dart';

class SubSubcategoryAdModel extends SubSubcategoryAdEntity {
  const SubSubcategoryAdModel({
    required super.id,
    required super.title,
    super.image,
    super.price,
    required super.visit,
    required super.status,
    required super.adType,
    required super.createdAt,
  });

  factory SubSubcategoryAdModel.fromJson(Map<String, dynamic> json) {
    return SubSubcategoryAdModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      image: json['main_image'],
      price: json['price'],
      visit: json['visit'] ?? 0,
      status: json['status'] ?? '',
      adType: json['ad_type'] ?? '',
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    );
  }
}