import 'package:dartz/dartz.dart';
import 'package:kmp_petugas_app/features/dashboard/data/models/dashboard_model.dart';
import 'package:kmp_petugas_app/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:kmp_petugas_app/features/guest_book/data/models/guest_book_today_model.dart';
import 'package:kmp_petugas_app/framework/core/exceptions/failures.dart';
import 'package:kmp_petugas_app/framework/core/usecases/usecase.dart';

class DashboardUseCase implements UseCase<DashboardModel, NoParams> {
  DashboardUseCase(this.repository);

  final DashboardRepository repository;

  @override
  Future<Either<Failure, DashboardModel>> call(NoParams params) =>
      repository.dashboard();
}

class GuestBookUseCases implements UseCase<GuestBookTodayModel, NoParams> {
  GuestBookUseCases(this.repository);

  final DashboardRepository repository;

  @override
  Future<Either<Failure, GuestBookTodayModel>> call(NoParams params) =>
      repository.guestBook();
}

class DashboardFromCacheUseCase implements UseCase<DashboardModel, NoParams> {
  DashboardFromCacheUseCase(this.repository);

  final DashboardRepository repository;

  @override
  Future<Either<Failure, DashboardModel>> call(NoParams params) =>
      repository.dashboardFromCache();
}
