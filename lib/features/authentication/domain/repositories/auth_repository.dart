import 'package:dartz/dartz.dart';
import 'package:kmp_petugas_app/features/authentication/data/models/user_model.dart';
import 'package:kmp_petugas_app/framework/core/exceptions/failures.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserModel>> signInWithCredentials(
    String email,
    String password, {
    String deviceId,
    String deviceBrand,
    String deviceModel,
    String deviceManufacture,
    String deviceOS,
    String deviceOSVersion,
    String applicationVersion,
  });
  Future<Either<Failure, bool>> isSignedIn();
  Future<Either<Failure, bool>> persistToken(UserModel userData);
  Future<Either<Failure, bool>> getAllToCache();
  Future<Either<Failure, bool>> signOut();
}
