import 'package:kmp_petugas_app/features/authentication/data/models/user_model.dart';
import 'package:kmp_petugas_app/features/financial/data/models/cash_book_model.dart';
import 'package:kmp_petugas_app/framework/core/exceptions/app_exceptions.dart';
import 'package:kmp_petugas_app/framework/managers/hive_db_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class FinancialStatementLocalDataSource {
  Future<void> cacheCashBook(CashBookModel cashBookToCache);
  Future<CashBookModel> getLastCacheCashBook();
  Future<void> cacheSession(UserModel profileToCache);
  Future<UserModel> getLastCacheSession();
}

class FinancialStatementLocalDataSourceImpl
    implements FinancialStatementLocalDataSource {
  FinancialStatementLocalDataSourceImpl({
    required this.sharedPreferences,
    required this.dbServices,
  });

  final SharedPreferences sharedPreferences;
  final HiveDbServices dbServices;

  @override
  Future<void> cacheCashBook(CashBookModel cashBookToCache) async {
    await _cacheCashBookLocalStorage(cashBookToCache);
  }

  @override
  Future<CashBookModel> getLastCacheCashBook() async {
    try {
      final data = await dbServices.getData(HiveDbServices.boxFinancial);
      return cashBookModelFromJson(data);
    } catch (e) {
      throw CacheException();
    }
  }

  Future<void> _cacheCashBookLocalStorage(CashBookModel cashBookToCache) async {
    String data = cashBookModelToJson(cashBookToCache);
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
