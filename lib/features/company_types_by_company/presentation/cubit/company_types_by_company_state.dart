part of 'company_types_by_company_cubit.dart';

enum CompanyTypesCompanyStatus { idle, loading, success, error }

class CompanyTypesByCompanyState extends Equatable {
  final List<CompanyTypeCompanyEntity> companyTypes;
  final CompanyTypesCompanyStatus status;
  final String? error;

  const CompanyTypesByCompanyState({
    this.companyTypes = const [],
    this.status = CompanyTypesCompanyStatus.idle,
    this.error,
  });

  CompanyTypesByCompanyState copyWith({
    List<CompanyTypeCompanyEntity>? companyTypes,
    CompanyTypesCompanyStatus? status,
    String? error,
  }) {
    return CompanyTypesByCompanyState(
      companyTypes: companyTypes ?? this.companyTypes,
      status: status ?? this.status,
      error: error,
    );
  }

  @override
  List<Object?> get props => [companyTypes, status, error];
}
