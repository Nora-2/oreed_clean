import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:oreed_clean/features/login/domain/repositories/auth_repo.dart';

part 'password_state.dart';

class PasswordCubit extends Cubit<PasswordState> {
  final AuthRepository authRepository;

  PasswordCubit(this.authRepository) : super(const PasswordState());

  Future<void> submitNewPassword({
    required String phone,
    required String password,
  }) async {
    emit(state.copyWith(status: PasswordStatus.loading, errorMessage: null));

    try {
      final body = {
        "password": password,
        "phone1": phone,
      };

      // Calls your AuthRepositoryImpl changePassword method
      await authRepository.changePassword(body);
      
      emit(state.copyWith(status: PasswordStatus.success));
    } catch (e) {
      // Clean up the error message from the exception
      final msg = e.toString().replaceAll('Exception: ', '');
      emit(state.copyWith(
        status: PasswordStatus.error,
        errorMessage: msg,
      ));
    }
  }

  void reset() => emit(const PasswordState());
}