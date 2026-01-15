import 'package:oreed_clean/features/companyprofile/domain/entities/company_ad_entity.dart';

class CompanyAdModel extends CompanyAdEntity {
  const CompanyAdModel({
    required super.id,
    required super.title,
    super.description,
    required super.price,
    required super.visit,
    required super.status,
    required super.adType,
    required super.stateName,
    required super.adOwnerType,
    required super.cityName,
    required super.adsExpirationDate,
    required super.createdAt,
    required super.mainImage,
    required super.sectionId,
    required super.sectionName,
    required super.sectionType,
  });

  factory CompanyAdModel.fromJson(Map<String, dynamic> json) {
    // ✅ Safe field extraction (title OR name)
    final title = (json['title'] ?? json['name'] ?? '').toString().trim();

    return CompanyAdModel(
      id: json['id'] ?? 0,
      title: title.isNotEmpty ? title : 'بدون عنوان',
      description: json['description']?.toString(),
      price: (json['price'] ?? '').toString(),
      visit: json['visit'] ?? 0,
      status: (json['status'] ?? '').toString(),
      adType: (json['ad_type'] ?? '').toString(),
      adOwnerType: (json['ad_owner_type'] ?? '').toString(),
      stateName: (json['state_name'] ?? '').toString(),
      cityName: (json['city_name'] ?? '').toString(),
      adsExpirationDate: (json['ads_expiration_date'] ?? '').toString(),
      createdAt: (json['created_at'] ?? '').toString(),
      mainImage: (json['main_image'] ?? '').toString(),
      sectionId: json['section_id'] ?? 0,
      sectionName: (json['section_name'] ?? '').toString(),
      sectionType: (json['section_type'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "price": price,
    "visit": visit,
    "status": status,
    "ad_type": adType,
    "state_name": stateName,
    "city_name": cityName,
    "ads_expiration_date": adsExpirationDate,
    "created_at": createdAt,
    "main_image": mainImage,
    "section_id": sectionId,
    "section_name": sectionName,
    "section_type": sectionType,
  };
}
