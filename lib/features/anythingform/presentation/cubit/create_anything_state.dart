import 'package:equatable/equatable.dart';
import 'package:oreed_clean/features/comapany_register/domain/entities/country_entity.dart';
import 'package:oreed_clean/features/comapany_register/domain/entities/state_entity.dart';
import '../../domain/entities/anything_details_entity.dart';
import '../../domain/entities/create_anything_response_entity.dart';

enum CreateAnythingStatus { initial, loading, success, error }

class CreateAnythingState extends Equatable {
  final CreateAnythingStatus status;
  final String? error;
  final CreateAnythingResponseEntity? response;
  final AnythingDetailsEntity? loadedDetails;

  final List<CountryEntity> countries;
  final List<StateEntity> states;
  final bool loadingCountries;
  final bool loadingStates;

  const CreateAnythingState({
    this.status = CreateAnythingStatus.initial,
    this.error,
    this.response,
    this.loadedDetails,
    this.countries = const [],
    this.states = const [],
    this.loadingCountries = false,
    this.loadingStates = false,
  });

  CreateAnythingState copyWith({
    CreateAnythingStatus? status,
    String? error,
    CreateAnythingResponseEntity? response,
    AnythingDetailsEntity? loadedDetails,
    List<CountryEntity>? countries,
    List<StateEntity>? states,
    bool? loadingCountries,
    bool? loadingStates,
  }) {
    return CreateAnythingState(
      status: status ?? this.status,
      error: error, // Error is distinct, if not passed (null), we usually want to clear it? No, standard copyWith keeps it.
      // But typically we want to clear error on new actions.
      // For now I'll follow standard copyWith.
      // To clear error, caller must pass null? No, Dart doesn't support undefined vs null easily.
      // I'll stick to: if you don't pass it, it keeps current value.
      response: response ?? this.response,
      loadedDetails: loadedDetails ?? this.loadedDetails,
      countries: countries ?? this.countries,
      states: states ?? this.states,
      loadingCountries: loadingCountries ?? this.loadingCountries,
      loadingStates: loadingStates ?? this.loadingStates,
    );
  }

  @override
  List<Object?> get props => [
        status,
        error,
        response,
        loadedDetails,
        countries,
        states,
        loadingCountries,
        loadingStates,
      ];
}
