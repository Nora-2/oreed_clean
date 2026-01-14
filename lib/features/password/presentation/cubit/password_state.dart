part of 'password_cubit.dart';

enum PasswordStatus { initial, loading, success, error }

class PasswordState extends Equatable {
  final PasswordStatus status;
  final String? errorMessage;

  const PasswordState({
    this.status = PasswordStatus.initial,
    this.errorMessage,
  });

  PasswordState copyWith({
    PasswordStatus? status,
    String? errorMessage,
  }) {
    return PasswordState(
      status: status ?? this.status,
      errorMessage: errorMessage, // We allow resetting to null
    );
  }

  @override
  List<Object?> get props => [status, errorMessage];
}