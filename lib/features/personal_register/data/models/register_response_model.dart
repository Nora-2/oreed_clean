import '../../domain/entities/register_response_entity.dart';

class RegisterResponseModel extends RegisterResponseEntity {
  const RegisterResponseModel({
    required super.status,
    required super.msg,
    required super.code,
  });

  factory RegisterResponseModel.fromJson(Map<String, dynamic> json) {
    return RegisterResponseModel(
      status: json['status'] ?? false,
      msg: json['msg'] ?? '',
      code: json['code'] ?? 0,
    );
  }
}