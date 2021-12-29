import 'package:dartz/dartz.dart';
import 'package:kmp_petugas_app/config/string_resources.dart';
import 'package:kmp_petugas_app/env.dart';
import 'package:kmp_petugas_app/features/authentication/data/datasources/auth_local_datasource.dart';
import 'package:kmp_petugas_app/features/authentication/data/datasources/auth_remote_datasource.dart';
import 'package:kmp_petugas_app/features/authentication/data/models/user_model.dart';
import 'package:kmp_petugas_app/features/authentication/domain/repositories/auth_repository.dart';
import 'package:kmp_petugas_app/framework/core/exceptions/failures.dart';
import 'package:kmp_petugas_app/framework/core/exceptions/app_exceptions.dart';
import 'package:kmp_petugas_app/framework/core/network/network_info.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  @override
  Future<Either<Failure, UserModel>> signInWithCredentials(
    String email,
    String password, {
    String? deviceId,
    String? deviceBrand,
    String? deviceModel,
    String? deviceManufacture,
    String? deviceOS,
    String? deviceOSVersion,
    String? applicationVersion,
  }) async {
    UserModel user;

    if (await networkInfo.isConnected) {
      try {
        user = await remoteDataSource.signInWithCredentials(
          email,
          password,
        );
      } on UnauthorisedException {
        return Left(AuthenticationFailure());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message ?? ''));
      }
    } else {
      return Left(NetworkFailure(StringResources.NETWORK_FAILURE_MESSAGE));
    }

    return Right(user);
  }

  @override
  Future<Either<Failure, bool>> isSignedIn() async {
    bool isSignin = await localDataSource.isSignedIn();
    return Right(isSignin);
  }

  @override
  Future<Either<Failure, bool>> persistToken(UserModel userData) async {
    await localDataSource.persistToken(userData);
    return Right(true);
  }

  @override
  Future<Either<Failure, bool>> getAllToCache() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteDataUserProfiles = await remoteDataSource.getUserProfiles();
        await localDataSource.cacheUserProfiles(remoteDataUserProfiles);

        final remoteData = await remoteDataSource.getDashboard();
        await localDataSource.cacheDashboard(remoteData);

        return Right(true);
      } catch (e) {
        if (Env().value.isInDebugMode) {
          print("[getAllToCache] catching error $e");
        }
      }
    }

    return Right(false);
  }

  @override
  Future<Either<Failure, bool>> signOut() async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.signOut();
      } catch (e) {
        if (Env().value.isInDebugMode) {
          print("[signOut] catching error $e");
        }
      }
    }

    await localDataSource.clearToken();
    return Right(true);
  }
  //
}
