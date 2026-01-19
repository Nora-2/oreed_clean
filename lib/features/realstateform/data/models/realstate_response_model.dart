import 'package:oreed_clean/features/realstateform/domain/entities/real_state_response_entity.dart';

class PropertyResponseModel extends PropertyResponseEntity {
  const PropertyResponseModel({
    required super.status,
    required super.msg,
    super.id,
  });

  factory PropertyResponseModel.fromJson(Map<String, dynamic> json) {
    return PropertyResponseModel(
      status: json['status'] ?? false,
      msg: json['msg'] ?? '',
      id: json['data']?['id'],
    );
  }
}
