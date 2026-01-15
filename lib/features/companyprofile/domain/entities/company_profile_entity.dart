class CompanyProfileEntity {
  final int id;
  final String name;
  final int userId;
  final int sectionId;
  final String sectionName;
  final int companyTypeId;
  final String companyTypeName;
  final int stateId;
  final String stateName;
  final int cityId;
  final String cityName;
  final String imageUrl;
  final int visit;
  final String adsExpiredAt;

  const CompanyProfileEntity({
    required this.id,
    required this.name,
    required this.userId,
    required this.sectionId,
    required this.sectionName,
    required this.companyTypeId,
    required this.companyTypeName,
    required this.stateId,
    required this.stateName,
    required this.cityId,
    required this.cityName,
    required this.imageUrl,
    required this.visit,
    required this.adsExpiredAt,
  });
}
