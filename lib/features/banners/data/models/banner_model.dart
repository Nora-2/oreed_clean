import '../../domain/entities/banner_entity.dart';

class BannerModel extends BannerEntity {
  const BannerModel({
    required super.id,
    required super.place,
    super.sectionId,
    required super.type,
    super.valueSectionId,
    required super.companyId,
    super.valueAdId,
    required super.image,
    super.expirationDate,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['id'],
      place: json['place'] ?? '',
      sectionId: json['section_id'] ?? 0,
      companyId: json['value_company_id'].toString(),
      type: json['type'] ?? '',
      valueSectionId: json['value_section_id']?.toString() ?? '',
      valueAdId: '${json['value_ad_id'] ?? ''}',
      image: json['image'] ?? '',
      expirationDate: json['expiration_date'] != null
          ? DateTime.tryParse(json['expiration_date'])
          : null,
    );
  }
}
