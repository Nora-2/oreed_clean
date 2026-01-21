import 'dart:io';
import '../entities/brand_entity.dart';
import '../entities/car_details_entity.dart';
import '../entities/car_model_entity.dart';
import '../entities/car_response_entity.dart';

abstract class CarAdsRepository {
  Future<List<BrandEntity>> getBrands(int sectionId);
  Future<List<CarModelEntity>> getModels(int brandId);

  Future<CarResponseEntity> createCarAd({
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
  });
  Future<CarDetailsEntity> getCarDetails(int id);

  Future<CarResponseEntity> editCarAd({
    required int id,
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
    File? mainImage,
    List<File> certImages,
    List<File> galleryImages,
    int? companyId,
    int? companyTypeId,
  });
}