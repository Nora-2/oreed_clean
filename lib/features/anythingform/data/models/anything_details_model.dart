import '../../domain/entities/anything_details_entity.dart';

class AnythingDetailsModel extends AnythingDetailsEntity {
  AnythingDetailsModel({
    required super.id,
    required super.name,
    required super.stateName,
    required super.cityName,
    required super.description,
    required super.price,
    required super.sectionId,
    required super.categoryId,
    required super.subCategoryId,
    required super.stateId,
    required super.cityId,
    super.mainImage,
    super.media = const [],
    super.dynamicFields = const {},
  });

  factory AnythingDetailsModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json; // support either wrapped or flat

    // Parse media items with IDs
    final mediaList = (data['media'] as List?)
            ?.map((e) {
              if (e is Map<String, dynamic>) {
                return MediaItem(
                  id: e['id'] is int
                      ? e['id']
                      : int.tryParse('${e['id']}') ?? 0,
                  url: e['original_url'] ?? '',
                );
              }
              return null;
            })
            .where((e) => e != null)
            .cast<MediaItem>()
            .toList() ??
        const <MediaItem>[];

    final dynamicFields = json['data'];
// Collect dynamic fields by excluding known static keys
    // data.forEach((k, v) {
    //   if (!staticKeys.contains(k)) dynamicFields[k] = v;
    // });

    return AnythingDetailsModel(
      id: data['id'] ?? 0,
      name: data['title'] ?? data['name'] ?? '',
      description: data['description'] ?? '',
      stateName: data['state_name'] ?? '',
      cityName: data['city_name'] ?? '',
      price: (data['price'] ?? '').toString(),
      sectionId: data['section_id'] ?? 0,
      categoryId: data['category_id'] ?? 0,
      subCategoryId: data['sub_category_id'] ?? 0,
      stateId: data['state_id'] ?? 0,
      cityId: data['city_id'] ?? 0,
      mainImage: data['main_image'],
      media: mediaList,
      dynamicFields: dynamicFields,
    );
  }
}
