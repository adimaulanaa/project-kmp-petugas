import 'package:dartz/dartz.dart';
import 'package:kmp_petugas_app/features/authentication/data/models/user_model.dart';
import 'package:kmp_petugas_app/features/financial/data/models/cash_book_model.dart';
import 'package:kmp_petugas_app/features/financial/data/models/data.dart';
import 'package:kmp_petugas_app/framework/core/exceptions/failures.dart';

abstract class FinancialStatementRepository {
  Future<Either<Failure, CashBookModel>> cashBook(CashBookData dataCashBook);
  Future<Either<Failure, String>> getPdf(CashBookData getPdf);
  Future<Either<Failure, CashBookModel>> cashBookFromCache();
  Future<Either<Failure, UserModel>> session();
}
