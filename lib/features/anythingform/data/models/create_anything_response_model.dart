import '../../domain/entities/create_anything_response_entity.dart';

class CreateAnythingResponseModel extends CreateAnythingResponseEntity {
  const CreateAnythingResponseModel({
    required super.id,
    required super.status,
    required super.message,
  });

  factory CreateAnythingResponseModel.fromJson(Map<String, dynamic> json) {
    return CreateAnythingResponseModel(
      id: json['data']?['id'] ?? 0,
      status: json['status'] ?? false,
      message: json['msg'] ?? '',
    );
  }
}