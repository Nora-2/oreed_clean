// lib/features/car_ads/data/models/car_details_model.dart
import '../../domain/entities/car_details_entity.dart';

class CarDetailsModel extends CarDetailsEntity {
  const CarDetailsModel({
    required super.id,
    required super.titleAr,
    required super.descriptionAr,
    required super.price,
    required super.userId,
    required super.sectionId,
    required super.categoryId,
    required super.subCategoryId,
    required super.brandId,
    required super.carModelId,
    required super.stateId,
    super.stateName,
    required super.cityId,
    super.cityName,
    required super.color,
    required super.year,
    required super.kilometers,
    required super.engineSize,
    required super.condition,
    required super.fuelType,
    required super.transmission,
    required super.paintCondition,
    super.mainImageUrl,
    super.carDocuments,
    List<String> galleryImageUrlsParam = const [],
    List<int> galleryImageIdsParam = const [],
    List<String> certImageUrlsParam = const [],
    List<int> certImageIdsParam = const [],
  }) : super(
          galleryImageUrls: galleryImageUrlsParam,
          galleryImageIds: galleryImageIdsParam,
          certImageUrls: certImageUrlsParam,
          certImageIds: certImageIdsParam,
        );

  factory CarDetailsModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    List<String> toStrList(dynamic v, String itemKey) {
      if (v is List) {
        return v
            .map((e) =>
                e is String ? e : (e[itemKey] ?? e['original_url'] ?? ''))
            .where((s) => (s ?? '').toString().isNotEmpty)
            .map((s) => s.toString())
            .toList();
      }
      return const [];
    }

    List<int> toIdList(dynamic v, String idKey) {
      if (v is List) {
        return v
            .map((e) => e is Map
                ? (e[idKey] is int
                    ? e[idKey]
                    : int.tryParse('${e[idKey]}') ?? 0)
                : 0)
            .where((i) => i != 0)
            .map((i) => i as int)
            .toList();
      }
      return const [];
    }

    return CarDetailsModel(
      id: data['id'] is int ? data['id'] : int.tryParse('${data['id']}') ?? 0,
      titleAr: data['title'] ?? data['title_ar'] ?? '',
      descriptionAr: data['description'] ?? data['description_ar'] ?? '',
      price: '${data['price'] ?? ''}',
      userId: data['user_id'] is int
          ? data['user_id']
          : int.tryParse('${data['user_id']}') ?? 0,
      sectionId: data['section_id'] is int
          ? data['section_id']
          : int.tryParse('${data['section_id']}') ?? 0,
      categoryId: data['category_id'] is int
          ? data['category_id']
          : int.tryParse('${data['category_id']}') ?? 0,
      subCategoryId: data['sub_category_id'] is int
          ? data['sub_category_id']
          : int.tryParse('${data['sub_category_id']}') ?? 0,
      brandId: data['brand_id'] is int
          ? data['brand_id']
          : int.tryParse('${data['brand_id']}') ?? 0,
      carModelId: data['car_model_id'] is int
          ? data['car_model_id']
          : int.tryParse('${data['car_model_id']}') ?? 0,
      stateId: data['state_id'] is int
          ? data['state_id']
          : int.tryParse('${data['state_id']}') ?? 0,
      stateName: data['state_name'],
      cityId: data['city_id'] is int
          ? data['city_id']
          : int.tryParse('${data['city_id']}') ?? 0,
      cityName: data['city_name'],
      color: '${data['color'] ?? ''}',
      year: '${data['year'] ?? ''}',
      kilometers: '${data['kilometers'] ?? ''}',
      engineSize: '${data['engine_size'] ?? ''}',
      condition: '${data['condition'] ?? ''}',
      fuelType: '${data['fuel_type'] ?? ''}',
      transmission: '${data['transmission'] ?? ''}',
      paintCondition: '${data['paint_condition'] ?? ''}',
      mainImageUrl: data['main_image'],
      carDocuments: data['car_documents'],
      galleryImageUrlsParam: toStrList(data['media'], 'image'),
      galleryImageIdsParam: toIdList(data['media'], 'id'),
      certImageUrlsParam: [
        ...toStrList(data['car_documents'], 'image_cert'),
        if ((data['car_documents'] ?? '').toString().isNotEmpty)
          data['car_documents'].toString(),
      ],
      certImageIdsParam: toIdList(data['car_documents'], 'id'),
    );
  }
}
