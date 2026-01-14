import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oreed_clean/features/companydetails/domain/usecases/get_company_ad_usecase.dart';
import 'package:oreed_clean/features/companydetails/domain/usecases/get_company_usecase.dart';
import 'package:oreed_clean/features/companydetails/presentation/cubit/companydetailes_state.dart';

class CompanyDetailsCubit extends Cubit<CompanyDetailsState> {
  final GetCompanyDetailsUseCase getCompanyDetailsUseCase;
  final GetCompanyAdsUseCase getCompanyAdsUseCase;

  CompanyDetailsCubit({
    required this.getCompanyDetailsUseCase,
    required this.getCompanyAdsUseCase,
  }) : super(const CompanyDetailsState());

  Future<void> fetchCompanyData(
    int companyId,
    int sectionId, {
    String? searchText,
  }) async {
    emit(
      state.copyWith(
        status: CompanyDetailsStatus.loading,
        searchText: searchText,
        errorMessage: null,
      ),
    );

    try {
      final company = await getCompanyDetailsUseCase(companyId);
      final ads = await getCompanyAdsUseCase(
        companyId,
        sectionId,
        searchText: searchText,
      );

      emit(
        state.copyWith(
          status: CompanyDetailsStatus.loaded,
          company: company,
          ads: ads,
        ),
      );
    } catch (e, st) {
      log('❌ Error fetching company details: $e', stackTrace: st);

      emit(
        state.copyWith(
          status: CompanyDetailsStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
