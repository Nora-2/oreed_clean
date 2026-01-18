import 'package:oreed_clean/features/forms/domain/entities/technican_response_entity.dart';

class TechnicianResponseModel extends TechnicianResponseEntity {
  const TechnicianResponseModel({
    required super.status,
    required super.msg,
    super.id,
  });

  factory TechnicianResponseModel.fromJson(Map<String, dynamic> json) {
    return TechnicianResponseModel(
      status: json['status'] ?? false,
      msg: json['msg'] ?? '',
      id: json['data']?['id'],
    );
  }
}