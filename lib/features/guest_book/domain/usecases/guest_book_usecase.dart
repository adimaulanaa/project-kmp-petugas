import 'package:dartz/dartz.dart';
import 'package:kmp_petugas_app/features/dues/data/models/house_model.dart';
import 'package:kmp_petugas_app/features/guest_book/data/models/guest_book_model.dart';
import 'package:kmp_petugas_app/features/guest_book/domain/entities/post_guest_book.dart';
import 'package:kmp_petugas_app/features/guest_book/domain/repositories/guest_book_repository.dart';
import 'package:kmp_petugas_app/framework/core/exceptions/failures.dart';
import 'package:kmp_petugas_app/framework/core/usecases/usecase.dart';

class GuestBookUseCase implements UseCase<GuestBookModel, NoParams> {
  GuestBookUseCase(this.repository);

  final GuestBookRepository repository;

  @override
  Future<Either<Failure, GuestBookModel>> call(NoParams params) =>
      repository.guestBook();
}

class GuestBookFromCacheUseCase implements UseCase<GuestBookModel, NoParams> {
  GuestBookFromCacheUseCase(this.repository);

  final GuestBookRepository repository;

  @override
  Future<Either<Failure, GuestBookModel>> call(NoParams params) =>
      repository.guestBookFromCache();
}

class HousesUseCase implements UseCase<HousesModel, NoParams> {
  HousesUseCase(this.repository);

  final GuestBookRepository repository;

  @override
  Future<Either<Failure, HousesModel>> call(NoParams params) =>
      repository.houses();
}

class HousesFromCacheUseCase
    implements UseCase<HousesModel, NoParams> {
  HousesFromCacheUseCase(this.repository);

  final GuestBookRepository repository;

  @override
  Future<Either<Failure, HousesModel>> call(NoParams params) =>
      repository.housesFromCache();
}

class PostGuestBookUseCase implements UseCase<bool, PostGuestBook> {
  PostGuestBookUseCase(this.repository);

  final GuestBookRepository repository;

  @override
  Future<Either<Failure, bool>> call(PostGuestBook params) =>
      repository.postGuestBook(params);
}

// class EditGuestBookUseCase implements UseCase<bool, PostGuestBook> {
//   EditGuestBookUseCase(this.repository);

//   final GuestBookRepository repository;

//   @override
//   Future<Either<Failure, bool>> call(PostGuestBook params) =>
//       repository.editGustBook(params);
// }
