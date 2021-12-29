import 'package:dartz/dartz.dart';
import 'package:kmp_petugas_app/features/dues/data/models/dues_model.dart';
import 'package:kmp_petugas_app/features/dues/data/models/house_model.dart';
import 'package:kmp_petugas_app/features/dues/domain/entities/post_dues.dart';
import 'package:kmp_petugas_app/features/dues/domain/repositories/dues_repository.dart';
import 'package:kmp_petugas_app/features/dues/entities/data.dart';
import 'package:kmp_petugas_app/framework/core/exceptions/failures.dart';
import 'package:kmp_petugas_app/framework/core/usecases/usecase.dart';

class DuesUseCase implements UseCase<CitizenSubscriptionsModel, NoParams> {
  DuesUseCase(this.repository);

  final DuesRepository repository;

  @override
  Future<Either<Failure, CitizenSubscriptionsModel>> call(NoParams params) => repository.dues();
}

class DuesFromCacheUseCase implements UseCase<CitizenSubscriptionsModel, NoParams> {
  DuesFromCacheUseCase(this.repository);

  final DuesRepository repository;

  @override
  Future<Either<Failure, CitizenSubscriptionsModel>> call(NoParams params) =>
      repository.duesFromCache();
}

class ListHousesUseCase implements UseCase<HousesModel, NoParams> {
  ListHousesUseCase(this.repository);

  final DuesRepository repository;

  @override
  Future<Either<Failure, HousesModel>> call(NoParams params) =>
      repository.houses();
}

class ListHousesFromCacheUseCase
    implements UseCase<HousesModel, NoParams> {
  ListHousesFromCacheUseCase(this.repository);

  final DuesRepository repository;

  @override
  Future<Either<Failure, HousesModel>> call(NoParams params) =>
      repository.housesFromCache();
}

class LoadHouseListUsecase implements UseCase<HousesModel, NoParams> {
  LoadHouseListUsecase(this.repository);

  final DuesRepository repository;

  @override
  Future<Either<Failure, HousesModel>> call(NoParams params) =>
      repository.houses();
}

class PostDuesUseCase implements UseCase<bool, PostDues> {
  PostDuesUseCase(this.repository);

  final DuesRepository repository;

  @override
  Future<Either<Failure, bool>> call(PostDues params) =>
      repository.postDues(params);
}

class GetMonthYearUsecase implements UseCase<CitizenSubscriptionsModel, GetDataHouse> {
  GetMonthYearUsecase(this.repository);

  final DuesRepository repository;

  @override
  Future<Either<Failure, CitizenSubscriptionsModel>> call(GetDataHouse params) =>
      repository.monthYearData(params);
}
