import 'package:kmp_petugas_app/features/authentication/data/models/user_model.dart';
import 'package:kmp_petugas_app/framework/core/exceptions/app_exceptions.dart';
import 'package:kmp_petugas_app/framework/managers/hive_db_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class ProfileLocalDataSource {
  Future<void> cacheProfile(UserModel profileToCache);
  Future<UserModel> getLastCacheProfile();
}

class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {
  ProfileLocalDataSourceImpl({
    required this.sharedPreferences,
    required this.dbServices,
  });

  final SharedPreferences sharedPreferences;
  final HiveDbServices dbServices;

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

  //
}
