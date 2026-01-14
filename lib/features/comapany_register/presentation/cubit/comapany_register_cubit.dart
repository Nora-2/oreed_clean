import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:oreed_clean/features/comapany_register/domain/usecases/get_categories_usecase.dart';
import 'package:oreed_clean/features/comapany_register/domain/usecases/get_country_usecase.dart';
import 'package:oreed_clean/features/comapany_register/domain/usecases/get_state_usecase.dart';
import 'package:oreed_clean/features/comapany_register/domain/usecases/rwgister_company_usecase.dart';
import 'package:oreed_clean/features/comapany_register/presentation/cubit/comapany_register_state.dart';
import 'package:oreed_clean/features/home/domain/usecases/get_categories_usecase.dart';

class CompanyRegisterCubit extends Cubit<CompanyRegisterState> {
  final GetCountriesUseCase getCountriesUseCase;
  final GetStatesUseCase getStatesUseCase;
  final GetCategoriesUseCase getCategoriesUseCase;
  final RegisterCompanyUseCase registerCompanyUseCase;
  final GetSectionsUseCase getSectionsUseCase;

  CompanyRegisterCubit(
    this.getCountriesUseCase,
    this.getStatesUseCase,
    this.getCategoriesUseCase,
    this.registerCompanyUseCase,
    this.getSectionsUseCase,
  ) : super(const CompanyRegisterState());

  Future<void> fetchCountries() async {
    emit(state.copyWith(status: RegisterStatus.loading));
    try {
      final countries = await getCountriesUseCase();
      emit(
        state.copyWith(status: RegisterStatus.success, countries: countries),
      );
    } catch (e, s) {
      log('❌ fetchCountries error: $e\n$s');
      emit(state.copyWith(status: RegisterStatus.error, error: e.toString()));
    }
  }

  Future<void> fetchStates(int countryId) async {
    emit(state.copyWith(status: RegisterStatus.loading));
    try {
      final states = await getStatesUseCase(countryId);
      emit(state.copyWith(status: RegisterStatus.success, states: states));
    } catch (e, s) {
      log('❌ fetchStates error: $e\n$s');
      emit(state.copyWith(status: RegisterStatus.error, error: e.toString()));
    }
  }

  Future<void> fetchSections() async {
    emit(state.copyWith(status: RegisterStatus.loading));
    try {
      final sections = await getSectionsUseCase(1);
      emit(state.copyWith(status: RegisterStatus.success, sections: sections));
    } catch (e, s) {
      log('❌ fetchSections error: $e\n$s');
      emit(state.copyWith(status: RegisterStatus.error, error: e.toString()));
    }
  }

  Future<void> getCategories(int sectionId) async {
    emit(state.copyWith(status: RegisterStatus.loading));
    try {
      final result = await getCategoriesUseCase(sectionId);

      if (sectionId == 1) {
        emit(
          state.copyWith(
            status: RegisterStatus.success,
            categoriesCars: result,
          ),
        );
      } else if (sectionId == 2) {
        emit(
          state.copyWith(
            status: RegisterStatus.success,
            categoriesProperties: result,
          ),
        );
      } else if (sectionId == 3) {
        emit(
          state.copyWith(
            status: RegisterStatus.success,
            categoriesTechnicians: result,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: RegisterStatus.success,
            categoriesAnyThing: result,
          ),
        );
      }
    } catch (e, s) {
      log('❌ getCategories error: $e\n$s');
      emit(state.copyWith(status: RegisterStatus.error, error: e.toString()));
    }
  }

  Future<void> submitRegister(Map<String, dynamic> body) async {
    emit(
      state.copyWith(
        status: RegisterStatus.loading,
        error: null,
        response: null,
      ),
    );
    try {
      final response = await registerCompanyUseCase(body);

      if (response.status == true) {
        log('✅ Registration success: ${response.msg}');
        emit(
          state.copyWith(status: RegisterStatus.success, response: response),
        );
      } else {
        log('❌ submitRegister error: ${response.msg}');
        emit(
          state.copyWith(
            status: RegisterStatus.error,
            error: response.msg ,
            response: response,
          ),
        );
      }
    } catch (e, s) {
      log('❌ submitRegister error: $e\n$s');
      emit(state.copyWith(status: RegisterStatus.error, error: e.toString()));
    }
  }

  void reset() {
    emit(const CompanyRegisterState());
  }
}
