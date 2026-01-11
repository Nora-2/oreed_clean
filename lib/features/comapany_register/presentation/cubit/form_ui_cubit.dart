import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oreed_clean/features/comapany_register/domain/entities/comapny_response_entity.dart';
import '../../domain/entities/company_entity.dart';
import '../../domain/usecases/create_company_usecase.dart';

enum CompanyFormStatus { idle, loading, success, error }

class CompanyFormState {
  final CompanyFormStatus status;
  final CompanyResponseEntity? response;
  final String? errorMessage;

  CompanyFormState({
    this.status = CompanyFormStatus.idle,
    this.response,
    this.errorMessage,
  });

  CompanyFormState copyWith({
    CompanyFormStatus? status,
    CompanyResponseEntity? response,
    String? errorMessage,
  }) {
    return CompanyFormState(
      status: status ?? this.status,
      response: response ?? this.response,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class CompanyFormCubit extends Cubit<CompanyFormState> {
  final CreateCompanyUseCase createCompanyUseCase;

  CompanyFormCubit(this.createCompanyUseCase) : super(CompanyFormState());

  Future<void> submitCompany(CompanyEntity company) async {
    emit(state.copyWith(status: CompanyFormStatus.loading));

    try {
      final response = await createCompanyUseCase(company);
      emit(state.copyWith(
        status: CompanyFormStatus.success,
        response: response,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: CompanyFormStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }
}