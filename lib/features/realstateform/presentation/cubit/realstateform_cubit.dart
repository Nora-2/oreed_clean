import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:oreed_clean/features/comapany_register/domain/entities/country_entity.dart';
import 'package:oreed_clean/features/comapany_register/domain/usecases/get_country_usecase.dart';
import 'package:oreed_clean/features/realstateform/domain/entities/real_state_response_entity.dart';
import 'package:oreed_clean/features/realstateform/domain/entities/realstate_detailes_entity.dart';
import 'package:oreed_clean/features/realstateform/domain/entities/realstate_entity.dart';
import 'package:oreed_clean/features/realstateform/domain/repositories/realstate_repo.dart';
import 'package:oreed_clean/features/realstateform/domain/usecases/create_realstate_usecase.dart';
import 'package:oreed_clean/features/realstateform/domain/usecases/edit_real_state_usecase.dart';
import 'package:oreed_clean/features/realstateform/domain/usecases/get_realstate_usecase.dart';
import 'package:oreed_clean/features/technicalforms/domain/entities/state_entity.dart';
import 'package:oreed_clean/features/technicalforms/domain/usecases/get_states_usecase.dart';

part 'realstateform_state.dart';

class RealstateformCubit extends Cubit<RealstateformState> {
  final CreatePropertyUseCase createPropertyUseCase;
  final GetCountriesUseCase getCountriesUseCase;
  final GetStatesUseCase getStatesUseCase;
  final GetPropertyDetailsUseCase getPropertyDetailsUseCase;
  final EditPropertyUseCase editPropertyUseCase;

  RealstateformCubit({
    required this.createPropertyUseCase,
    required this.getCountriesUseCase,
    required this.getStatesUseCase,
    required this.getPropertyDetailsUseCase,
    required this.editPropertyUseCase,
  }) : super(RealstateformInitial());

  // Create Property
  Future<void> submitProperty(PropertyEntity property) async {
    emit(RealstateformLoading());
    try {
      final response = await createPropertyUseCase(property);
      emit(RealstateformSuccess(response: response));
    } catch (e) {
      emit(RealstateformError(message: e.toString()));
    }
  }

  // Fetch Property Details
  Future<void> fetchPropertyDetails(int id, {String language = 'ar'}) async {
    emit(RealstateformLoading());
    try {
      final details = await getPropertyDetailsUseCase(id, language: language);
      emit(RealstateformDetailsLoaded(details: details));
    } catch (e) {
      emit(RealstateformError(message: e.toString()));
    }
  }

  // Update Property
  Future<void> updateProperty(EditPropertyParams params) async {
    emit(RealstateformLoading());
    try {
      final response = await editPropertyUseCase(params);
      emit(RealstateformSuccess(response: response));
    } catch (e) {
      emit(RealstateformError(message: e.toString()));
    }
  }

  // Fetch Countries
  Future<void> fetchCountries() async {
    emit(RealstateformLoadingCountries());
    try {
      final countries = await getCountriesUseCase();
      emit(RealstateformCountriesLoaded(countries: countries));
    } catch (e) {
      emit(RealstateformError(message: 'Failed to load countries: $e'));
    }
  }

  // Fetch States
  Future<void> fetchStates(int countryId) async {
    emit(RealstateformLoadingStates());
    try {
      final states = await getStatesUseCase();
      emit(RealstateformStatesLoaded(states: states));
    } catch (e) {
      emit(RealstateformError(message: 'Failed to load states: $e'));
    }
  }

  // Clear States
  void clearStates() {
    emit(RealstateformStatesCleared());
  }

  // Reset to initial state
  void reset() {
    emit(RealstateformInitial());
  }
}
