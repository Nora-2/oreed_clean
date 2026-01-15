part of 'companyprofile_cubit.dart';

enum CompanyProfileStatus { idle, loading, success, error }

class CompanyprofileState extends Equatable {
  final CompanyProfileStatus status;
  final CompanyProfileEntity? profile;
  final List<CompanyAdEntity> ads;
  final int currentPage;
  final bool hasMore;
  final String? errorMessage;

  const CompanyprofileState({
    this.status = CompanyProfileStatus.idle,
    this.profile,
    this.ads = const [],
    this.currentPage = 1,
    this.hasMore = true,
    this.errorMessage,
  });

  CompanyprofileState copyWith({
    CompanyProfileStatus? status,
    CompanyProfileEntity? profile,
    List<CompanyAdEntity>? ads,
    int? currentPage,
    bool? hasMore,
    String? errorMessage,
  }) {
    return CompanyprofileState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      ads: ads ?? this.ads,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    profile,
    ads,
    currentPage,
    hasMore,
    errorMessage,
  ];
}
