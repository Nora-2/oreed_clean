import 'package:oreed_clean/features/home/data/models/ad_model.dart';
class RelatedAdEntity {
  final int id;
  final String title;
  final String city;
  final String state;
  final String? price;
  final String? description;
  final int visit;
  final String? status;
  final String? adType;
  final String? adsExpirationDate;
  final String? createdAt;
  final String? mainImage;

  const RelatedAdEntity({
    required this.id,
    required this.title,
    required this.city,
    required this.state,
    this.price,
    this.visit = 0,
    this.description = '',
    this.status,
    this.adType,
    this.adsExpirationDate,
    this.createdAt,
    this.mainImage,
  });
}

extension RelatedAdEntityX on RelatedAdEntity {
  AdModel toAdModel() {
    return AdModel(
      id: id,
      title: title,
      image: mainImage ?? '',
      // add more fields if your AdModel supports them
      // e.g. price, createdAt, etc.
    );
  }
}

extension RelatedAdListX on List<RelatedAdEntity> {
  List<AdModel> toAdModels() => map((e) => e.toAdModel()).toList();
}
