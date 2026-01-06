import 'package:oreed_clean/features/login/domain/entities/user_entity.dart';

class UserModel {
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

  UserModel({
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

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> data =
        json['data'] is Map ? json['data'] as Map<String, dynamic> : json;

    int idValue = 0;
    if (data['id'] != null) idValue = data['id'];

    final phone = (data['phone'] ?? data['phone_number'] ?? data['phoneNumber'] ?? '').toString();
    final token = (data['token'] ?? data['access_token'] ?? '').toString();

    return UserModel(
      id: idValue,
      phoneNumber: phone,
      token: token,
      profileImage: data['profile_image']?.toString(),
      accountType: data['account_type']?.toString(),
      language: data['language']?.toString(),
      name: data['name']?.toString(),
      businessName: data['business_name']?.toString(),
      whatsapp: data['whatsapp']?.toString(),
      sectionId: data['section_id'] != null ? data['section_id'].toString() : null,
      companyTypeId: data['company_type_id'] != null ? data['company_type_id'].toString() : null,
      cityId: data['city_id'] != null ? data['city_id'].toString() : null,
      stateId: data['state_id'] != null ? data['state_id'].toString() : null,
      companyId: data['company_id'] != null ? data['company_id'].toString() : null,
    );
  }

  UserEntity toEntity() {
    return UserEntity(
      id: id,
      phoneNumber: phoneNumber,
      token: token,
      profileImage: profileImage,
      accountType: accountType,
      language: language,
      name: name,
      businessName: businessName,
      whatsapp: whatsapp,
      sectionId: sectionId,
      companyTypeId: companyTypeId,
      cityId: cityId,
      stateId: stateId,
      companyId: companyId,
    );
  }
}
