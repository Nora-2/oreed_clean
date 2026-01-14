// ignore_for_file: prefer_typing_uninitialized_variables

class CustomException implements Exception {
  final _message;
  final _prefix;

  CustomException([this._message, this._prefix]);

  @override
  String toString() {
    return "$_prefix$_message";
  }
}

class FetchDataException extends CustomException {
  FetchDataException([String? message])
      : super(message, "Error During Communication: ");
}

class BadRequestException extends CustomException {
  BadRequestException([message]) : super(message, "Invalid Request: ");
}

class UnauthorisedException extends CustomException {
  UnauthorisedException([message]) : super(message, "Unauthorised: ");
}

class InvalidInputException extends CustomException {
  InvalidInputException([String? message]) : super(message, "Invalid Input: ");
}

class ErrorMessgeException extends CustomException {
  Map bodyWithErrors;

  ErrorMessgeException({required this.bodyWithErrors})
      : super(bodyWithErrors, "data has an error validation: ");

  /// Extract only the message for UI display.
  String uiMessage() {
    if (bodyWithErrors.containsKey('msg')) {
      return bodyWithErrors['msg'].toString();
    }
    if (bodyWithErrors.containsKey('message')) {
      return bodyWithErrors['message'].toString();
    }
    // Common API validation payloads: {errors: {field: [msg]}}
    final errors = bodyWithErrors['errors'];
    if (errors is Map && errors.isNotEmpty) {
      final first = errors.values.first;
      if (first is List && first.isNotEmpty) return first.first.toString();
      return errors.values.first.toString();
    }
    return bodyWithErrors.toString();
  }
}
