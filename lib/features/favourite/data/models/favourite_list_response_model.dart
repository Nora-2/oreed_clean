// features/favorites/data/models/favorites_list_response_model.dart
import 'package:oreed_clean/features/favourite/data/models/favourite_item_mode.dart';

class FavoritesListResponseModel {
  final int code;
  final bool status;
  final String msg;
  final List<FavoriteItemModel> items;

  FavoritesListResponseModel({
    required this.code,
    required this.status,
    required this.msg,
    required this.items,
  });

  factory FavoritesListResponseModel.fromJson(Map<String, dynamic> json) {
    final data = (json['data'] as List? ?? [])
        .map((e) => FavoriteItemModel.fromJson(e as Map<String, dynamic>))
        .toList();

    return FavoritesListResponseModel(
      code: json['code'] as int? ?? 0,
      status: json['status'] as bool? ?? false,
      msg: (json['msg'] ?? '').toString(),
      items: data,
    );
  }
}
