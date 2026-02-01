import 'package:oreed_clean/core/network/api_error_handler.dart';

class ApiErrorModel {
  final int code;
  final String message;

  ApiErrorModel({
    required this.code,
    required this.message,
  });

  factory ApiErrorModel.fromJson(Map<String, dynamic> json) {
    return ApiErrorModel(
      code: json['code'] ?? ResponseCode.DEFAULT,
      message: json['msg'] ?? ResponseMessage.DEFAULT,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'msg': message,
    };
  }
}