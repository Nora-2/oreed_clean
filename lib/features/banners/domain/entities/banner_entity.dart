class BannerEntity {
  final int id;
  final String place;
  final int? sectionId;
  final String type; // ads_id | link | phone
  final String? valueSectionId;
  final String? valueAdId;
  final String image;
  final String companyId;
  final DateTime? expirationDate;

  const BannerEntity({
    required this.id,
    required this.place,
    this.sectionId,
    required this.type,
    this.valueSectionId,
    this.valueAdId,
    required this.image,
    required this.companyId,
    this.expirationDate,
  });
}