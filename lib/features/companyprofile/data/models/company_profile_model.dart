import '../../domain/entities/company_profile_entity.dart';

class CompanyProfileModel extends CompanyProfileEntity {
  const CompanyProfileModel({
    required super.id,
    required super.name,
    required super.userId,
    required super.sectionId,
    required super.sectionName,
    required super.companyTypeId,
    required super.companyTypeName,
    required super.stateId,
    required super.stateName,
    required super.cityId,
    required super.cityName,
    required super.imageUrl,
    required super.visit,
    required super.adsExpiredAt,
  });

  factory CompanyProfileModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    return CompanyProfileModel(
      id: data['id'] ?? 0,
      name: data['name'] ?? '',
      userId: data['user_id'] ?? 0,
      sectionId: data['section_id'] ?? 0,
      sectionName: data['section_name'] ?? '',
      companyTypeId: data['company_type_id'] ?? 0,
      companyTypeName: data['company_type_name'] ?? '',
      stateId: data['state_id'] ?? 0,
      stateName: data['state_name'] ?? '',
      cityId: data['city_id'] ?? 0,
      cityName: data['city_name'] ?? '',
      imageUrl: data['image_url'] ?? '',
      visit: data['visit'] ?? 0,
      adsExpiredAt: data['user_subscription_expired_at'] ?? '',
    );
  }
}
