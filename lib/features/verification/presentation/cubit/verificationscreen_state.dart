part of 'verificationscreen_cubit.dart';

enum OtpStatus { initial, loading, success, error }

class VerificationState extends Equatable {
  final OtpStatus status;
  final String? error;
  final OtpResponseEntity? response;

  const VerificationState({
    this.status = OtpStatus.initial,
    this.error,
    this.response,
  });

  VerificationState copyWith({
    OtpStatus? status,
    String? error,
    OtpResponseEntity? response,
  }) {
    return VerificationState(
      status: status ?? this.status,
      error: error, // We allow error to be null to reset it
      response: response ?? this.response,
    );
  }

  @override
  List<Object?> get props => [status, error, response];
}