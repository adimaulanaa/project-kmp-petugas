import 'package:kmp_petugas_app/features/authentication/data/models/user_model.dart';
import 'package:equatable/equatable.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class AppStarted extends AuthenticationEvent {}

class ShowLogin extends AuthenticationEvent {}

class LoggedIn extends AuthenticationEvent {
  const LoggedIn({
    required this.loggedInData,
  });

  final UserModel loggedInData;

  @override
  List<Object> get props => [loggedInData];

  @override
  String toString() => 'LoggedIn { loggedInData: $loggedInData }';
}

// class OfflineSyncing extends AuthenticationEvent {
//   const OfflineSyncing({
//     required this.offlineBeneficiaryiesData,
//   });

//   final List<SyncOffline> offlineBeneficiaryiesData;

//   @override
//   List<Object> get props => [offlineBeneficiaryiesData];
// }

class LoggedOut extends AuthenticationEvent {}
