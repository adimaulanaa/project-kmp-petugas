import 'package:dartz/dartz.dart';
import 'package:kmp_petugas_app/features/authentication/data/models/user_model.dart';
import 'package:kmp_petugas_app/features/financial/data/models/cash_book_model.dart';
import 'package:kmp_petugas_app/features/financial/data/models/data.dart';
import 'package:kmp_petugas_app/features/financial/domain/repositories/financial_statement_repository.dart';
import 'package:kmp_petugas_app/framework/core/exceptions/failures.dart';
import 'package:kmp_petugas_app/framework/core/usecases/usecase.dart';

class FinancialStatementUseCase
    implements UseCase<CashBookModel, CashBookData> {
  FinancialStatementUseCase(this.repository);

  final FinancialStatementRepository repository;

  @override
  Future<Either<Failure, CashBookModel>> call(CashBookData params) =>
      repository.cashBook(params);
}

class PdfReportUseCase implements UseCase<String, CashBookData> {
  PdfReportUseCase(this.repository);

  final FinancialStatementRepository repository;

  @override
  Future<Either<Failure, String>> call(CashBookData params) =>
      repository.getPdf(params);
}

class SessionUseCases implements UseCase<UserModel, NoParams> {
  SessionUseCases(this.repository);

  final FinancialStatementRepository repository;

  @override
  Future<Either<Failure, UserModel>> call(NoParams params) =>
      repository.session();
}

class FinancialStatementFromCacheUseCase
    implements UseCase<CashBookModel, NoParams> {
  FinancialStatementFromCacheUseCase(this.repository);

  final FinancialStatementRepository repository;

  @override
  Future<Either<Failure, CashBookModel>> call(NoParams params) =>
      repository.cashBookFromCache();
}
