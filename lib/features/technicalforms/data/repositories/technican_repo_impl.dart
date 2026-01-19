import 'dart:io';

import 'package:oreed_clean/features/technicalforms/data/datasources/technican_remote_data_source.dart';
import 'package:oreed_clean/features/technicalforms/domain/entities/technican_detailes_entity.dart';
import 'package:oreed_clean/features/technicalforms/domain/entities/technican_response_entity.dart';
import 'package:oreed_clean/features/technicalforms/domain/repositories/technican_repo.dart';
import '../../domain/entities/city_entity.dart';
import '../../domain/entities/state_entity.dart';

class TechnicianRepositoryImpl implements TechnicianRepository {
  final TechnicianRemoteDataSource remoteDataSource;

  TechnicianRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<StateEntity>> getStates() => remoteDataSource.getStates();

  @override
  Future<List<CityEntity>> getCities(int stateId) =>
      remoteDataSource.getCities(stateId);

  @override
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
  }) {
    return remoteDataSource.createTechnicianAd(
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
      companyId: companyId,
      companyTypeId: companyTypeId,
    );
  }

  @override
  Future<TechnicianDetailsEntity> getTechnicianDetails(int id) =>
      remoteDataSource.getTechnicianDetails(id);

  @override
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
    List<File> galleryImages = const [],
    int? companyId,
    int? companyTypeId,
  }) => remoteDataSource.editTechnicianAd(
    id: id,
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
    companyId: companyId,
    companyTypeId: companyTypeId,
  );
}
