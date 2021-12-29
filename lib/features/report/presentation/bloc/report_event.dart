import 'package:equatable/equatable.dart';

abstract class ReportEvent extends Equatable {
  const ReportEvent();

  @override
  List<Object> get props => [];
}

class LoadCashBook extends ReportEvent {}

class GetSessionEvent extends ReportEvent {}

class GetCashBookFinancialEvent extends ReportEvent {
  final bool? ispaid;
  final int? yearstart;
  final int? monthstrat;
  final String? type;

  const GetCashBookFinancialEvent(
      {required this.yearstart,
      required this.monthstrat,
      required this.type,
      required this.ispaid});
}

class GetPdfReportEvent extends ReportEvent {
  final bool? ispaid;
  final int? yearstart;
  final int? monthstrat;
  final String? type;

  const GetPdfReportEvent(
      {required this.yearstart,
      required this.monthstrat,
      required this.type,
      required this.ispaid});
}
