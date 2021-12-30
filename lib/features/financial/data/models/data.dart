import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class CashBookData extends Equatable {
  CashBookData(
      {required this.yearstart,
      required this.monthstart,
      this.yearend,
      this.monthend,
      this.type,
      this.ispaid,
      this.rtplace
      });

  final bool? ispaid;
  final int monthstart;
  final int yearstart;
  final int? yearend;
  final int? monthend;
  final String? type;
  final List<String>? rtplace;

  List<Object> get props => [monthstart, yearstart, monthend!, yearend!, type!, ispaid!];
}
