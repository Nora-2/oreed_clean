import 'dart:io';
import 'package:oreed_clean/features/realstateform/domain/entities/real_state_response_entity.dart';
import 'package:oreed_clean/features/realstateform/domain/entities/realstate_detailes_entity.dart';
import 'package:oreed_clean/features/realstateform/domain/entities/realstate_entity.dart';

abstract class PropertyRepository {
  Future<PropertyResponseEntity> createProperty(PropertyEntity property);

  Future<PropertyDetailsEntity> getDetails(int id, {String language = 'ar'});

  Future<PropertyResponseEntity> edit(EditPropertyParams params);

  // New: remove image by ad id and image id (returns true if removed)
  Future<bool> removeImage(int adId, int imageId);
}

class EditPropertyParams {
  final int id; // ad_id
  final String? titleAr;
  final String? descriptionAr;
  final String? addressAr;
  final String? price;
  final String? rooms;
  final String? bathrooms;
  final String? area;
  final String? floor;
  final String? type; // 'residential' | 'commercial'
  final int? stateId;
  final int? cityId;

  final File? mainImage;
  final List<File> galleryImages;

  const EditPropertyParams({
    required this.id,
    this.titleAr,
    this.descriptionAr,
    this.addressAr,
    this.price,
    this.rooms,
    this.bathrooms,
    this.area,
    this.floor,
    this.type,
    this.stateId,
    this.cityId,
    this.mainImage,
    this.galleryImages = const [],
  });
}
