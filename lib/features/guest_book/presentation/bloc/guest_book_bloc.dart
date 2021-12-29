import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:kmp_petugas_app/features/guest_book/domain/usecases/guest_book_usecase.dart';
import 'package:kmp_petugas_app/features/guest_book/presentation/bloc/bloc.dart';
import 'package:kmp_petugas_app/framework/core/usecases/usecase.dart';
import 'package:kmp_petugas_app/framework/managers/helper.dart';
import 'package:kmp_petugas_app/framework/managers/hive_db_helper.dart';

class GuestBookBloc extends Bloc<GuestBookEvent, GuestBookState> {
  GuestBookBloc({
    required GuestBookUseCase guestBook,
    // required GuestBookFromCacheUseCase guestBookFromCache,
    required HousesUseCase houses,
    // required HousesFromCacheUseCase housesFromCache,
    required HiveDbServices dbServices,
    required PostGuestBookUseCase addGuestBook,
  })  : _guestBook = guestBook,
        _houses = houses,
        // _guestBookFromCache = guestBookFromCache,
        // _dbServices = dbServices,
        _addGuestBook = addGuestBook,
        super(GuestBookInitial());

  final GuestBookUseCase _guestBook;
  final HousesUseCase _houses;
  final PostGuestBookUseCase _addGuestBook;
  // final GuestBookFromCacheUseCase _guestBookFromCache;
  // final HousesFromCacheUseCase _housesFromCache;
  // final HiveDbServices _dbServices;

  @override
  Stream<GuestBookState> mapEventToState(
    GuestBookEvent event,
  ) async* {
    if (event is LoadGuestBook) {
      yield GuestBookLoading();
      // final failureOrSuccessFromCache = await _guestBookFromCache(NoParams());
      // yield failureOrSuccessFromCache.fold(
      //   (failure) => GuestBookFailure(error: mapFailureToMessage(failure)),
      //   (success) => GuestBookLoaded(
      //     data: success,
      //   ),
      // );

      final failureOrSuccess = await _guestBook(NoParams());
      yield failureOrSuccess.fold(
        (failure) => GuestBookFailure(error: mapFailureToMessage(failure)),
        (success) => GuestBookLoaded(data: success),
      );
    }
    if (event is LoadHouses) {
      yield HousesLoading();
      final failureOrSuccessFromCache = await _houses(NoParams());
      yield failureOrSuccessFromCache.fold(
        (failure) => GuestBookFailure(error: mapFailureToMessage(failure)),
        (success) => HousesLoaded(
          data: success,
        ),
      );

      final failureOrSuccess = await _houses(NoParams());
      yield failureOrSuccess.fold(
        (failure) => GuestBookFailure(error: mapFailureToMessage(failure)),
        (success) => HousesLoaded(data: success),
      );
    }
    if (event is AddLoadGuestBook) {
      yield AddGuestBookLoaded();
    }

    if (event is EditLoadGuestBook) {
      yield EditGuestBookLoaded();
    }

    if (event is AddGuestBookEvent) {
      yield ProsesAdd();
      final failureOrSuccess = await _addGuestBook(event.guestBook);
      yield failureOrSuccess.fold(
          (failure) => GuestBookFailure(error: mapFailureToMessage(failure)),
          (loaded) => GuestBookSuccess(isSuccess: loaded));
    }
  }
}
