class UserAdEntity {
  final int id;
  final String? title;
  final String price;
  final int visit;
  final String status;
  final String adType;
  final String? stateName;
  final String? cityName;
  final String adsExpirationDate;
  final String createdAt;
  final String mainImage;
  final String? sectionName;
  final String sectionType;
  final int sectionId;

  const UserAdEntity({
    required this.id,
    required this.sectionId,
    this.title,
    required this.price,
    required this.visit,
    required this.status,
    required this.adType,
    this.stateName,
    this.cityName,
    required this.adsExpirationDate,
    required this.createdAt,
    required this.mainImage,
    this.sectionName,
    required this.sectionType,
  });
}
