import 'package:equatable/equatable.dart';
import 'package:oreed_clean/features/home/domain/entities/related_ad_entity.dart';
import '../../domain/entities/company_entity.dart';

enum CompanyDetailsStatus { idle, loading, loaded, error }

class CompanyDetailsState extends Equatable {
  final CompanyDetailsStatus status;
  final CompanyDetailsEntity? company;
  final List<RelatedAdEntity> ads;
  final String? errorMessage;
  final String? searchText;

  const CompanyDetailsState({
    this.status = CompanyDetailsStatus.idle,
    this.company,
    this.ads = const [],
    this.errorMessage,
    this.searchText,
  });

  CompanyDetailsState copyWith({
    CompanyDetailsStatus? status,
    CompanyDetailsEntity? company,
    List<RelatedAdEntity>? ads,
    String? errorMessage,
    String? searchText,
  }) {
    return CompanyDetailsState(
      status: status ?? this.status,
      company: company ?? this.company,
      ads: ads ?? this.ads,
      errorMessage: errorMessage,
      searchText: searchText ?? this.searchText,
    );
  }

  @override
  List<Object?> get props => [
        status,
        company,
        ads,
        errorMessage,
        searchText,
      ];
}
