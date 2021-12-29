import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class ReportData extends Equatable {
  ReportData(
      {required this.yearstart,
      required this.monthstart,
      this.type,
      this.ispaid});

  final bool? ispaid;
  final int monthstart;
  final int yearstart;
  final String? type;

  List<Object> get props =>
      [monthstart, yearstart, type!, ispaid!];
}
