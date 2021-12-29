import 'package:dartz/dartz.dart';
import 'package:kmp_petugas_app/features/dashboard/data/models/dashboard_model.dart';
import 'package:kmp_petugas_app/features/guest_book/data/models/guest_book_today_model.dart';
import 'package:kmp_petugas_app/framework/core/exceptions/failures.dart';

abstract class DashboardRepository {
  Future<Either<Failure, DashboardModel>> dashboard();
  Future<Either<Failure, GuestBookTodayModel>> guestBook();
  Future<Either<Failure, DashboardModel>> dashboardFromCache();
}
