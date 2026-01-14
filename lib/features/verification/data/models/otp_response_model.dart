import '../../domain/entities/otp_response_entity.dart';

class OtpResponseModel extends OtpResponseEntity {
  const OtpResponseModel({
    required super.status,
    required super.msg,
    required super.data,
    required super.id,
  });

  factory OtpResponseModel.fromJson(Map<String, dynamic> json) {
    return OtpResponseModel(
      status: json['status'] ?? false,
      msg: json['msg'] ?? '',
      id: json['data'] != null
          ? json['data']['user_id'] ?? json['data']['id']
          : 0,
      data: json['data'] ?? {},
    );
  }
}
