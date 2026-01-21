import 'dart:io';

import 'package:oreed_clean/features/carform/data/datasources/car_form_remote_data_source.dart';
import 'package:oreed_clean/features/carform/domain/entities/brand_entity.dart';
import 'package:oreed_clean/features/carform/domain/entities/car_details_entity.dart';
import 'package:oreed_clean/features/carform/domain/entities/car_model_entity.dart';
import 'package:oreed_clean/features/carform/domain/entities/car_response_entity.dart';
import 'package:oreed_clean/features/carform/domain/repositories/car_form_repo.dart';

class CarAdsRepositoryImpl implements CarAdsRepository {
  final CarAdsRemoteDataSource remoteDataSource;

  CarAdsRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<BrandEntity>> getBrands(int sectionId) =>
      remoteDataSource.getBrands(sectionId);

  @override
  Future<List<CarModelEntity>> getModels(int brandId) =>
      remoteDataSource.getModels(brandId);

  @override
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
  }) {
    return remoteDataSource.createCarAd(
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
        companyTypeId: companyTypeId,
        companyId: companyId);
  }

  @override
  Future<CarDetailsEntity> getCarDetails(int id) =>
      remoteDataSource.getCarDetails(id);

  @override
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
    List<File> certImages = const [],
    List<File> galleryImages = const [],
    int? companyId,
    int? companyTypeId,
  }) =>
      remoteDataSource.editCarAd(
        id: id,
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
        companyTypeId: companyTypeId,
      );
}
