
import 'package:oreed_clean/features/forms/domain/entities/technican_detailes_entity.dart';

class TechnicianDetailsModel extends TechnicianDetailsEntity {
  const TechnicianDetailsModel({
    required super.id,
    required super.name,
    required super.description,
    required super.phone,
    required super.whatsapp,
    required super.stateId,
    required super.cityId,
    super.stateName,
    super.cityName,
    super.mainImageUrl,
    super.media = const [],
  });

  factory TechnicianDetailsModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;

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

    return TechnicianDetailsModel(
      id: data['id'] is int ? data['id'] : int.tryParse('${data['id']}') ?? 0,
      name: data['name'] ?? data['name_ar'] ?? '',
      description: data['description'] ?? data['description_ar'] ?? '',
      phone: '${data['phone'] ?? ''}',
      whatsapp: '${data['whatsapp'] ?? ''}',
      stateId: data['state_id'] is int
          ? data['state_id']
          : int.tryParse('${data['state_id']}') ?? 0,
      cityId: data['city_id'] is int
          ? data['city_id']
          : int.tryParse('${data['city_id']}') ?? 0,
      stateName: data['state_name'],
      cityName: data['city_name'],
      mainImageUrl: data['main_image'],
      media: mediaList,
    );
  }
}
