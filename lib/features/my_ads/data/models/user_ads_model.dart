import '../../domain/entities/user_ad_entity.dart';

class UserAdModel extends UserAdEntity {
  const UserAdModel({
    required super.id,
    super.title,
    required super.price,
    required super.visit,
    required super.status,
    required super.adType,
    super.stateName,
    super.cityName,
    required super.adsExpirationDate,
    required super.createdAt,
    required super.mainImage,
    super.sectionName,
    required super.sectionType,
    required super.sectionId,
  });

  factory UserAdModel.fromJson(Map<String, dynamic> json) {
    return UserAdModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? json['name'] ?? '',
      price: json['price'] ?? '',
      visit: json['visit'] ?? 0,
      status: json['status'] ?? '',
      adType: json['ad_type'] ?? '',
      stateName: json['state_name'],
      cityName: json['city_name'],
      adsExpirationDate: json['ads_expiration_date'] ?? '',
      createdAt: json['created_at'] ?? '',
      mainImage: json['main_image'] ?? '',
      sectionName: json['section_name'] ?? '',
      sectionId: json['section_id'] ?? 0,
      sectionType: json['section_type'] ?? '',
    );
  }
}
