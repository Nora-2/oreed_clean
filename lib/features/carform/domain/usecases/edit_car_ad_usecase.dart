
import 'dart:io';
import 'package:oreed_clean/features/carform/domain/repositories/car_form_repo.dart';
import '../entities/car_response_entity.dart';

class EditCarAdParams {
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
  final int cityId;
  final String color;
  final String year;
  final String kilometers;
  final String engineSize;
  final String condition;
  final String fuelType;
  final String transmission;
  final String paintCondition;
  final File? mainImage;             // optional on edit
  final List<File> certImages;       // optional on edit
  final List<File> galleryImages;    // optional on edit
  final int? companyId;
  final int? companyTypeId;

  EditCarAdParams({
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
    required this.cityId,
    required this.color,
    required this.year,
    required this.kilometers,
    required this.engineSize,
    required this.condition,
    required this.fuelType,
    required this.transmission,
    required this.paintCondition,
    this.mainImage,
    this.certImages = const [],
    this.galleryImages = const [],
    this.companyId,
    this.companyTypeId,
  });
}

class EditCarAdUseCase {
  final CarAdsRepository repo;
  EditCarAdUseCase(this.repo);

  Future<CarResponseEntity> call(EditCarAdParams p) =>
      repo.editCarAd(
        id: p.id,
        titleAr: p.titleAr,
        descriptionAr: p.descriptionAr,
        price: p.price,
        userId: p.userId,
        sectionId: p.sectionId,
        categoryId: p.categoryId,
        subCategoryId: p.subCategoryId,
        brandId: p.brandId,
        carModelId: p.carModelId,
        stateId: p.stateId,
        cityId: p.cityId,
        color: p.color,
        year: p.year,
        kilometers: p.kilometers,
        engineSize: p.engineSize,
        condition: p.condition,
        fuelType: p.fuelType,
        transmission: p.transmission,
        paintCondition: p.paintCondition,
        mainImage: p.mainImage,
        certImages: p.certImages,
        galleryImages: p.galleryImages,
        companyId: p.companyId,
        companyTypeId: p.companyTypeId,
      );
}
