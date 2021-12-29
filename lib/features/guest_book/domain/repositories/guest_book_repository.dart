import 'package:dartz/dartz.dart';
import 'package:kmp_petugas_app/features/dues/data/models/house_model.dart';
import 'package:kmp_petugas_app/features/guest_book/data/models/guest_book_model.dart';
import 'package:kmp_petugas_app/features/guest_book/domain/entities/post_guest_book.dart';
import 'package:kmp_petugas_app/framework/core/exceptions/failures.dart';

abstract class GuestBookRepository {
  Future<Either<Failure, bool>> postGuestBook(PostGuestBook gustBook);

  Future<Either<Failure, GuestBookModel>> guestBook();
  Future<Either<Failure, GuestBookModel>> guestBookFromCache();
  Future<Either<Failure, HousesModel>> houses();
  Future<Either<Failure, HousesModel>> housesFromCache();
}
