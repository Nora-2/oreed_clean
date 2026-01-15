class CompanyAdEntity {
  final int id;
  final String title; // unified (from "title" or "name")
  final String? description;
  final String price;
  final int visit;
  final String status;
  final String adType;
  final String stateName;
  final String cityName;
  final String adOwnerType;
  final String adsExpirationDate;
  final String createdAt;
  final String mainImage;
  final int sectionId;
  final String sectionName;
  final String sectionType;

  const CompanyAdEntity({
    required this.id,
    required this.title,
    this.description,
    required this.price,
    required this.adOwnerType,
    required this.visit,
    required this.status,
    required this.adType,
    required this.stateName,
    required this.cityName,
    required this.adsExpirationDate,
    required this.createdAt,
    required this.mainImage,
    required this.sectionId,
    required this.sectionName,
    required this.sectionType,
  });
}
