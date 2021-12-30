import 'dart:async';
import 'package:kmp_petugas_app/features/dashboard/data/models/dashboard_model.dart';
import 'package:kmp_petugas_app/features/financial/data/models/data.dart';
import 'package:kmp_petugas_app/features/financial/domain/usecases/financial_statement_usecase.dart';
import 'package:kmp_petugas_app/features/financial/presentation/bloc/bloc.dart';
import 'package:kmp_petugas_app/framework/core/usecases/usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:kmp_petugas_app/framework/managers/helper.dart';
import 'package:kmp_petugas_app/framework/managers/hive_db_helper.dart';

class FinancialStatementBloc
    extends Bloc<FinancialStatementEvent, FinancialStatementState> {
  FinancialStatementBloc(
      {required FinancialStatementUseCase cashBookFinancial,
      required PdfReportUseCase pdfReport,
      required SessionUseCases session,
      required HiveDbServices dbServices,
      required FinancialStatementFromCacheUseCase cashBookFinancialFromCache})
      : _cashBookFinancial = cashBookFinancial,
        _pdfReport = pdfReport,
        _session = session,
        _dbServices = dbServices,
        _cashBookFinancialFromCache = cashBookFinancialFromCache,
        super(FinancialStatementInitial());

  final FinancialStatementUseCase _cashBookFinancial;
  final SessionUseCases _session;
  final PdfReportUseCase _pdfReport;
  final HiveDbServices _dbServices;
  final FinancialStatementFromCacheUseCase _cashBookFinancialFromCache;

  @override
  Stream<FinancialStatementState> mapEventToState(
    FinancialStatementEvent event,
  ) async* {
    if (event is GetCashBookFinancialEvent) {
      yield CashBookFinancialLoading();
      // final failureOrSuccessFromCache =
      //     await _cashBookFinancialFromCache(NoParams());
      // yield failureOrSuccessFromCache.fold(
      //   (failure) =>
      //       FinancialStatementFailure(error: mapFailureToMessage(failure)),
      //   (success) => CashBookFinancialLoaded(
      //     data: success,
      //   ),
      // );

      final failureOrSuccess = await _cashBookFinancial(CashBookData(
          yearstart: event.yearstart!,
          monthstart: event.monthstrat!,
          yearend: event.yearend!,
          monthend: event.monthend!,
          type: event.type!,
          ispaid: event.ispaid!));
      yield failureOrSuccess.fold(
        (failure) =>
            FinancialStatementFailure(error: mapFailureToMessage(failure)),
        (success) => CashBookFinancialLoaded(data: success),
      );
    } else if (event is LoadRtRw) {
      final data = await _dbServices.getData(HiveDbServices.boxDashboard);

      if (data == null) {
        yield FinancialStatementFailure(error: 'Data Tidak Ditemukan');
      } else {
        final dashboard = dashboardModelFromJson(data.toString());
        final listRwRt = dashboard.villageRwRts;
        final listVillage = dashboard.client!.villages;

        yield RtRwLoaded(listRwRt: listRwRt, listVillage: listVillage);
      }
    } else if (event is GetPdfReportEvent) {
      yield GetPdfReportLoading();

      final failureOrSuccess = await _pdfReport(CashBookData(
          yearstart: event.yearstart!,
          monthstart: event.monthstrat!,
          yearend: event.yearend!,
          monthend: event.monthend!,
          type: event.type!,
          ispaid: event.ispaid!,
          rtplace: event.rtplace!));

      if (failureOrSuccess.isRight()) {
        final pdfResult = failureOrSuccess.toOption().toNullable()!;

        yield GetPdfReportLoaded(data: pdfResult);
      } else {
        yield failureOrSuccess.fold(
          (failure) =>
              FinancialStatementFailure(error: mapFailureToMessage(failure)),
          (success) => GetPdfReportLoaded(data: ''),
        );
      }
    }
    if (event is GetSessionEvent) {
      yield SessionLoading();
      final failureOrSuccessFromCache = await _session(NoParams());
      yield failureOrSuccessFromCache.fold(
        (failure) =>
            FinancialStatementFailure(error: mapFailureToMessage(failure)),
        (success) => SessionLoaded(
          data: success,
        ),
      );

      final failureOrSuccess = await _session(NoParams());
      yield failureOrSuccess.fold(
        (failure) =>
            FinancialStatementFailure(error: mapFailureToMessage(failure)),
        (success) => SessionLoaded(data: success),
      );
    }
  }
}
