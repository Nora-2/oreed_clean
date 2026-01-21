// lib/features/car_ads/presentation/cubit/carform_state.dart
part of 'carform_cubit.dart';

abstract class CarformState extends Equatable {
  const CarformState();

  @override
  List<Object?> get props => [];
}

// ========== Initial State ==========
class CarformInitial extends CarformState {}

// ========== Brands States ==========
class CarformBrandsLoading extends CarformState {}

class CarformBrandsLoaded extends CarformState {
  final List<BrandEntity> brands;

  const CarformBrandsLoaded({required this.brands});

  @override
  List<Object?> get props => [brands];
}

// ========== Models States ==========
class CarformModelsLoading extends CarformState {}

class CarformModelsLoaded extends CarformState {
  final List<CarModelEntity> models;

  const CarformModelsLoaded({required this.models});

  @override
  List<Object?> get props => [models];
}

class CarformModelsCleared extends CarformState {}

// ========== States (Governorates) States ==========
class CarformStatesLoading extends CarformState {}

class CarformStatesLoaded extends CarformState {
  final List<StateEntity> states;

  const CarformStatesLoaded({required this.states});

  @override
  List<Object?> get props => [states];
}

// ========== Cities States ==========
class CarformCitiesLoading extends CarformState {}

class CarformCitiesLoaded extends CarformState {
  final List<CityEntity> cities;

  const CarformCitiesLoaded({required this.cities});

  @override
  List<Object?> get props => [cities];
}

// ========== Car Details States (for editing) ==========
class CarformDetailsLoading extends CarformState {}

class CarformDetailsLoaded extends CarformState {
  final CarDetailsEntity details;

  const CarformDetailsLoaded({required this.details});

  @override
  List<Object?> get props => [details];
}

// ========== Submission States ==========
class CarformSubmitting extends CarformState {}

class CarformSubmitSuccess extends CarformState {
  final CarResponseEntity response;

  const CarformSubmitSuccess({required this.response});

  @override
  List<Object?> get props => [response];
}

class CarformUpdateSuccess extends CarformState {
  final CarResponseEntity response;

  const CarformUpdateSuccess({required this.response});

  @override
  List<Object?> get props => [response];
}

// ========== Error State ==========
class CarformError extends CarformState {
  final String message;

  const CarformError({required this.message});

  @override
  List<Object?> get props => [message];
}