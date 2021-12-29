import 'package:dartz/dartz.dart';
import 'package:kmp_petugas_app/features/authentication/data/models/user_model.dart';
import 'package:kmp_petugas_app/features/profile/data/models/post_password.dart';
import 'package:kmp_petugas_app/features/profile/domain/entities/post_profile.dart';
import 'package:kmp_petugas_app/features/profile/domain/repositories/profile_repository.dart';
import 'package:kmp_petugas_app/framework/core/exceptions/failures.dart';
import 'package:kmp_petugas_app/framework/core/usecases/usecase.dart';

class ProfileUseCase implements UseCase<UserModel, NoParams> {
  ProfileUseCase(this.repository);

  final ProfileRepository repository;

  @override
  Future<Either<Failure, UserModel>> call(NoParams params) =>
      repository.profile();
}

class EditProfileUseCase implements UseCase<bool, PostProfile> {
  EditProfileUseCase(this.repository);

  final ProfileRepository repository;

  @override
  Future<Either<Failure, bool>> call(PostProfile params) =>
      repository.editProfile(params);
}

class ChangePasswordUseCase implements UseCase<bool, PostPassword> {
  ChangePasswordUseCase(this.repository);

  final ProfileRepository repository;

  @override
  Future<Either<Failure, bool>> call(PostPassword params) =>
      repository.changePassword(params);
}
