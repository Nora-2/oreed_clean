import '../../domain/entities/register_response_entity.dart';

class RegisterResponseModelcomapny extends RegisterResponseEntity {
  const RegisterResponseModelcomapny({required super.status, required super.msg});

  factory RegisterResponseModelcomapny.fromJson(Map<String, dynamic> json) =>
      RegisterResponseModelcomapny(
        status: json['status'] ?? false,
        msg: json['msg'] ?? '',
      );
}