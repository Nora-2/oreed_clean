import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oreed_clean/features/login/domain/entities/user_entity.dart';
import 'package:oreed_clean/features/login/domain/usecases/login_usecase.dart';
part 'login_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase loginUseCase;

  AuthCubit(this.loginUseCase) : super(AuthInitial());

  Future<void> login(String phoneNumber, String password) async {
    emit(AuthLoading());
    try {
      final result = await loginUseCase(phoneNumber, password);
      result.fold((failure) {
        emit(AuthError(failure.message));
      }, (user) {
        emit(AuthSuccess(user));
      });
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  void reset() {
    emit(AuthInitial());
  }
}
