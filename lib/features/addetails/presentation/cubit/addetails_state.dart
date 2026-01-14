part of 'addetails_cubit.dart';

abstract class AddetailsState extends Equatable {
  const AddetailsState();

  @override
  List<Object?> get props => [];
}

class AddetailsInitial extends AddetailsState {}

class AddetailsLoading extends AddetailsState {}

class AddetailsLoaded extends AddetailsState {
  final AdDetailesEntity ad;
  const AddetailsLoaded(this.ad);

  @override
  List<Object?> get props => [ad];
}

class AddetailsError extends AddetailsState {
  final String message;
  const AddetailsError(this.message);

  @override
  List<Object?> get props => [message];
}
