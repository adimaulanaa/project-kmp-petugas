import 'package:kmp_petugas_app/features/dues/data/models/house_model.dart';
import 'package:kmp_petugas_app/features/guest_book/data/models/guest_book_model.dart';

abstract class GuestBookState {
  List<Object> get props => [];
}

class GuestBookInitial extends GuestBookState {}

class GuestBookLoading extends GuestBookState {}

class GuestBookLoaded extends GuestBookState {
  GuestBookLoaded({
    this.isFromCacheFirst = false,
    this.data,
  });

  bool isFromCacheFirst;
  GuestBookModel? data;

  @override
  List<Object> get props => [isFromCacheFirst, data!];
}

class HousesLoading extends GuestBookState {}

class HousesLoaded extends GuestBookState {
  HousesLoaded({
    required this.data,
  });

  HousesModel data;

  @override
  List<Object> get props => [data];
}

class ProsesAdd extends GuestBookState {}

class AddGuestBookLoaded extends GuestBookState {}

class EditGuestBookLoaded extends GuestBookState {}

class GuestBookSuccess extends GuestBookState {
  final bool isSuccess;

  GuestBookSuccess({required this.isSuccess});

  @override
  List<Object> get props => [isSuccess];
}

class GuestBookFailure extends GuestBookState {
  GuestBookFailure({
    required this.error,
  });

  final String error;

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'guestBook Failure { error: $error }';
}

class HousesSuccess extends GuestBookState {
  final bool isSuccess;

  HousesSuccess({required this.isSuccess});

  @override
  List<Object> get props => [isSuccess];
}

class HousesFailure extends GuestBookState {
  HousesFailure({
    required this.error,
  });

  final String error;

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'HousesFailure { error: $error }';
}
