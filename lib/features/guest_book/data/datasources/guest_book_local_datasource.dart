import 'package:kmp_petugas_app/features/dues/data/models/house_model.dart';
import 'package:kmp_petugas_app/features/guest_book/data/models/guest_book_model.dart';
import 'package:kmp_petugas_app/framework/core/exceptions/app_exceptions.dart';
import 'package:kmp_petugas_app/framework/managers/hive_db_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class GustBookLocalDataSource {
  Future<void> cacheGustBook(GuestBookModel guestBookToCache);
  Future<GuestBookModel> getLastCacheGustBook();
  Future<void> cacheHouse(HousesModel houseToCache);
  Future<HousesModel> getLastCacheHouse();
}

class GustBookLocalDataSourceImpl implements GustBookLocalDataSource {
  GustBookLocalDataSourceImpl({
    required this.sharedPreferences,
    required this.dbServices,
  });

  final SharedPreferences sharedPreferences;
  final HiveDbServices dbServices;

  @override
  Future<void> cacheGustBook(GuestBookModel guestBookToCache) async {
    await _cacheGustBookLocalStorage(guestBookToCache);
  }

  @override
  Future<GuestBookModel> getLastCacheGustBook() async {
    try {
      final data = await dbServices.getData(HiveDbServices.boxGuestBook);
      return guestBookModelFromJson(data);
    } catch (e) {
      throw CacheException();
    }
  }

  Future<void> _cacheGustBookLocalStorage(
      GuestBookModel guestBookToCache) async {
    String data = guestBookModelToJson(guestBookToCache);
    await dbServices.addData(HiveDbServices.boxGuestBook, data);
  }

  @override
  Future<void> cacheHouse(HousesModel houseToCache) async {
    await _cacheHouseLocalStorage(houseToCache);
  }

  @override
  Future<HousesModel> getLastCacheHouse() async {
    try {
      final data = await dbServices.getData(HiveDbServices.boxHouse);
      return housesModelFromJson(data);
    } catch (e) {
      throw CacheException();
    }
  }

  Future<void> _cacheHouseLocalStorage(HousesModel houseToCache) async {
    String data = housesModelToJson(houseToCache);
    await dbServices.addData(HiveDbServices.boxGuestBook, data);
  }

  //
}
