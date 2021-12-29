import 'package:kmp_petugas_app/features/authentication/data/models/user_model.dart';
import 'package:kmp_petugas_app/features/report/data/models/report_model.dart';

abstract class ReportState {
  List<Object> get props => [];
}

class ReportInitial extends ReportState {}

class CashBookFinancialLoading extends ReportState {}

class SessionLoading extends ReportState {}

class CashBookFinancialLoaded extends ReportState {
  CashBookFinancialLoaded({this.data});

  ReportModel? data;

  @override
  List<Object> get props => [data!];
}

class SessionLoaded extends ReportState {
  SessionLoaded({
    this.data,
  });

  UserModel? data;

  @override
  List<Object> get props => [data!];
}

class GetPdfReportLoading extends ReportState {}

class GetPdfReportLoaded extends ReportState {
  GetPdfReportLoaded({this.data});

  String? data;

  @override
  List<Object> get props => [data!];
}

class ReportSuccess extends ReportState {
  final bool isSuccess;

  ReportSuccess({required this.isSuccess});

  @override
  List<Object> get props => [isSuccess];
}

class ReportFailure extends ReportState {
  ReportFailure({
    required this.error,
  });

  final String error;

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'CashBook Failure { error: $error }';
}
