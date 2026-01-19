import 'dart:io';
import 'package:oreed_clean/features/technicalforms/domain/entities/technican_detailes_entity.dart';
import 'package:oreed_clean/features/technicalforms/domain/entities/technican_response_entity.dart';
import '../entities/state_entity.dart';
import '../entities/city_entity.dart';

abstract class TechnicianRepository {
  Future<List<StateEntity>> getStates();
  Future<List<CityEntity>> getCities(int stateId);

  Future<TechnicianResponseEntity> createTechnicianAd({
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
  });
  Future<TechnicianDetailsEntity> getTechnicianDetails(int id);
  Future<TechnicianResponseEntity> editTechnicianAd({
    required int id,
    required String name,
    required String description,
    required String phone,
    required String whatsapp,
    required int userId,
    required int sectionId,
    required int categoryId,
    required int stateId,
    required int cityId,
    File? mainImage,
    List<File> galleryImages,
    int? companyId,
    int? companyTypeId,
  });
}
