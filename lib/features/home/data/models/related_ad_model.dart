import '../../domain/entities/related_ad_entity.dart';

class RelatedAdModel extends RelatedAdEntity {
  const RelatedAdModel({
    required super.id,
    required super.title,
    required super.city,
    required super.state,
    super.price,
    super.visit,
    super.description,
    super.status,
    super.adType,
    super.adsExpirationDate,
    super.createdAt,
    super.mainImage,
  });

  factory RelatedAdModel.fromJson(Map<String, dynamic> json) {
    return RelatedAdModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? json['name'] ?? '',
      description: json['description'] ?? '',
      city: json['city_name'] ?? '',
      state: json['state_name'] ?? '',
      price: json['price']?.toString(),
      visit: json['visit'] is int
          ? json['visit']
          : int.tryParse('${json['visit']}') ?? 0,
      status: json['status']?.toString(),
      adType: json['ad_type']?.toString(),
      adsExpirationDate: json['ads_expiration_date'] ?? '',
      createdAt: json['created_at']?.toString(),
      mainImage: json['main_image']?.toString(),
    );
  }
}
