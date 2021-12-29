import 'package:kmp_petugas_app/features/dues/data/models/dues_model.dart';
import 'package:kmp_petugas_app/features/dues/data/models/house_model.dart';
import 'package:kmp_petugas_app/framework/core/exceptions/app_exceptions.dart';
import 'package:kmp_petugas_app/framework/managers/hive_db_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class DuesLocalDataSource {
  Future<void> cacheHouse(HousesModel houseToCache);
  Future<HousesModel> getLastCacheHouse();
  Future<void> cacheDues(CitizenSubscriptionsModel houseToCache);
  Future<CitizenSubscriptionsModel> getLastCacheDues();
}

class DuesLocalDataSourceImpl implements DuesLocalDataSource {
  DuesLocalDataSourceImpl({
    required this.sharedPreferences,
    required this.dbServices,
  });

  final SharedPreferences sharedPreferences;
  final HiveDbServices dbServices;

  @override
  Future<void> cacheDues(CitizenSubscriptionsModel houseToCache) async {
    await _cacheDuesLocalStorage(houseToCache);
  }

  @override
  Future<CitizenSubscriptionsModel> getLastCacheDues() async {
    try {
      final data = await dbServices.getData(HiveDbServices.boxDues);
      return citizenSubscriptionsModelFromJson(data);
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheHouse(HousesModel houseToCache) async {
    await _cacheHouseLocalStorage(houseToCache);
  }

  @override
  Future<HousesModel> getLastCacheHouse() async {
    try {
      final data = await dbServices.getData(HiveDbServices.boxDues);
      return housesModelFromJson(data);
    } catch (e) {
      throw CacheException();
    }
  }

  Future<void> _cacheDuesLocalStorage(
      CitizenSubscriptionsModel houseToCache) async {
    String data = citizenSubscriptionsModelToJson(houseToCache);
    await dbServices.addData(HiveDbServices.boxDues, data);
  }

  Future<void> _cacheHouseLocalStorage(HousesModel houseToCache) async {
    String data = housesModelToJson(houseToCache);
    await dbServices.addData(HiveDbServices.boxDues, data);
  }

  //
}
