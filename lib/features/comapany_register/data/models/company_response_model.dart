import 'package:oreed_clean/features/comapany_register/domain/entities/comapny_response_entity.dart';
class CompanyResponseModel extends CompanyResponseEntity {
  const CompanyResponseModel({
    required super.status,
    required super.msg,
    super.id,
  });

  factory CompanyResponseModel.fromJson(Map<String, dynamic> json) {
    return CompanyResponseModel(
      status: json['status'] ?? false,
      msg: json['msg'] ?? '',
      id: json['data']?['id'],
    );
  }
}