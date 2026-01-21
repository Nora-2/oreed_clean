import 'dart:io';
import 'package:oreed_clean/features/carform/domain/repositories/car_form_repo.dart';
import '../entities/car_response_entity.dart';
class CreateCarAdUseCase {
  final CarAdsRepository repository;

  CreateCarAdUseCase(this.repository);

  Future<CarResponseEntity> call({
    required String titleAr,
    required String descriptionAr,
    required String price,
    required int userId,
    required int sectionId,
    required int categoryId,
    required int subCategoryId,
    required int brandId,
    required int carModelId,
    required int stateId,
    required int cityId,
    required String color,
    required String year,
    required String kilometers,
    required String engineSize,
    required String condition,
    required String fuelType,
    required String transmission,
    required String paintCondition,
    required File mainImage,
    required List<File> certImages,
    required List<File> galleryImages,
    int? companyId,
    int? companyTypeId,
  }) {
    return repository.createCarAd(
        titleAr: titleAr,
        descriptionAr: descriptionAr,
        price: price,
        userId: userId,
        sectionId: sectionId,
        categoryId: categoryId,
        subCategoryId: subCategoryId,
        brandId: brandId,
        carModelId: carModelId,
        stateId: stateId,
        cityId: cityId,
        color: color,
        year: year,
        kilometers: kilometers,
        engineSize: engineSize,
        condition: condition,
        fuelType: fuelType,
        transmission: transmission,
        paintCondition: paintCondition,
        mainImage: mainImage,
        certImages: certImages,
        galleryImages: galleryImages,
        companyId: companyId,
        companyTypeId: companyTypeId);
  }
}
