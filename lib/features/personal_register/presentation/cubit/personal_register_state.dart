part of 'personal_register_cubit.dart';

enum PersonalRegisterStatus { initial, loading, success, error }

class PersonalRegisterState extends Equatable {
  final PersonalRegisterStatus status;
  final RegisterResponseEntity? response;
  final String? errorMessage;

  const PersonalRegisterState({
    this.status = PersonalRegisterStatus.initial,
    this.response,
    this.errorMessage,
  });

  // Helper method to update the state easily
  PersonalRegisterState copyWith({
    PersonalRegisterStatus? status,
    RegisterResponseEntity? response,
    String? errorMessage,
  }) {
    return PersonalRegisterState(
      status: status ?? this.status,
      response: response ?? this.response,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, response, errorMessage];
}