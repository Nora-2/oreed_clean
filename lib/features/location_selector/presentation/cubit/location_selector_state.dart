part of 'location_selector_cubit.dart';

enum LocationStatus { initial, loading, success, error }

class LocationSelectorState extends Equatable {
  final List<CountryEntity> states; // These represent Governorates/States
  final List<StateEntity> cities; // These represent Cities
  final LocationStatus status;
  final String? errorMessage;

  const LocationSelectorState({
    this.states = const [],
    this.cities = const [],
    this.status = LocationStatus.initial,
    this.errorMessage,
  });

  LocationSelectorState copyWith({
    List<CountryEntity>? states,
    List<StateEntity>? cities,
    LocationStatus? status,
    String? errorMessage,
  }) {
    return LocationSelectorState(
      states: states ?? this.states,
      cities: cities ?? this.cities,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [states, cities, status, errorMessage];
}
