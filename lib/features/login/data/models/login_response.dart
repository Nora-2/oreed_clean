import '../../domain/entities/user_entity.dart';

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
      data: json['data'],
    );
  }

  UserEntity toEntity() {
    final d = data ?? {};
    return UserEntity(
      id: d['id'] ?? 0,
      companyId: d['company_id'] != null ? d['company_id'].toString() : 'null',
      name: d['business_name'] ?? '',
      phone: d['phone'] ?? '',
      accountType: d['account_type'] ?? '',
      token: d['token'],
    );
  }
}
