import 'package:equatable/equatable.dart';
import 'package:oreed_clean/features/technicalforms/domain/entities/city_entity.dart';
import 'package:oreed_clean/features/technicalforms/domain/entities/state_entity.dart';
import 'package:oreed_clean/features/technicalforms/domain/entities/technican_detailes_entity.dart';
import 'package:oreed_clean/features/technicalforms/domain/entities/technican_response_entity.dart';

abstract class TechnicianFormsState extends Equatable {
  const TechnicianFormsState();

  @override
  List<Object?> get props => [];
}

class TechnicianFormsInitial extends TechnicianFormsState {}

class StatesLoading extends TechnicianFormsState {}

class StatesLoaded extends TechnicianFormsState {
  final List<StateEntity> states;

  const StatesLoaded(this.states);

  @override
  List<Object?> get props => [states];
}

class StatesError extends TechnicianFormsState {
  final String message;

  const StatesError(this.message);

  @override
  List<Object?> get props => [message];
}

class CitiesLoading extends TechnicianFormsState {}

class CitiesLoaded extends TechnicianFormsState {
  final List<CityEntity> cities;

  const CitiesLoaded(this.cities);

  @override
  List<Object?> get props => [cities];
}

class CitiesError extends TechnicianFormsState {
  final String message;

  const CitiesError(this.message);

  @override
  List<Object?> get props => [message];
}

class TechnicianDetailsLoading extends TechnicianFormsState {}

class TechnicianDetailsLoaded extends TechnicianFormsState {
  final TechnicianDetailsEntity details;

  const TechnicianDetailsLoaded(this.details);

  @override
  List<Object?> get props => [details];
}

class TechnicianDetailsError extends TechnicianFormsState {
  final String message;

  const TechnicianDetailsError(this.message);

  @override
  List<Object?> get props => [message];
}

class SubmittingAd extends TechnicianFormsState {}

class AdSubmitted extends TechnicianFormsState {
  final TechnicianResponseEntity response;

  const AdSubmitted(this.response);

  @override
  List<Object?> get props => [response];
}

class AdSubmissionError extends TechnicianFormsState {
  final String message;

  const AdSubmissionError(this.message);

  @override
  List<Object?> get props => [message];
}

class UpdatingAd extends TechnicianFormsState {}

class AdUpdated extends TechnicianFormsState {
  final TechnicianResponseEntity response;

  const AdUpdated(this.response);

  @override
  List<Object?> get props => [response];
}

class AdUpdateError extends TechnicianFormsState {
  final String message;

  const AdUpdateError(this.message);

  @override
  List<Object?> get props => [message];
}
