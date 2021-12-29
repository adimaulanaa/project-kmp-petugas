import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class YearData extends Equatable {
  YearData({
    required this.name,
    required this.value,
  });

  final String name;
  final int value;

  List<Object> get props => [name, value];
}
