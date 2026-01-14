import '../../domain/entities/company_entity.dart';

class CompanyDetailsModel extends CompanyDetailsEntity {
  const CompanyDetailsModel({
    required super.id,
    required super.name,
    required super.state,
    required super.companyTypeName,
    required super.city,
    required super.phone,
    required super.whatsapp,
    super.imageUrl,
    super.facebook,
    super.instagram,
    super.snapchat,
    super.tiktok,
    super.visit,
  });

  factory CompanyDetailsModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return CompanyDetailsModel(
      id: data['id'] ?? 0,
      name: data['name'] ?? '',
      state: data['state_name'] ?? '',
      companyTypeName: data['company_type_name'] ?? '',
      city: data['city_name'] ?? '',
      imageUrl: data['image_url'],
      visit: data['visit'] ?? 0,
      phone: data['phones'] ?? '',
      whatsapp: data['whatsapp'] ?? '',
      facebook: data['facebook'],
      instagram: data['instagram'],
      snapchat: data['snapchat'],
      tiktok: data['tiktok'],
    );
  }
}
