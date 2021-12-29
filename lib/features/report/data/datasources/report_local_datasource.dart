import 'package:kmp_petugas_app/features/authentication/data/models/user_model.dart';
import 'package:kmp_petugas_app/features/report/data/models/report_model.dart';
import 'package:kmp_petugas_app/framework/core/exceptions/app_exceptions.dart';
import 'package:kmp_petugas_app/framework/managers/hive_db_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class ReportLocalDataSource {
  Future<void> cacheCashBook(ReportModel cashBookToCache);
  Future<ReportModel> getLastCacheCashBook();
  Future<void> cacheSession(UserModel profileToCache);
  Future<UserModel> getLastCacheSession();
}

class ReportLocalDataSourceImpl implements ReportLocalDataSource {
  ReportLocalDataSourceImpl({
    required this.sharedPreferences,
    required this.dbServices,
  });

  final SharedPreferences sharedPreferences;
  final HiveDbServices dbServices;

  @override
  Future<void> cacheCashBook(ReportModel cashBookToCache) async {
    await _cacheCashBookLocalStorage(cashBookToCache);
  }

  @override
  Future<ReportModel> getLastCacheCashBook() async {
    try {
      final data = await dbServices.getData(HiveDbServices.boxFinancial);
      return reportModelFromJson(data);
    } catch (e) {
      throw CacheException();
    }
  }

  Future<void> _cacheCashBookLocalStorage(ReportModel cashBookToCache) async {
    String data = reportModelToJson(cashBookToCache);
    await dbServices.addData(HiveDbServices.boxFinancial, data);
  }

  @override
  Future<void> cacheSession(UserModel sessionToCache) async {
    await _cacheSessionLocalStorage(sessionToCache);
  }

  @override
  Future<UserModel> getLastCacheSession() async {
    try {
      final data = await dbServices.getUser();
      return userModelFromJson(data);
    } catch (e) {
      throw CacheException();
    }
  }

  Future<void> _cacheSessionLocalStorage(UserModel sessionToCache) async {
    String data = userModelToJson(sessionToCache);
    await dbServices.addUser(data);
  }
}
