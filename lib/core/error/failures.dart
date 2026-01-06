abstract class Failure {
  final String message;
  Failure(this.message);
}

class ServerFailure extends Failure {
  ServerFailure([String message = 'Server error']) : super(message);
}

class AuthFailure extends Failure {
  AuthFailure([String message = 'Authentication error']) : super(message);
}

class UnverifiedPhoneFailure extends Failure {
  UnverifiedPhoneFailure([String message = 'Phone not verified']) : super(message);
}

class ParsingFailure extends Failure {
  ParsingFailure([String message = 'Parsing error']) : super(message);
}

