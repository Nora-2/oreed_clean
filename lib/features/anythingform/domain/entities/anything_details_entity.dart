class MediaItem {
  final int id;
  final String url;

  const MediaItem({
    required this.id,
    required this.url,
  });
}

class AnythingDetailsEntity {
  final int id;
  final String name;
  final String description;
  final String price;
  final String stateName;
  final String cityName;
  final int sectionId;
  final int categoryId;
  final int subCategoryId;
  final int stateId;
  final int cityId;
  final String? mainImage;
  final List<MediaItem> media;
  final Map<String, dynamic>
      dynamicFields; // e.g. size, color, price_before_discount

  const AnythingDetailsEntity({
    required this.id,
    required this.name,
    required this.stateName,
    required this.cityName,
    required this.description,
    required this.price,
    required this.sectionId,
    required this.categoryId,
    required this.subCategoryId,
    required this.stateId,
    required this.cityId,
    this.mainImage,
    this.media = const [],
    this.dynamicFields = const {},
  });

  // Backward compatibility
  List<String> get gallery => media.map((m) => m.url).toList();
}
