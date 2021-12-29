import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class GetDataHouse extends Equatable {
  GetDataHouse({
    required this.idHouse,
    required this.year,
  });

  final String idHouse;
  final int year;

  List<Object> get props => [idHouse, year];
}
