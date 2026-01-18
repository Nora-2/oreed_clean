// lib/features/technician_ads/domain/entities/technician_details_entity.dart
import 'package:equatable/equatable.dart';

class MediaItem extends Equatable {
  final int id;
  final String url;

  const MediaItem({
    required this.id,
    required this.url,
  });

  @override
  List<Object?> get props => [id, url];
}

class TechnicianDetailsEntity extends Equatable {
  final int id;
  final String name;
  final String description;
  final String phone;
  final String whatsapp;
  final int stateId;
  final String? stateName;
  final int cityId;
  final String? cityName;
  final String? mainImageUrl;
  final List<MediaItem> media;

  const TechnicianDetailsEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.phone,
    required this.whatsapp,
    required this.stateId,
    required this.cityId,
    this.stateName,
    this.cityName,
    this.mainImageUrl,
    this.media = const [],
  });

  // Keep backward compatibility
  List<String> get galleryImageUrls => media.map((m) => m.url).toList();

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        phone,
        whatsapp,
        stateId,
        stateName,
        cityId,
        cityName,
        mainImageUrl,
        media,
      ];
}
