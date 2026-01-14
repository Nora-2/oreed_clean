class FavoriteAd {
  final String id;
  final String title;
  final String imageUrl;
  final String? priceText;
  final String? city;
  final DateTime? createdAt;

  const FavoriteAd({
    required this.id,
    required this.title,
    required this.imageUrl,
    this.priceText,
    this.city,
    this.createdAt,
  });
}
