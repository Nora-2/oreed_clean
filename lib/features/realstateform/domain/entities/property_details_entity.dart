import 'package:equatable/equatable.dart';
import 'package:oreed_clean/features/technicalforms/domain/entities/technican_detailes_entity.dart'; // Reusing MediaItem

class PropertyDetailsEntity extends Equatable {
  final int id;
  final String title;
  final String description;
  final String price;
  final String area;
  final String phone;
  final String whatsapp;
  final int stateId;
  final String? stateName;
  final int cityId;
  final String? cityName;
  final int countryId;
  final String? countryName;
  final String? mainImageUrl;
  final List<MediaItem> media;
  // Add other property specific fields as needed

  const PropertyDetailsEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.area,
    required this.phone,
    required this.whatsapp,
    required this.stateId,
    required this.cityId,
    required this.countryId,
    this.stateName,
    this.cityName,
    this.countryName,
    this.mainImageUrl,
    this.media = const [],
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        price,
        area,
        phone,
        whatsapp,
        stateId,
        cityId,
        countryId,
        stateName,
        cityName,
        countryName,
        mainImageUrl,
        media,
      ];
}
