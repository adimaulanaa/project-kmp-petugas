import 'package:dartz/dartz.dart';
import 'package:kmp_petugas_app/features/authentication/data/models/user_model.dart';
import 'package:kmp_petugas_app/features/report/data/models/data.dart';
import 'package:kmp_petugas_app/features/report/data/models/report_model.dart';
import 'package:kmp_petugas_app/features/report/domain/repositories/report_repository.dart';
import 'package:kmp_petugas_app/framework/core/exceptions/failures.dart';
import 'package:kmp_petugas_app/framework/core/usecases/usecase.dart';

class ReportUseCase implements UseCase<ReportModel, ReportData> {
  ReportUseCase(this.repository);

  final ReportRepository repository;

  @override
  Future<Either<Failure, ReportModel>> call(ReportData params) =>
      repository.cashBook(params);
}

class PdfReportUseCases implements UseCase<String, ReportData> {
  PdfReportUseCases(this.repository);

  final ReportRepository repository;

  @override
  Future<Either<Failure, String>> call(ReportData params) =>
      repository.getPdf(params);
}

class SessionUseCase implements UseCase<UserModel, NoParams> {
  SessionUseCase(this.repository);

  final ReportRepository repository;

  @override
  Future<Either<Failure, UserModel>> call(NoParams params) =>
      repository.session();
}

class ReportFromCacheUseCase implements UseCase<ReportModel, NoParams> {
  ReportFromCacheUseCase(this.repository);

  final ReportRepository repository;

  @override
  Future<Either<Failure, ReportModel>> call(NoParams params) =>
      repository.cashBookFromCache();
}
