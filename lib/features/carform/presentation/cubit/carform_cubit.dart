// lib/features/car_ads/presentation/cubit/carform_cubit.dart
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../../../core/app_shared_prefs.dart';
import '../../../technicalforms/domain/entities/city_entity.dart';
import '../../../technicalforms/domain/entities/state_entity.dart';
import '../../../technicalforms/domain/usecases/get_cities_usecase.dart';
import '../../../technicalforms/domain/usecases/get_states_usecase.dart';
import '../../domain/entities/brand_entity.dart';
import '../../domain/entities/car_details_entity.dart';
import '../../domain/entities/car_model_entity.dart';
import '../../domain/entities/car_response_entity.dart';
import '../../domain/usecases/create_car_ad_usecase.dart';
import '../../domain/usecases/edit_car_ad_usecase.dart';
import '../../domain/usecases/get_brands_usecase.dart';
import '../../domain/usecases/get_car_details_usecase.dart';
import '../../domain/usecases/get_models_usecase.dart';

part 'carform_state.dart';

class CarformCubit extends Cubit<CarformState> {
  final CreateCarAdUseCase createCarAdUseCase;
  final GetBrandsUseCase getBrandsUseCase;
  final GetModelsUseCase getModelsUseCase;
  final GetStatesUseCase getStatesUseCase;
  final GetCitiesUseCase getCitiesUseCase;
  final GetCarDetailsUseCase getCarDetailsUseCase;
  final EditCarAdUseCase editCarAdUseCase;

  CarformCubit({
    required this.createCarAdUseCase,
    required this.getBrandsUseCase,
    required this.getModelsUseCase,
    required this.getStatesUseCase,
    required this.getCitiesUseCase,
    required this.getCarDetailsUseCase,
    required this.editCarAdUseCase,
  }) : super(CarformInitial());

  // Cache for preventing stale data
  int? _modelsBrandId;

  // ========== Fetch Brands ==========
  Future<void> fetchBrands(int sectionId) async {
    emit(CarformBrandsLoading());
    try {
      final brands = await getBrandsUseCase(sectionId);
      emit(CarformBrandsLoaded(brands: brands));
    } catch (e) {
      emit(CarformError(message: e.toString()));
    }
  }

  // ========== Fetch Models ==========
  Future<void> fetchModels(int brandId) async {
    _modelsBrandId = brandId;
    emit(CarformModelsLoading());

    try {
      final models = await getModelsUseCase(brandId);

      // Prevent stale data if brand changed during loading
      if (_modelsBrandId != brandId) return;

      emit(CarformModelsLoaded(models: models));
    } catch (e) {
      if (_modelsBrandId == brandId) {
        emit(CarformError(message: e.toString()));
      }
    }
  }

  // ========== Clear Models ==========
  void clearModels() {
    emit(CarformModelsCleared());
  }

  // ========== Fetch States ==========
  Future<void> fetchStates() async {
    emit(CarformStatesLoading());
    try {
      final states = await getStatesUseCase();
      emit(CarformStatesLoaded(states: states));
    } catch (e) {
      emit(CarformError(message: e.toString()));
    }
  }

  // ========== Fetch Cities ==========
  Future<void> fetchCities(int stateId) async {
    emit(CarformCitiesLoading());
    try {
      final cities = await getCitiesUseCase(stateId);
      emit(CarformCitiesLoaded(cities: cities));
    } catch (e) {
      emit(CarformError(message: e.toString()));
    }
  }

  // ========== Fetch Car Details (for editing) ==========
  Future<void> fetchCarDetails(int id) async {
    emit(CarformDetailsLoading());
    try {
      final details = await getCarDetailsUseCase(id);
      emit(CarformDetailsLoaded(details: details));
    } catch (e) {
      emit(CarformError(message: e.toString()));
    }
  }

  // ========== Delete Ad Image ==========
  Future<bool> deleteAdImage({
    required int adId,
    required int imageId,
    bool isProperty = false,
  }) async {
    try {
      final token = AppSharedPreferences().getUserToken;
      if (token == null) return false;

      final endpoint = isProperty
          ? 'https://oreedo.net/api/v1/remove_property_image'
          : 'https://oreedo.net/api/v1/remove_car_image';

      final request = http.MultipartRequest('POST', Uri.parse(endpoint));
      request.headers.addAll({
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });
      request.fields.addAll({'ad_id': '$adId', 'image_id': '$imageId'});

      if (kDebugMode) {
        debugPrint('deleteAdImage request fields: ${request.fields}');
      }

      final streamed = await request.send();
      final body = await streamed.stream.bytesToString();

      if (kDebugMode) {
        debugPrint('deleteAdImage response code: ${streamed.statusCode}');
        debugPrint('deleteAdImage response body: $body');
      }

      if (streamed.statusCode == 200) {
        // Refresh details after successful deletion
        await fetchCarDetails(adId);
        return true;
      } else {
        emit(CarformError(message: 'Delete failed: ${streamed.statusCode}'));
        return false;
      }
    } catch (e) {
      emit(CarformError(message: e.toString()));
      return false;
    }
  }

  // ========== Submit New Car Ad ==========
  Future<void> submitCarAd({
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
  }) async {
    emit(CarformSubmitting());
    try {
      final response = await createCarAdUseCase(
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
        companyId: companyId,
      );

      if (kDebugMode) {
        debugPrint('submitCarAd response status: ${response.status}');
      }

      emit(CarformSubmitSuccess(response: response));
    } catch (e) {
      emit(CarformError(message: e.toString()));
    }
  }

  // ========== Update Existing Car Ad ==========
  Future<void> updateCarAd({
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
  }) async {
    emit(CarformSubmitting());
    try {
      final response = await editCarAdUseCase(
        EditCarAdParams(
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
        ),
      );

      emit(CarformUpdateSuccess(response: response));
    } catch (e) {
      emit(CarformError(message: e.toString()));
    }
  }
}