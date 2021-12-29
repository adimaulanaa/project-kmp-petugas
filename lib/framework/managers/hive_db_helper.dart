import 'package:hive/hive.dart';
import 'dart:async';

class HiveDbServices {
  static const String boxConfig = 'DAC_Config';
  static const String boxDeviceInfo = 'DAC_DeviceInfo';
  static const String boxIsLogin = 'DAC_IsLogin';
  static const String boxLastUsernameLoggedIn = 'DAC_LastUsernameLoggedIn';
  static const String boxLoggedInUser = 'DAC_UserLoggedIn';
  static const String boxRegions = 'DAC_Regions';
  static const String boxUsername = 'DAC_Username';
  static const String boxToken = 'DAC_Token';
  static const String boxDashboard = 'DAC_Dashboard';

  //
  static const String boxDues = 'DAC_Dues';
  static const String boxFinancial = 'DAC_Financial';
  static const String boxGuestBook = 'DAC_GuestBook';
  static const String boxHouse = 'DAC_House';

  //! Type ID
  static const int hiveTypeDashboard = 1;
  static const int hiveTypeRegion = 2;
  static const int hiveTypeUser = 3;
  //
  Future<Box> _openBox(String key) async => await Hive.openBox(key);
  Future<bool> addData(String key, dynamic data) async {
    var box = await _openBox(key);
    bool isSaved = false;
    if (data != null) {
      var inserted = box.put(key, data);
      isSaved = inserted != null ? true : false;
    }
    return isSaved;
  }

  Future<dynamic> getData(String key) async {
    var box = await _openBox(key);
    return box.get(key);
  }

  Future<bool> hasData(String key) async {
    var box = await _openBox(key);
    var value = box.get(key);
    return (value != null ? true : false);
  }

  Future<void> deleteData(String key) async {
    var box = await _openBox(key);
    var data = box.delete(key);
    return data;
  }

  //! User
  Future<Box> userBox() async => await Hive.openBox(boxLoggedInUser);

  Future<bool> addUser(String data) async {
    var box = await userBox();
    bool isSaved = false;
    if (data != null) {
      var inserted = box.put('user', data);
      isSaved = inserted != null ? true : false;
    }
    return isSaved;
  }

  Future<String> getUser() async {
    var box = await userBox();
    return box.get('user');
  }

  Future<bool> hasUser() async {
    var box = await userBox();
    var value = box.get('user');
    return (value != null ? true : false);
  }

  Future<void> deleteUser() async {
    var box = await userBox();
    var data = box.delete('user');
    return data;
  }
}
