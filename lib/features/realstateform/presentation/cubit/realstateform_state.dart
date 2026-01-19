part of 'realstateform_cubit.dart';

abstract class RealstateformState extends Equatable {
  const RealstateformState();

  @override
  List<Object?> get props => [];
}

class RealstateformInitial extends RealstateformState {}

class RealstateformLoading extends RealstateformState {}

class RealstateformSuccess extends RealstateformState {
  final PropertyResponseEntity response;

  const RealstateformSuccess({required this.response});

  @override
  List<Object> get props => [response];
}

class RealstateformError extends RealstateformState {
  final String message;

  const RealstateformError({required this.message});

  @override
  List<Object> get props => [message];
}

class RealstateformDetailsLoaded extends RealstateformState {
  final PropertyDetailsEntity details;

  const RealstateformDetailsLoaded({required this.details});

  @override
  List<Object> get props => [details];
}

class RealstateformLoadingCountries extends RealstateformState {}

class RealstateformCountriesLoaded extends RealstateformState {
  final List<CountryEntity> countries;

  const RealstateformCountriesLoaded({required this.countries});

  @override
  List<Object> get props => [countries];
}

class RealstateformLoadingStates extends RealstateformState {}

class RealstateformStatesLoaded extends RealstateformState {
  final List<StateEntity> states;

  const RealstateformStatesLoaded({required this.states});

  @override
  List<Object> get props => [states];
}

class RealstateformStatesCleared extends RealstateformState {}
