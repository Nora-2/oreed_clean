import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/register_response_entity.dart';
import '../../domain/usecases/personal_register_usecase.dart';

part 'personal_register_state.dart';

class PersonalRegisterCubit extends Cubit<PersonalRegisterState> {
  final PersonalRegisterUseCase useCase;

  PersonalRegisterCubit(this.useCase) : super(const PersonalRegisterState());

  Future<void> register({
    required String name,
    required String phone,
    required String password,
    required String fcmToken,
  }) async {
    try {
      // Set status to loading
      emit(state.copyWith(status: PersonalRegisterStatus.loading));

      final result = await useCase(
        name: name,
        phone: phone,
        password: password,
        fcmToken: fcmToken,
      );

      if (result.status) {
        emit(state.copyWith(
          status: PersonalRegisterStatus.success,
          response: result,
        ));
      } else {
        emit(state.copyWith(
          status: PersonalRegisterStatus.error,
          errorMessage: 'Registration failed', // Or result.message if available
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: PersonalRegisterStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  void reset() {
    emit(const PersonalRegisterState());
  }
}