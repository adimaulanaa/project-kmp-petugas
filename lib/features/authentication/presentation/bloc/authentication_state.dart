

abstract class AuthenticationState {
  List<Object> get props => [];
}

class AuthenticationUninitialized extends AuthenticationState {}

class ViewWalkthrough extends AuthenticationState {}

class ViewLogin extends AuthenticationState {}

class AuthenticationAuthenticated extends AuthenticationState {}

class AuthenticationUnauthenticated extends AuthenticationState {}

class AuthenticationLoading extends AuthenticationState {}

class AuthenticationError extends AuthenticationState {
  AuthenticationError({
    required this.message,
  });

  final String message;

  @override
  List<Object> get props => [message];
}

class OfflineSyncSuccess extends AuthenticationState {
  OfflineSyncSuccess({
    required this.data,
  });

  final List<int> data;

  @override
  List<Object> get props => [data];
}

class OfflineSyncFailure extends AuthenticationState {
  OfflineSyncFailure({
    required this.error,
  });

  final String error;

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'OfflineSyncFailure { error: $error }';
}
