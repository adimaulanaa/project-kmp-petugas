import 'dart:async';
import 'package:kmp_petugas_app/features/report/data/models/data.dart';
import 'package:kmp_petugas_app/features/report/domain/usecases/report_usecase.dart';
import 'package:kmp_petugas_app/features/report/presentation/bloc/bloc.dart';
import 'package:kmp_petugas_app/framework/core/usecases/usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:kmp_petugas_app/framework/managers/helper.dart';

class ReportBloc extends Bloc<ReportEvent, ReportState> {
  ReportBloc(
      {required ReportUseCase cashBookFinancial,
      required PdfReportUseCases pdfReport,
      required SessionUseCase session,
      required ReportFromCacheUseCase cashBookFinancialFromCache})
      : _cashBookFinancial = cashBookFinancial,
        _pdfReport = pdfReport,
        _session = session,
        _cashBookFinancialFromCache = cashBookFinancialFromCache,
        super(ReportInitial());

  final ReportUseCase _cashBookFinancial;
  final SessionUseCase _session;
  final PdfReportUseCases _pdfReport;
  final ReportFromCacheUseCase _cashBookFinancialFromCache;

  @override
  Stream<ReportState> mapEventToState(
    ReportEvent event,
  ) async* {
    if (event is GetCashBookFinancialEvent) {
      yield CashBookFinancialLoading();
      // final failureOrSuccessFromCache =
      //     await _cashBookFinancialFromCache(NoParams());
      // yield failureOrSuccessFromCache.fold(
      //   (failure) =>
      //       ReportFailure(error: mapFailureToMessage(failure)),
      //   (success) => CashBookFinancialLoaded(
      //     data: success,
      //   ),
      // );

      final failureOrSuccess = await _cashBookFinancial(ReportData(
          yearstart: event.yearstart!,
          monthstart: event.monthstrat!,
          type: event.type!,
          ispaid: event.ispaid!));
      yield failureOrSuccess.fold(
        (failure) => ReportFailure(error: mapFailureToMessage(failure)),
        (success) => CashBookFinancialLoaded(data: success),
      );
    } else if (event is GetPdfReportEvent) {
      yield GetPdfReportLoading();

      final failureOrSuccess = await _pdfReport(ReportData(
          yearstart: event.yearstart!,
          monthstart: event.monthstrat!,
          type: event.type!,
          ispaid: event.ispaid!));

      if (failureOrSuccess.isRight()) {
        final pdfResult = failureOrSuccess.toOption().toNullable()!;

        yield GetPdfReportLoaded(data: pdfResult);
      } else {
        yield failureOrSuccess.fold(
          (failure) => ReportFailure(error: mapFailureToMessage(failure)),
          (success) => GetPdfReportLoaded(data: ''),
        );
      }
    }
    if (event is GetSessionEvent) {
      yield SessionLoading();
      final failureOrSuccessFromCache = await _session(NoParams());
      yield failureOrSuccessFromCache.fold(
        (failure) => ReportFailure(error: mapFailureToMessage(failure)),
        (success) => SessionLoaded(
          data: success,
        ),
      );

      final failureOrSuccess = await _session(NoParams());
      yield failureOrSuccess.fold(
        (failure) => ReportFailure(error: mapFailureToMessage(failure)),
        (success) => SessionLoaded(data: success),
      );
    }
  }
}
