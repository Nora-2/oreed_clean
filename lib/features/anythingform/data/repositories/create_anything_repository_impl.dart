import 'dart:io';

import '../../domain/entities/anything_details_entity.dart';
import '../../domain/entities/create_anything_response_entity.dart';
import '../../domain/repositories/create_anything_repository.dart';
import '../../domain/usecases/edit_anything_usecase.dart';
import '../datasources/create_anything_remote_data_source.dart';

class CreateAnythingRepositoryImpl implements CreateAnythingRepository {
  final CreateAnythingRemoteDataSource remote;

  CreateAnythingRepositoryImpl(this.remote);

  @override
  Future<CreateAnythingResponseEntity> createAnythingAd({
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
    return remote.createAnythingAd(
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
        companyId: companyId,
        companyTypeId: companyTypeId);
  }

  @override
  Future<CreateAnythingResponseEntity> editAnythingAd({
    required int adId,
    required int sectionId,
    String? nameAr,
    String? descriptionAr,
    String? price,
    int? categoryId,
    int? subCategoryId,
    int? stateId,
    int? cityId,
    Map<String, dynamic>? dynamicFields,
    File? mainImage,
    List<File>? galleryImages,
  }) =>
      remote.edit(
        EditAnythingParams(
          adId: adId,
          sectionId: sectionId,
          nameAr: nameAr,
          descriptionAr: descriptionAr,
          price: price,
          categoryId: categoryId,
          subCategoryId: subCategoryId,
          stateId: stateId,
          cityId: cityId,
          dynamicFields: dynamicFields,
          mainImage: mainImage,
          galleryImages: galleryImages,
        ),
      );

  @override
  Future<AnythingDetailsEntity> getAnythingDetails(
          {required int adId, required int sectionId}) =>
      remote.getDetails(adId: adId, sectionId: sectionId);
}
