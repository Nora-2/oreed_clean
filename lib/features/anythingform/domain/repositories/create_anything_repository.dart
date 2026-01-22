import 'dart:io';
import '../entities/anything_details_entity.dart';
import '../entities/create_anything_response_entity.dart';

abstract class CreateAnythingRepository {
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
  });
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
  });

  Future<AnythingDetailsEntity> getAnythingDetails({
    required int adId,
    required int sectionId,
  });
}