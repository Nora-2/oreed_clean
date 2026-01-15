import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:oreed_clean/features/comapany_register/domain/entities/country_entity.dart';
import 'package:oreed_clean/features/comapany_register/domain/entities/state_entity.dart';
import 'package:oreed_clean/features/comapany_register/domain/usecases/get_country_usecase.dart';
import 'package:oreed_clean/features/comapany_register/domain/usecases/get_state_usecase.dart';
part 'location_selector_state.dart';

class LocationSelectorCubit extends Cubit<LocationSelectorState> {
  final GetCountriesUseCase getCountriesUseCase;
  final GetStatesUseCase getStatesUseCase;

  LocationSelectorCubit({
    required this.getCountriesUseCase,
    required this.getStatesUseCase,
  }) : super(const LocationSelectorState());

  Future<void> fetchStates() async {
    emit(state.copyWith(status: LocationStatus.loading));
    try {
      final result = await getCountriesUseCase();
      emit(state.copyWith(states: result, status: LocationStatus.success));
    } catch (e) {
      emit(
        state.copyWith(
          status: LocationStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> fetchCities(int stateId) async {
    // We don't want to lose the current 'states' list, just update cities
    emit(state.copyWith(status: LocationStatus.loading));
    try {
      final result = await getStatesUseCase(stateId);
      emit(state.copyWith(cities: result, status: LocationStatus.success));
    } catch (e) {
      emit(
        state.copyWith(
          status: LocationStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
