import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class LoadLogin extends LoginEvent {}

class LoginWithCredentialsPressed extends LoginEvent {
  final String username;
  final String password;

  const LoginWithCredentialsPressed({
    required this.username,
    required this.password,
  });

  @override
  List<Object> get props => [username, password];

  @override
  String toString() =>
      'LoginWithCredentialsPressed { username: $username, password: $password }';
}

class LoginVerification extends LoginEvent {
  final String code;

  const LoginVerification({
    required this.code,
  });

  @override
  List<Object> get props => [code];

  @override
  String toString() => 'LoginVerification { code: $code }';
}

class LoginNewPassword extends LoginEvent {
  final String code;
  final String confirmation;

  const LoginNewPassword({
    required this.code,
    required this.confirmation,
  });

  @override
  List<Object> get props => [code, confirmation];

  @override
  String toString() =>
      'LoginVerification { code: $code, confirmation: $confirmation }';
}

class Register extends LoginEvent {
  final String username;
  final String handphone;
  final String password;

  const Register({
    required this.username,
    required this.handphone,
    required this.password,
  });

  @override
  List<Object> get props => [username, handphone, password];

  @override
  String toString() =>
      'Register { username: $username, handphone: $handphone, password: $password }';
}
