import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class MonthData extends Equatable {
  MonthData({
    required this.name,
    required this.value,
  });

  final String name;
  final int value;

  List<Object> get props => [name, value];
}
