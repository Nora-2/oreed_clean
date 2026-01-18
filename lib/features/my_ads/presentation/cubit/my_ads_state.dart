part of 'my_ads_cubit.dart';

enum PersonAdsStatus { initial, loading, success, error, deleting }

class PersonAdsState extends Equatable {
  final PersonAdsStatus status;
  final List<UserAdEntity> ads;
  final String? errorMessage;
  final String? actionMessage; // For SnackBars (delete success/fail)

  const PersonAdsState({
    this.status = PersonAdsStatus.initial,
    this.ads = const [],
    this.errorMessage,
    this.actionMessage,
  });

  PersonAdsState copyWith({
    PersonAdsStatus? status,
    List<UserAdEntity>? ads,
    String? errorMessage,
    String? actionMessage,
  }) {
    return PersonAdsState(
      status: status ?? this.status,
      ads: ads ?? this.ads,
      errorMessage: errorMessage, // We allow this to be null
      actionMessage: actionMessage,
    );
  }

  @override
  List<Object?> get props => [status, ads, errorMessage, actionMessage];
}
