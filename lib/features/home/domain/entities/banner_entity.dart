class BannerEntity {
  final String id;
  final String image;
  final String? link;

  BannerEntity({
    required this.id,
    required this.image,
    this.link,
  });
}