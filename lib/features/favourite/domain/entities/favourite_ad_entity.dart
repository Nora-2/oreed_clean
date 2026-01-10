// features/favorites/domain/entities/favorite_ad_entity.dart
class FavoriteAdEntity {
  final int id;
  final int sectionId;
  final String title;
  final String imageUrl;
  final String price;
  final String? city;
  final String? state;
  final String section;
  final String baseSection;

  const FavoriteAdEntity({
    required this.id,
    required this.sectionId,
    required this.title,
    required this.imageUrl,
    required this.price,
    required this.city,
    required this.state,
    required this.section,
    required this.baseSection,
  });
}
