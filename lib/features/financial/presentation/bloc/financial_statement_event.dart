import 'package:equatable/equatable.dart';

abstract class FinancialStatementEvent extends Equatable {
  const FinancialStatementEvent();

  @override
  List<Object> get props => [];
}

class LoadCashBook extends FinancialStatementEvent {}

class GetSessionEvent extends FinancialStatementEvent {}

class GetCashBookFinancialEvent extends FinancialStatementEvent {
  final bool? ispaid;
  final int? yearstart;
  final int? monthstrat;
  final int? yearend;
  final int? monthend;
  final String? type;

  const GetCashBookFinancialEvent(
      {required this.yearstart,
      required this.monthstrat,
      required this.yearend,
      required this.monthend,
      required this.type,
      required this.ispaid});
}

class GetPdfReportEvent extends FinancialStatementEvent {
  final bool? ispaid;
  final int? yearstart;
  final int? monthstrat;
  final int? yearend;
  final int? monthend;
  final String? type;

  const GetPdfReportEvent(
      {required this.yearstart,
      required this.monthstrat,
      required this.yearend,
      required this.monthend,
      required this.type,
      required this.ispaid});
}
