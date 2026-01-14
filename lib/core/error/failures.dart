abstract class Failure {
  final String message;
  Failure(this.message);
}

class ServerFailure extends Failure {
  ServerFailure([super.message = 'Server error']);
}

class AuthFailure extends Failure {
  AuthFailure([super.message = 'Authentication error']);
}

class UnverifiedPhoneFailure extends Failure {
  UnverifiedPhoneFailure([super.message = 'Phone not verified']);
}

class ParsingFailure extends Failure {
  ParsingFailure([super.message = 'Parsing error']);
}

