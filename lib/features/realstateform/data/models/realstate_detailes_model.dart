import 'package:oreed_clean/features/realstateform/domain/entities/realstate_detailes_entity.dart';

class PropertyDetailsModel extends PropertyDetailsEntity {
  final List<Map<String, dynamic>>
  mediaMaps; // model-only: preserve id + original_url

  const PropertyDetailsModel({
    required super.id,
    required super.title,
    required super.description,
    required super.address,
    required super.price,
    required super.sectionId,
    super.categoryId,
    super.subCategoryId,
    required super.stateId,
    super.stateName,
    required super.cityId,
    super.cityName,
    required super.rooms,
    required super.bathrooms,
    required super.area,
    required super.floor,
    required super.type,
    super.mainImage,
    required super.media,
    required this.mediaMaps,
  });

  factory PropertyDetailsModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json; // accept raw or wrapped

    final rawMedia = (data['media'] as List? ?? []);

    final mediaMaps = rawMedia
        .map(
          (e) => {
            'id': e['id'],
            'original_url': e['original_url']?.toString() ?? '',
          },
        )
        .where((e) => (e['original_url'] as String).isNotEmpty)
        .toList();

    final media = mediaMaps.map((m) => m['original_url'] as String).toList();

    return PropertyDetailsModel(
      id: data['id'] ?? 0,
      title: data['title']?.toString() ?? '',
      description: data['description']?.toString() ?? '',
      address: data['address']?.toString() ?? '',
      price: data['price']?.toString() ?? '',
      sectionId: data['section_id'] ?? 2,
      categoryId: data['category_id'],
      subCategoryId: data['sub_category_id'],
      stateId: data['state_id'] ?? 0,
      stateName: data['state_name'],
      cityId: data['city_id'] ?? 0,
      cityName: data['city_name'],
      rooms: (data['rooms']?.toString() ?? ''),
      bathrooms: (data['bathrooms']?.toString() ?? ''),
      area: data['area']?.toString() ?? '',
      floor: data['floor']?.toString() ?? '',
      type: data['type']?.toString() ?? '',
      mainImage: data['main_image']?.toString(),
      media: media,
      mediaMaps: mediaMaps,
    );
  }
}
