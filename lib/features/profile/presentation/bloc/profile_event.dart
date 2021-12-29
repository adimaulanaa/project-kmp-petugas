import 'package:equatable/equatable.dart';
import 'package:kmp_petugas_app/features/profile/data/models/post_password.dart';
import 'package:kmp_petugas_app/features/profile/domain/entities/post_profile.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class GetProfileEvent extends ProfileEvent {}

class EditLoadProfile extends ProfileEvent {}

class EditProfileEvent extends ProfileEvent {
  final PostProfile profileEdit;

  const EditProfileEvent({
    required this.profileEdit,
  });
}

class ChangePasswordEvent extends ProfileEvent {
  final PostPassword changePassword;

  const ChangePasswordEvent({
    required this.changePassword,
  });
}
