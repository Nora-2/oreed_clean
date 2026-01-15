import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:oreed_clean/features/company_types_by_company/domain/entities/company_types_entity.dart';
import 'package:oreed_clean/features/company_types_by_company/domain/usecases/get_company_types_by_company.dart';

part 'company_types_by_company_state.dart';

class CompanyTypesByCompanyCubit extends Cubit<CompanyTypesByCompanyState> {
  final GetCompanyTypesByCompanyUseCase getCompanyTypesByCompanyUseCase;

  CompanyTypesByCompanyCubit(this.getCompanyTypesByCompanyUseCase)
    : super(const CompanyTypesByCompanyState());

  Future<void> fetchCompanyTypes(String companyId, Map? filter) async {
    emit(
      state.copyWith(status: CompanyTypesCompanyStatus.loading, error: null),
    );

    try {
      final result = await getCompanyTypesByCompanyUseCase.call(
        companyId,
        filter,
      );

      emit(
        state.copyWith(
          companyTypes: result,
          status: CompanyTypesCompanyStatus.success,
        ),
      );
    } catch (e, st) {
      log("❌ Failed to fetch company types: $e", stackTrace: st);

      emit(
        state.copyWith(
          status: CompanyTypesCompanyStatus.error,
          error: e.toString(),
        ),
      );
    }
  }
}
