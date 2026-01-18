// lib/features/technician_ads/domain/usecases/edit_technician_ad_usecase.dart
import 'dart:io';
import 'package:oreed_clean/features/forms/domain/entities/technican_response_entity.dart';
import 'package:oreed_clean/features/forms/domain/repositories/technican_repo.dart';
class EditTechnicianAdParams {
  final int id; // ad id
  final String name;
  final String description;
  final String phone;
  final String whatsapp;
  final int userId;
  final int sectionId;
  final int categoryId;
  final int stateId;
  final int cityId;
  final File? mainImage;           // optional on edit
  final List<File> galleryImages;  // optional on edit
  final int? companyId;
  final int? companyTypeId;

  EditTechnicianAdParams({
    required this.id,
    required this.name,
    required this.description,
    required this.phone,
    required this.whatsapp,
    required this.userId,
    required this.sectionId,
    required this.categoryId,
    required this.stateId,
    required this.cityId,
    this.mainImage,
    this.galleryImages = const [],
    this.companyId,
    this.companyTypeId,
  });
}

class EditTechnicianAdUseCase {
  final TechnicianRepository repo;
  EditTechnicianAdUseCase(this.repo);

  Future<TechnicianResponseEntity> call(EditTechnicianAdParams p) =>
      repo.editTechnicianAd(
        id: p.id,
        name: p.name,
        description: p.description,
        phone: p.phone,
        whatsapp: p.whatsapp,
        userId: p.userId,
        sectionId: p.sectionId,
        categoryId: p.categoryId,
        stateId: p.stateId,
        cityId: p.cityId,
        mainImage: p.mainImage,
        galleryImages: p.galleryImages,
        companyId: p.companyId,
        companyTypeId: p.companyTypeId,
      );
}
