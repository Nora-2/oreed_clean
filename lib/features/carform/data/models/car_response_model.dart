import '../../domain/entities/car_response_entity.dart';

class CarResponseModel extends CarResponseEntity {
  const CarResponseModel({
    required super.status,
    required super.msg,
    super.id,
  });

  factory CarResponseModel.fromJson(Map<String, dynamic> json) {
    return CarResponseModel(
      status: json['status'] ?? false,
      msg: json['msg'] ?? '',
      id: json['data']?['id'],
    );
  }
}