class FavoriteResponseModel {
  final int code;
  final bool status;
  final String messageKey; // السيرفر بيرجّع msg = مفتاح ترجمة
  final dynamic data;

  FavoriteResponseModel({
    required this.code,
    required this.status,
    required this.messageKey,
    this.data,
  });

  factory FavoriteResponseModel.fromJson(Map<String, dynamic> json) {
    return FavoriteResponseModel(
      code: (json['code'] as num?)?.toInt() ?? 0,
      status: json['status'] == true,
      messageKey: (json['msg'] as String?) ?? '',
      data: json['data'],
    );
  }
}
