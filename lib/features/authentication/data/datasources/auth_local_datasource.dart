import 'package:kmp_petugas_app/features/dashboard/data/models/dashboard_model.dart';
import 'package:kmp_petugas_app/features/dashboard/data/models/region_model.dart';
import 'package:kmp_petugas_app/framework/managers/hive_db_helper.dart';
import 'package:kmp_petugas_app/features/authentication/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthLocalDataSource {
  Future<void> persistToken(UserModel userData);
  Future<bool> isSignedIn();
  Future<void> cacheUserProfiles(UserModel userProfileToCache);
  Future<void> clearToken();
  Future<void> cacheDashboard(DashboardModel dashboardToCache);
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  AuthLocalDataSourceImpl({
    required this.sharedPreferences,
    required this.dbService,
  });

  final HiveDbServices dbService;
  final SharedPreferences sharedPreferences;

  @override
  Future<bool> isSignedIn() async {
    /// read from keystore/keychain
    await Future.delayed(Duration(seconds: 1));
    var hasUserLogin = await dbService.hasData(HiveDbServices.boxToken);

    var isSignedIn = hasUserLogin;

    return isSignedIn;
  }

  @override
  Future<void> cacheUserProfiles(UserModel userProfileToCache) async {
    String data = userModelToJson(userProfileToCache);
    await dbService.addUser(data);
  }

  @override
  Future<void> persistToken(UserModel userData) async {
    /// write to keystore/keychain
    String data = userModelToJson(userData);
    await dbService.addUser(data);
    await dbService.addData(HiveDbServices.boxUsername, userData.username);
    await dbService.addData(HiveDbServices.boxToken, userData.token);
    return;
  }

  @override
  Future<void> clearToken() async {
    /// delete from keystore/keychain
    await Future.delayed(Duration(seconds: 1));
    await dbService.deleteData(HiveDbServices.boxUsername);
    await dbService.deleteData(HiveDbServices.boxLoggedInUser);
    await dbService.deleteData(HiveDbServices.boxGuestBook);
    await dbService.deleteData(HiveDbServices.boxDues);
    await dbService.deleteData(HiveDbServices.boxFinancial);
    await dbService.deleteData(HiveDbServices.boxToken);
    return;
  }

  @override
  Future<void> cacheDashboard(DashboardModel dashboardToCache) async {
    await _cacheDashboardLocalStorage(dashboardToCache);
  }

  Future<void> _cacheDashboardLocalStorage(
      DashboardModel dashboardToCache) async {
    String data = dashboardModelToJson(dashboardToCache);
    await dbService.addData(HiveDbServices.boxDashboard, data);
    String dataRegions = regionsModelToJson(dashboardToCache.regions!);
    await dbService.addData(HiveDbServices.boxRegions, dataRegions);
  }
}
