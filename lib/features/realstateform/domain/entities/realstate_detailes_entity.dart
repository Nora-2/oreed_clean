class PropertyDetailsEntity {
  final int id;
  final String title;
  final String description;
  final String address;
  final String price;

  final int sectionId;
  final int? categoryId;
  final int? subCategoryId;

  final int stateId;
  final String? stateName;
  final int cityId;
  final String? cityName;

  final String rooms; // keep as string for UI consistency
  final String bathrooms; // keep as string for UI consistency
  final String area;
  final String floor;
  final String type; // 'residential' | 'commercial'

  final String? mainImage;
  final List<String> media; // urls

  const PropertyDetailsEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.address,
    required this.price,
    required this.sectionId,
    this.categoryId,
    this.subCategoryId,
    required this.stateId,
    this.stateName,
    required this.cityId,
    this.cityName,
    required this.rooms,
    required this.bathrooms,
    required this.area,
    required this.floor,
    required this.type,
    this.mainImage,
    required this.media,
  });
}
