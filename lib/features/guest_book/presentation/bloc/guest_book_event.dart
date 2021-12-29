import 'package:equatable/equatable.dart';
import 'package:kmp_petugas_app/features/guest_book/domain/entities/post_guest_book.dart';

abstract class GuestBookEvent extends Equatable {
  const GuestBookEvent();

  @override
  List<Object> get props => [];
}

class LoadGuestBook extends GuestBookEvent {}

class LoadHouses extends GuestBookEvent {
  
} 


class AddLoadGuestBook extends GuestBookEvent {}

class EditLoadGuestBook extends GuestBookEvent {}

class AddGuestBookEvent extends GuestBookEvent {
  final PostGuestBook guestBook;

  const AddGuestBookEvent({
    required this.guestBook,
  });
}

class EditGuestBookEvent extends GuestBookEvent {
  final PostGuestBook guestBookEdit;

  const EditGuestBookEvent({
    required this.guestBookEdit,
  });
}
