import 'package:oreed_clean/features/home/domain/entities/banner_entity.dart';

class BannerModel {
  final String id;
  final String image;
  final String? link;

  BannerModel({
    required this.id,
    required this.image,
    this.link,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    // banner image might be under different keys
    String? image = json['image']?.toString();
    image ??= json['original_url']?.toString();
    image ??= json['image_url']?.toString();

    return BannerModel(
      id: json['id']?.toString() ?? '',
      image: image ?? '',
      link: json['link']?.toString(),
    );
  }

  BannerEntity toEntity() {
    return BannerEntity(
      id: id,
      image: image,
      // link is optional; omit here for compatibility with callers that expect id+image only
    );
  }
}