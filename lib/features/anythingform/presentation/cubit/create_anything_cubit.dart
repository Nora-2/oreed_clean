
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oreed_clean/features/comapany_register/domain/usecases/get_country_usecase.dart';
import 'package:oreed_clean/features/comapany_register/domain/usecases/get_state_usecase.dart';
import '../../domain/usecases/create_anything_usecase.dart';
import '../../domain/usecases/edit_anything_usecase.dart';
import '../../domain/usecases/get_anything_details_usecase.dart';
import 'create_anything_state.dart';

class CreateAnythingCubit extends Cubit<CreateAnythingState> {
  final CreateAnythingUseCase createAnythingUseCase;
  final GetCountriesUseCase getCountriesUseCase;
  final GetStatesUseCase getStatesUseCase;
  final EditAnythingUseCase editUC;
  final GetAnythingDetailsUseCase detailsUC;

  CreateAnythingCubit({
    required this.createAnythingUseCase,
    required this.getCountriesUseCase,
    required this.getStatesUseCase,
    required this.editUC,
    required this.detailsUC,
  }) : super(const CreateAnythingState());

  Future<void> createAd({
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
  }) async {
    emit(state.copyWith(status: CreateAnythingStatus.loading));
    try {
      final response = await createAnythingUseCase(
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
        companyTypeId: companyTypeId,
      );
      emit(state.copyWith(
        status: CreateAnythingStatus.success,
        response: response,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: CreateAnythingStatus.error,
        error: e.toString(),
      ));
    }
  }

  Future<void> fetchCountries() async {
    emit(state.copyWith(loadingCountries: true));
    try {
      final countries = await getCountriesUseCase();
      emit(state.copyWith(
        loadingCountries: false,
        countries: countries,
      ));
    } catch (e) {
      debugPrint('❌ Failed to fetch countries: $e');
      emit(state.copyWith(loadingCountries: false));
    }
  }

  Future<void> fetchStates(int countryId) async {
    emit(state.copyWith(loadingStates: true));
    try {
      final states = await getStatesUseCase(countryId);
      emit(state.copyWith(
        loadingStates: false,
        states: states,
      ));
    } catch (e) {
      debugPrint('❌ Failed to fetch states: $e');
      emit(state.copyWith(loadingStates: false));
    }
  }

  Future<void> loadDetails(int adId, int sectionId) async {
    emit(state.copyWith(status: CreateAnythingStatus.loading));
    try {
      final loaded = await detailsUC(adId: adId, sectionId: sectionId);
      emit(state.copyWith(
        status: CreateAnythingStatus.success,
        loadedDetails: loaded,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: CreateAnythingStatus.error,
        error: e.toString(),
      ));
    }
  }

  Future<void> edit(EditAnythingParams p) async {
    emit(state.copyWith(status: CreateAnythingStatus.loading));
    try {
      final response = await editUC(p);
      emit(state.copyWith(
        status: CreateAnythingStatus.success,
        response: response,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: CreateAnythingStatus.error,
        error: e.toString(),
      ));
    }
  }

  // Helper to reset status after showing snackbars/navigation
  void resetStatus() {
    emit(state.copyWith(status: CreateAnythingStatus.initial, error: null));
  }
}
