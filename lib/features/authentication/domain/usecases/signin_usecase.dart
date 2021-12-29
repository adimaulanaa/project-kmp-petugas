import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:kmp_petugas_app/features/authentication/data/models/user_model.dart';

import 'package:kmp_petugas_app/features/authentication/domain/repositories/auth_repository.dart';
import 'package:kmp_petugas_app/framework/core/exceptions/failures.dart';
import 'package:kmp_petugas_app/framework/core/usecases/usecase.dart';

class SigninUseCase implements UseCase<UserModel, SignInParams> {
  SigninUseCase(this.repository);

  final AuthRepository repository;

  @override
  Future<Either<Failure, UserModel>> call(SignInParams params) async {
    return await repository.signInWithCredentials(
      params.username,
      params.password,
      applicationVersion: params.applicationVersion!,
      deviceId: params.deviceId!,
      deviceBrand: params.deviceBrand!,
      deviceManufacture: params.deviceManufacture!,
      deviceModel: params.deviceModel!,
      deviceOS: params.deviceOS!,
      deviceOSVersion: params.deviceOSVersion!,
    );
  }
}

class SignInParams extends Equatable {
  const SignInParams({
    required this.username,
    required this.password,
    this.deviceId,
    this.deviceBrand,
    this.deviceModel,
    this.deviceManufacture,
    this.deviceOS,
    this.deviceOSVersion,
    this.applicationVersion,
  });

  final String username;
  final String password;
  final String? deviceId;
  final String? deviceBrand;
  final String? deviceModel;
  final String? deviceManufacture;
  final String? deviceOS;
  final String? deviceOSVersion;
  final String? applicationVersion;

  @override
  List<Object> get props => [
        username,
        password,
        deviceId!,
        deviceBrand!,
        deviceModel!,
        deviceManufacture!,
        deviceOS!,
        deviceOSVersion!,
        applicationVersion!,
      ];
}
