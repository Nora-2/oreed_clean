class UserEntity {
  final int id;
  final String phoneNumber;
  final String token;
  final String? profileImage;
  final String? accountType;
  final String? language;
  final String? name;
  final String? businessName;
  final String? whatsapp;
  final String? sectionId;
  final String? companyTypeId;
  final String? cityId;
  final String? stateId;
  final String? companyId;

  UserEntity({
    required this.id,
    required this.phoneNumber,
    required this.token,
    this.profileImage,
    this.accountType,
    this.language,
    this.name,
    this.businessName,
    this.whatsapp,
    this.sectionId,
    this.companyTypeId,
    this.cityId,
    this.stateId,
    this.companyId,
  });
}
