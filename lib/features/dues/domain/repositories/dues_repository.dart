import 'package:dartz/dartz.dart';
import 'package:kmp_petugas_app/features/dues/data/models/dues_model.dart';
import 'package:kmp_petugas_app/features/dues/data/models/house_model.dart';
import 'package:kmp_petugas_app/features/dues/domain/entities/post_dues.dart';
import 'package:kmp_petugas_app/features/dues/entities/data.dart';
import 'package:kmp_petugas_app/framework/core/exceptions/failures.dart';

abstract class DuesRepository {
  Future<Either<Failure, bool>> postDues(
      PostDues postDues);
  Future<Either<Failure, CitizenSubscriptionsModel>> dues();
  Future<Either<Failure, CitizenSubscriptionsModel>> duesFromCache();
  Future<Either<Failure, CitizenSubscriptionsModel>> monthYearData(
      GetDataHouse dataHouse);
      Future<Either<Failure, HousesModel>> housesFromCache();
      Future<Either<Failure, HousesModel>> houses();
}
