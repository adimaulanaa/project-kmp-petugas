import 'package:kmp_petugas_app/features/authentication/data/models/user_model.dart';
import 'package:kmp_petugas_app/features/dashboard/data/models/dashboard_model.dart';
import 'package:kmp_petugas_app/features/guest_book/data/models/guest_book_today_model.dart';

abstract class DashboardState {
  List<Object> get props => [];
}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class GuestBookLoading extends DashboardState {}
// class ProfileLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  DashboardLoaded({this.isFromCacheFirst = false, this.data, this.profile});

  bool isFromCacheFirst;
  DashboardModel? data;

  UserModel? profile;

  @override
  List<Object> get props => [isFromCacheFirst, data!, profile!];
}

class GuestBookLoaded extends DashboardState {
  GuestBookLoaded({
    this.isFromCacheFirst = false,
    this.data,
  });

  bool isFromCacheFirst;
  GuestBookTodayModel? data;

  @override
  List<Object> get props => [isFromCacheFirst, data!];
}

class DashboardFailure extends DashboardState {
  DashboardFailure({
    required this.error,
  });

  final String error;

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'DashboardFailure { error: $error }';
}
