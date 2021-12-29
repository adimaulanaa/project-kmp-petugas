import 'package:kmp_petugas_app/features/authentication/data/models/user_model.dart';
import 'package:kmp_petugas_app/features/dashboard/data/models/dashboard_model.dart';
import 'package:kmp_petugas_app/features/guest_book/data/models/guest_book_today_model.dart';
import 'package:kmp_petugas_app/framework/core/exceptions/app_exceptions.dart';
import 'package:kmp_petugas_app/framework/managers/hive_db_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class DashboardLocalDataSource {
  Future<void> cacheDashboard(DashboardModel dashboardToCache);
  Future<void> cacheGustBook(GuestBookTodayModel guestBookToCache);
  Future<GuestBookTodayModel> getLastCacheGustBook();
  Future<DashboardModel> getLastCacheDashboard();
  Future<void> cacheProfile(UserModel profileToCache);
  Future<UserModel> getLastCacheProfile();
}

class DashboardLocalDataSourceImpl implements DashboardLocalDataSource {
  DashboardLocalDataSourceImpl({
    required this.sharedPreferences,
    required this.dbServices,
  });

  final SharedPreferences sharedPreferences;
  final HiveDbServices dbServices;

  @override
  Future<void> cacheDashboard(DashboardModel dashboardToCache) async {
    await _cacheDashboardLocalStorage(dashboardToCache);
  }

  @override
  Future<DashboardModel> getLastCacheDashboard() async {
    try {
      final data = await dbServices.getData(HiveDbServices.boxDashboard);
      return dashboardModelFromJson(data);
    } catch (e) {
      throw CacheException();
    }
  }

  Future<void> _cacheDashboardLocalStorage(
      DashboardModel dashboardToCache) async {
    String data = dashboardModelToJson(dashboardToCache);
    await dbServices.addData(HiveDbServices.boxDashboard, data);
  }

  @override
  Future<void> cacheProfile(UserModel officersToCache) async {
    await _cacheOfficersLocalStorage(officersToCache);
  }

  @override
  Future<UserModel> getLastCacheProfile() async {
    try {
      final data = await dbServices.getUser();
      return userModelFromJson(data);
    } catch (e) {
      throw CacheException();
    }
  }

  Future<void> _cacheOfficersLocalStorage(UserModel profileToCache) async {
    String data = userModelToJson(profileToCache);
    await dbServices.addUser(data);
  }

  @override
  Future<void> cacheGustBook(GuestBookTodayModel guestBookToCache) async {
    await _cacheGustBookLocalStorage(guestBookToCache);
  }

  Future<void> _cacheGustBookLocalStorage(
      GuestBookTodayModel guestBookToCache) async {
    String data = guestBookTodayModelToJson(guestBookToCache);
    await dbServices.addData(HiveDbServices.boxGuestBook, data);
  }

  @override
  Future<GuestBookTodayModel> getLastCacheGustBook() async {
    try {
      final data = await dbServices.getData(HiveDbServices.boxGuestBook);
      return guestBookTodayModelFromJson(data);
    } catch (e) {
      throw CacheException();
    }
  }

  //
}
