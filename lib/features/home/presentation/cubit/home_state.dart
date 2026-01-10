part of 'home_cubit.dart';

enum HomeStatus { idle, loading, success, error }

class MainHomeState extends Equatable {
  final HomeStatus status;
  final String? errorMessage;
  final List<SectionEntity> sections;

  final HomeStatus relatedAdsStatus;
  final String? relatedAdsError;
  final List<RelatedAd> relatedAdsCars;
  final List<RelatedAd> relatedAdsRealEstate;
  final List<RelatedAd> relatedAdsTechnical;
  final List<RelatedAd> relatedAdsPhones;

  const MainHomeState({
    this.status = HomeStatus.idle,
    this.errorMessage,
    this.sections = const [],
    this.relatedAdsStatus = HomeStatus.idle,
    this.relatedAdsError,
    this.relatedAdsCars = const [],
    this.relatedAdsRealEstate = const [],
    this.relatedAdsTechnical = const [],
    this.relatedAdsPhones = const [],
  });

  MainHomeState copyWith({
    HomeStatus? status,
    String? errorMessage,
    List<SectionEntity>? sections,
    HomeStatus? relatedAdsStatus,
    String? relatedAdsError,
    List<RelatedAd>? relatedAdsCars,
    List<RelatedAd>? relatedAdsRealEstate,
    List<RelatedAd>? relatedAdsTechnical,
    List<RelatedAd>? relatedAdsPhones,
  }) {
    return MainHomeState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      sections: sections ?? this.sections,
      relatedAdsStatus: relatedAdsStatus ?? this.relatedAdsStatus,
      relatedAdsError: relatedAdsError ?? this.relatedAdsError,
      relatedAdsCars: relatedAdsCars ?? this.relatedAdsCars,
      relatedAdsRealEstate: relatedAdsRealEstate ?? this.relatedAdsRealEstate,
      relatedAdsTechnical: relatedAdsTechnical ?? this.relatedAdsTechnical,
      relatedAdsPhones: relatedAdsPhones ?? this.relatedAdsPhones,
    );
  }

  @override
  List<Object?> get props => [
        status,
        errorMessage,
        sections,
        relatedAdsStatus,
        relatedAdsError,
        relatedAdsCars,
        relatedAdsRealEstate,
        relatedAdsTechnical,
        relatedAdsPhones,
      ];
}