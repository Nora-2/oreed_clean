import 'dart:io';

import '../entities/create_anything_response_entity.dart';
import '../repositories/create_anything_repository.dart';

class EditAnythingParams {
  final int adId;
  final int sectionId;
  final String? nameAr;
  final String? descriptionAr;
  final String? price;
  final int? categoryId;
  final int? subCategoryId;
  final int? stateId;
  final int? cityId;
  final Map<String, dynamic>? dynamicFields;
  final File? mainImage;
  final List<File>? galleryImages;

  EditAnythingParams({
    required this.adId,
    required this.sectionId,
    this.nameAr,
    this.descriptionAr,
    this.price,
    this.categoryId,
    this.subCategoryId,
    this.stateId,
    this.cityId,
    this.dynamicFields,
    this.mainImage,
    this.galleryImages,
  });
}

class EditAnythingUseCase {
  final CreateAnythingRepository repository;
  EditAnythingUseCase(this.repository);
  Future<CreateAnythingResponseEntity> call(EditAnythingParams p) =>
      repository.editAnythingAd(
        adId: p.adId,
        sectionId: p.sectionId,
        nameAr: p.nameAr,
        descriptionAr: p.descriptionAr,
        price: p.price,
        categoryId: p.categoryId,
        subCategoryId: p.subCategoryId,
        stateId: p.stateId,
        cityId: p.cityId,
        dynamicFields: p.dynamicFields,
        mainImage: p.mainImage,
        galleryImages: p.galleryImages,
      );
}