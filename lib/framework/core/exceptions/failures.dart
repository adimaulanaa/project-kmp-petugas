import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  Failure([
    this.message = '',
  ]);

  final String message;

  @override
  List<Object> get props => [message];
}

// General failures
class ServerFailure extends Failure {
  ServerFailure([message]) : super(message ?? '');
}

class NetworkFailure extends Failure {
  NetworkFailure([message]) : super(message ?? '');
}

class AuthenticationFailure extends Failure {
  AuthenticationFailure([message]) : super(message ?? '');
}

class CacheFailure extends Failure {
  CacheFailure([message]) : super(message);
}

class InvalidCredentialFailure extends Failure {
  InvalidCredentialFailure([message]) : super(message ?? '');
}

class NotFoundFailure extends Failure {
  NotFoundFailure([message]) : super(message ?? '');
}

class BadRequestFailure extends Failure {
  BadRequestFailure([message]) : super(message ?? '');
}

class UnauthorisedFailure extends Failure {
  UnauthorisedFailure([message]) : super(message ?? '');
}

class FetchDataFailure extends Failure {
  FetchDataFailure([message]) : super(message ?? '');
}
