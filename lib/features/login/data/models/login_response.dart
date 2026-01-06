import '../../domain/entities/user_entity.dart';
import '../models/user_model.dart';

class LoginResponse {
  final int code;
  final bool status;
  final String msg;
  final Map<String, dynamic>? data;

  LoginResponse({
    required this.code,
    required this.status,
    required this.msg,
    this.data,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      code: json['code'] ?? 500,
      status: json['status'] ?? false,
      msg: json['msg'] ?? '',
      data: json['data'] != null ? Map<String, dynamic>.from(json['data']) : null,
    );
  }

  UserModel toModel() {
    final d = data ?? {};
    return UserModel.fromJson(d);
  }
}
