import 'dart:async';
import 'package:kmp_petugas_app/features/authentication/data/models/user_model.dart';
import 'package:kmp_petugas_app/features/dashboard/presentation/bloc/bloc.dart';
import 'package:kmp_petugas_app/framework/core/usecases/usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:kmp_petugas_app/features/dashboard/domain/usecases/dashboard_usecase.dart';
import 'package:kmp_petugas_app/framework/managers/helper.dart';
import 'package:kmp_petugas_app/framework/managers/hive_db_helper.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc({
    required DashboardUseCase dashboard,
    required GuestBookUseCases guestBook,
    required DashboardFromCacheUseCase dashboardFromCache,
    required HiveDbServices dbServices,
  })  : _dashboard = dashboard,
        _guestBook = guestBook,
        _dbServices = dbServices,
        super(DashboardInitial());
  final DashboardUseCase _dashboard;
  final GuestBookUseCases _guestBook;
  final HiveDbServices _dbServices;

  @override
  Stream<DashboardState> mapEventToState(
    DashboardEvent event,
  ) async* {
    if (event is LoadDashboard) {
      yield DashboardLoading();

      // ambil data profile
      var string = await _dbServices.getUser();
      final user = userModelFromJson(string);

      final failureOrSuccess = await _dashboard(NoParams());
      yield failureOrSuccess.fold(
        (failure) => DashboardFailure(error: mapFailureToMessage(failure)),
        (success) => DashboardLoaded(data: success, profile: user),
      );
    }
    if (event is LoadGuestBook) {
      yield GuestBookLoading();

      final failureOrSuccess = await _guestBook(NoParams());
      yield failureOrSuccess.fold(
        (failure) => DashboardFailure(error: mapFailureToMessage(failure)),
        (success) => GuestBookLoaded(data: success),
      );
    }
  }
}
