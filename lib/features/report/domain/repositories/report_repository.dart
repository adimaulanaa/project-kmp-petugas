import 'package:dartz/dartz.dart';
import 'package:kmp_petugas_app/features/authentication/data/models/user_model.dart';
import 'package:kmp_petugas_app/features/report/data/models/data.dart';
import 'package:kmp_petugas_app/features/report/data/models/report_model.dart';
import 'package:kmp_petugas_app/framework/core/exceptions/failures.dart';

abstract class ReportRepository {
  Future<Either<Failure, ReportModel>> cashBook(ReportData dataCashBook);
  Future<Either<Failure, String>> getPdf(ReportData getPdf);
  Future<Either<Failure, ReportModel>> cashBookFromCache();
  Future<Either<Failure, UserModel>> session();
}
