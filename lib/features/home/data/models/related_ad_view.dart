import 'package:oreed_clean/features/home/data/models/releted_ad_model.dart';

class RelatedAdView {
  final String image;
  final String id;
  final String title;
  final String location;
  final String dateText;
  final String viewsText;
  final String priceText;
  final String adType;

  const RelatedAdView({
    required this.image,
    required this.id,
    required this.title,
    required this.location,
    required this.dateText,
    required this.viewsText,
    required this.priceText,
    required this.adType,
  });

  factory RelatedAdView.from(RelatedAd raw) {
    return RelatedAdView(
      image: raw.image,
      id: raw.id,
      title: raw.title,
      location: raw.location,
      dateText: raw.dateText,
      viewsText: raw.viewsText,
      priceText: raw.priceText,
      adType: raw.adType,
    );
  }
}
