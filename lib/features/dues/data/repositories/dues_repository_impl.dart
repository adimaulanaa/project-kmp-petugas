import 'package:dartz/dartz.dart';
import 'package:kmp_petugas_app/config/string_resources.dart';
import 'package:kmp_petugas_app/features/dues/data/datasources/dues_local_datasource.dart';
import 'package:kmp_petugas_app/features/dues/data/datasources/dues_remote_datasource.dart';
import 'package:kmp_petugas_app/features/dues/data/models/dues_model.dart';
import 'package:kmp_petugas_app/features/dues/data/models/house_model.dart';
import 'package:kmp_petugas_app/features/dues/domain/entities/post_dues.dart';
import 'package:kmp_petugas_app/features/dues/domain/repositories/dues_repository.dart';
import 'package:kmp_petugas_app/features/dues/entities/data.dart';
import 'package:kmp_petugas_app/framework/core/exceptions/app_exceptions.dart';
import 'package:kmp_petugas_app/framework/core/exceptions/failures.dart';
import 'package:kmp_petugas_app/framework/core/network/network_info.dart';

class DuesRepositoryImpl implements DuesRepository {
  DuesRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  final DuesRemoteDataSource remoteDataSource;
  final DuesLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  @override
  Future<Either<Failure, CitizenSubscriptionsModel>> duesFromCache() async {
    try {
      final localTrivia = await localDataSource.getLastCacheDues();
      return Right(localTrivia);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> postDues(PostDues dues) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteData = await remoteDataSource.postDues(dues);
        return Right(remoteData);
      } on BadRequestException catch (e) {
        return Left(BadRequestFailure(e.toString()));
      } on UnauthorisedException catch (e) {
        return Left(UnauthorisedFailure(e.toString()));
      } on NotFoundException catch (e) {
        return Left(NotFoundFailure(e.toString()));
      } on FetchDataException catch (e) {
        return Left(ServerFailure(e.message ?? ''));
      } on InvalidCredentialException catch (e) {
        return Left(InvalidCredentialFailure(e.toString()));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message ?? ''));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(StringResources.NETWORK_FAILURE_MESSAGE));
      }
    } else {
      return Left(NetworkFailure(StringResources.NETWORK_FAILURE_MESSAGE));
    }
  }

  @override
  Future<Either<Failure, CitizenSubscriptionsModel>> monthYearData(
      GetDataHouse dataHouse) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteData = await remoteDataSource.getMonthYear(dataHouse);
        return Right(remoteData);
      } on BadRequestException catch (e) {
        return Left(BadRequestFailure(e.toString()));
      } on UnauthorisedException catch (e) {
        return Left(UnauthorisedFailure(e.toString()));
      } on NotFoundException catch (e) {
        return Left(NotFoundFailure(e.toString()));
      } on FetchDataException catch (e) {
        return Left(ServerFailure(e.message ?? ''));
      } on InvalidCredentialException catch (e) {
        return Left(InvalidCredentialFailure(e.toString()));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message ?? ''));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(StringResources.NETWORK_FAILURE_MESSAGE));
      }
    } else {
      return Left(NetworkFailure(StringResources.NETWORK_FAILURE_MESSAGE));
    }
  }

  @override
  Future<Either<Failure, HousesModel>> houses() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteData = await remoteDataSource.getHouse();
        await localDataSource.cacheHouse(remoteData);
        return Right(remoteData);
      } on BadRequestException catch (e) {
        return Left(BadRequestFailure(e.toString()));
      } on UnauthorisedException catch (e) {
        return Left(UnauthorisedFailure(e.toString()));
      } on NotFoundException catch (e) {
        return Left(NotFoundFailure(e.toString()));
      } on FetchDataException catch (e) {
        return Left(ServerFailure(e.message ?? ''));
      } on InvalidCredentialException catch (e) {
        return Left(InvalidCredentialFailure(e.toString()));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message ?? ''));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(StringResources.NETWORK_FAILURE_MESSAGE));
      }
    } else {
      try {
        final localTrivia = await localDataSource.getLastCacheHouse();
        return Right(localTrivia);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, HousesModel>> housesFromCache() async {
    try {
      final localTrivia = await localDataSource.getLastCacheHouse();
      return Right(localTrivia);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, CitizenSubscriptionsModel>> dues() {
    // TODO: implement dues
    throw UnimplementedError();
  }
}
