import 'package:equatable/equatable.dart';
import 'package:kmp_petugas_app/features/dues/domain/entities/post_dues.dart';

abstract class DuesEvent extends Equatable {
  const DuesEvent();

  @override
  List<Object> get props => [];
}

// class AddLoadDues extends DuesEvent {}
class LoadHouseEvent extends DuesEvent {}

class GetMonthYearEvent extends DuesEvent {
  final String? idHouse;
  final int? year;

  const GetMonthYearEvent({required this.idHouse, required this.year});
}

class AddDuesEvent extends DuesEvent {
  final PostDues postDues;

  const AddDuesEvent({
    required this.postDues,
  });
}
