import 'package:equatable/equatable.dart';
import 'package:kmp_petugas_app/features/authentication/data/models/user_model.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {}

class LoginSubmitting extends LoginState {}

class LoginLoaded extends LoginState {
  LoginLoaded({
    required this.username,
    required this.password,
  });

  final String username;
  final String password;

  @override
  List<Object> get props => [username, password];
}

class LoginSuccess extends LoginState {
  LoginSuccess({
    required this.success,
  });

  final UserModel success;

  @override
  List<Object> get props => [success];
}

class LoginFailure extends LoginState {
  const LoginFailure({
    required this.error,
  });

  final String error;

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'LoginFailure { error: $error }';
}
