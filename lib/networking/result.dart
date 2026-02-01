import 'package:oreed_clean/networking/error/failures.dart';

abstract class Result<T> {
  const Result();

  R fold<R>(
      R Function(Failure failure) onFailure, R Function(T data) onSuccess);
}

class Success<T> extends Result<T> {
  final T data;

  const Success(this.data);

  @override
  R fold<R>(
      R Function(Failure failure) onFailure, R Function(T data) onSuccess) {
    return onSuccess(data);
  }
}

class Error<T> extends Result<T> {
  final Failure failure;

  const Error(this.failure);

  @override
  R fold<R>(
      R Function(Failure failure) onFailure, R Function(T data) onSuccess) {
    return onFailure(failure);
  }
}
