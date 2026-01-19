import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:oreed_clean/features/technicalforms/domain/entities/technican_detailes_entity.dart';
import 'package:oreed_clean/features/technicalforms/domain/usecases/create_technican_ad_usecase.dart';
import 'package:oreed_clean/features/technicalforms/domain/usecases/edit_technican_ad_usecase.dart';
import 'package:oreed_clean/features/technicalforms/domain/usecases/get_techniocan_detailes_usecase.dart';
import 'package:oreed_clean/features/technicalforms/presentation/cubit/technician_forms_state.dart';
import '../../domain/entities/city_entity.dart';
import '../../domain/entities/state_entity.dart';
import '../../domain/usecases/get_cities_usecase.dart';
import '../../domain/usecases/get_states_usecase.dart';

class TechnicianFormsCubit extends Cubit<TechnicianFormsState> {
  final GetStatesUseCase getStatesUseCase;
  final GetCitiesUseCase getCitiesUseCase;
  final CreateTechnicianAdUseCase createAdUseCase;
  final GetTechnicianDetailsUseCase getDetailsUseCase;
  final EditTechnicianAdUseCase editAdUseCase;

  // Cache for states and cities to avoid unnecessary API calls
  List<StateEntity> _cachedStates = [];
  List<CityEntity> _cachedCities = [];
  TechnicianDetailsEntity? _cachedDetails;

  TechnicianFormsCubit({
    required this.getStatesUseCase,
    required this.getCitiesUseCase,
    required this.createAdUseCase,
    required this.getDetailsUseCase,
    required this.editAdUseCase,
  }) : super(TechnicianFormsInitial());

  List<StateEntity> get states => _cachedStates;
  List<CityEntity> get cities => _cachedCities;
  TechnicianDetailsEntity? get loadedDetails => _cachedDetails;

  Future<void> fetchStates({bool forceRefresh = false}) async {
    if (_cachedStates.isNotEmpty && !forceRefresh) {
      emit(StatesLoaded(_cachedStates));
      return;
    }

    try {
      emit(StatesLoading());
      _cachedStates = await getStatesUseCase();
      emit(StatesLoaded(_cachedStates));
    } catch (e) {
      emit(StatesError(e.toString()));
    }
  }

  Future<void> fetchCities(int stateId, {bool forceRefresh = false}) async {
    try {
      emit(CitiesLoading());
      _cachedCities = await getCitiesUseCase(stateId);
      emit(CitiesLoaded(_cachedCities));
    } catch (e) {
      emit(CitiesError(e.toString()));
    }
  }

  Future<void> fetchTechnicianDetails(int id) async {
    try {
      emit(TechnicianDetailsLoading());
      _cachedDetails = await getDetailsUseCase(id);
      emit(TechnicianDetailsLoaded(_cachedDetails!));
    } catch (e) {
      emit(TechnicianDetailsError(e.toString()));
    }
  }

  Future<void> submitAd({
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
  }) async {
    try {
      emit(SubmittingAd());

      final response = await createAdUseCase(
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

      emit(AdSubmitted(response));
    } catch (e) {
      emit(AdSubmissionError(e.toString()));
    }
  }

  Future<void> updateAd({
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
  }) async {
    try {
      emit(UpdatingAd());

      final response = await editAdUseCase(
        EditTechnicianAdParams(
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
        ),
      );

      emit(AdUpdated(response));
    } catch (e) {
      emit(AdUpdateError(e.toString()));
    }
  }

  void clearCities() {
    _cachedCities = [];
    emit(TechnicianFormsInitial());
  }

  void reset() {
    emit(TechnicianFormsInitial());
  }
}
