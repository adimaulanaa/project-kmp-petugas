import 'package:kmp_petugas_app/features/authentication/data/models/user_model.dart';
import 'package:kmp_petugas_app/features/dashboard/data/models/dashboard_model.dart';
import 'package:kmp_petugas_app/features/dashboard/data/models/region_model.dart';

abstract class ProfileState {
  List<Object> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class EditLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  ProfileLoaded({
    this.data,
  });

  UserModel? data;

  @override
  List<Object> get props => [data!];
}

class OfficersCategoryLoaded extends ProfileState {}

class EditProfileLoaded extends ProfileState {
  EditProfileLoaded({
    this.isFromCacheFirst = false,
    this.listVillage,
    this.listRegion,
  });

  bool isFromCacheFirst;
  List<Villages>? listVillage;
  List<RegionModel>? listRegion;

  @override
  List<Object> get props => [isFromCacheFirst, listVillage!, listRegion!];
}

class ChangePasswordSuccess extends ProfileState {
  final bool isSuccess;

  ChangePasswordSuccess({required this.isSuccess});

  @override
  List<Object> get props => [isSuccess];
}

class EditProfileSuccess extends ProfileState {
  final bool isSuccess;

  EditProfileSuccess({required this.isSuccess});

  @override
  List<Object> get props => [isSuccess];
}

class ProfileSuccess extends ProfileState {
  final bool isSuccess;

  ProfileSuccess({required this.isSuccess});

  @override
  List<Object> get props => [isSuccess];
}

class ProfileFailure extends ProfileState {
  ProfileFailure({
    required this.error,
  });

  final String error;

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'Profile Failure { error: $error }';
}
