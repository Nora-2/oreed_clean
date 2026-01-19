import 'dart:io';
import 'package:oreed_clean/features/technicalforms/domain/entities/technican_response_entity.dart';
import 'package:oreed_clean/features/technicalforms/domain/repositories/technican_repo.dart';

class CreateTechnicianAdUseCase {
  final TechnicianRepository repository;

  CreateTechnicianAdUseCase(this.repository);

  Future<TechnicianResponseEntity> call({
    required String name,
    required String description,
    required String phone,
    required String whatsapp,
    required int userId,
    required int sectionId,
    required int categoryId,
    required int stateId,
    required int cityId,
    required File mainImage,
    required List<File> galleryImages,
    int? companyId,
    int? companyTypeId,
  }) {
    return repository.createTechnicianAd(
      name: name,
      description: description,
      phone: phone,
      whatsapp: whatsapp,
      userId: userId,
      sectionId: sectionId,
      categoryId: categoryId,
      stateId: stateId,
      cityId: cityId,
      mainImage: mainImage,
      galleryImages: galleryImages,
      companyTypeId: companyTypeId,
      companyId: companyId,
    );
  }
}
