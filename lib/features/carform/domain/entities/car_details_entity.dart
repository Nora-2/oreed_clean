// lib/features/car_ads/domain/entities/car_details_entity.dart
import 'package:equatable/equatable.dart';

class CarDetailsEntity extends Equatable {
  final int id;
  final String titleAr;
  final String descriptionAr;
  final String price;
  final int userId;
  final int sectionId;
  final int categoryId;
  final int subCategoryId;
  final int brandId;
  final int carModelId;
  final int stateId;
  final String? stateName;
  final int cityId;
  final String? cityName;
  final String color; // label/key as your API returns
  final String year; // string as per API
  final String kilometers;
  final String engineSize; // key range or value per API
  final String condition; // key (e.g., new/used)
  final String fuelType; // key (e.g., petrol/electric)
  final String transmission; // "Manual"/"Automatic"
  final String paintCondition; // key
  final String? mainImageUrl;
  final String? carDocuments;
  final List<String> galleryImageUrls;
  final List<int> galleryImageIds;
  final List<String> certImageUrls;
  final List<int> certImageIds;

  const CarDetailsEntity({
    required this.id,
    required this.titleAr,
    required this.descriptionAr,
    required this.price,
    required this.userId,
    required this.sectionId,
    required this.categoryId,
    required this.subCategoryId,
    required this.brandId,
    required this.carModelId,
    required this.stateId,
    this.stateName,
    required this.cityId,
    this.cityName,
    required this.color,
    required this.year,
    required this.kilometers,
    required this.engineSize,
    required this.condition,
    required this.fuelType,
    required this.transmission,
    required this.paintCondition,
    this.mainImageUrl,
    this.carDocuments,
    this.galleryImageUrls = const [],
    this.galleryImageIds = const [],
    this.certImageUrls = const [],
    this.certImageIds = const [],
  });

  @override
  List<Object?> get props => [
        id,
        titleAr,
        descriptionAr,
        price,
        userId,
        sectionId,
        categoryId,
        subCategoryId,
        brandId,
        carModelId,
        stateId,
        cityId,
        color,
        year,
        kilometers,
        engineSize,
        condition,
        fuelType,
        transmission,
        paintCondition,
        mainImageUrl,
        galleryImageUrls,
        galleryImageIds,
        certImageUrls,
        certImageIds,
        stateName,
        cityName
      ];
}
