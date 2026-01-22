import 'dart:io';

import '../entities/create_anything_response_entity.dart';
import '../repositories/create_anything_repository.dart';

class CreateAnythingUseCase {
  final CreateAnythingRepository repository;

  CreateAnythingUseCase(this.repository);

  Future<CreateAnythingResponseEntity> call({
    required String nameAr,
    required String descriptionAr,
    required String price,
    required int userId,
    required int sectionId,
    required int categoryId,
    required int subCategoryId,
    required int stateId,
    required int cityId,
    required Map<String, dynamic> dynamicFields,
    required File mainImage,
    required List<File> galleryImages,
    int? companyId,
    int? companyTypeId,
  }) {
    return repository.createAnythingAd(
        nameAr: nameAr,
        descriptionAr: descriptionAr,
        price: price,
        userId: userId,
        sectionId: sectionId,
        categoryId: categoryId,
        subCategoryId: subCategoryId,
        stateId: stateId,
        cityId: cityId,
        dynamicFields: dynamicFields,
        mainImage: mainImage,
        galleryImages: galleryImages,
        companyTypeId: companyTypeId,
        companyId: companyId);
  }
}
