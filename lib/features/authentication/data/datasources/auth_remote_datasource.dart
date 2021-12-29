import 'dart:io';
import 'package:global_configuration/global_configuration.dart';
import 'package:kmp_petugas_app/config/global_vars.dart';
import 'package:kmp_petugas_app/env.dart';
import 'package:kmp_petugas_app/features/dashboard/data/models/dashboard_model.dart';
import 'package:kmp_petugas_app/framework/managers/hive_db_helper.dart';
import 'package:kmp_petugas_app/features/authentication/data/models/user_model.dart';
import 'package:kmp_petugas_app/framework/core/exceptions/app_exceptions.dart';
import 'package:kmp_petugas_app/framework/managers/http_manager.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> signInWithCredentials(
    String email,
    String password, {
    String deviceId,
    String deviceBrand,
    String deviceModel,
    String deviceManufacture,
    String deviceOS,
    String deviceOSVersion,
    String applicationVersion,
  });
  Future<DashboardModel> getDashboard();

  Future<void> signOut();
  Future<UserModel> getUserProfiles();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl({
    required this.httpManager,
    required this.dbService,
  });

  final HttpManager httpManager;
  final HiveDbServices dbService;

  @override
  Future<UserModel> signInWithCredentials(
    String username,
    String password, {
    String? deviceId,
    String? deviceBrand,
    String? deviceModel,
    String? deviceManufacture,
    String? deviceOS,
    String? deviceOSVersion,
    String? applicationVersion,
  }) async {
    try {
      // retrieve login path from remote auth url
      await GlobalConfiguration().loadFromUrl(_getAuthUrl(username));
    } catch (e) {
      //
      if (Env().isInDebugMode) {
        print('[signInWithCredentials] GlobalConfiguration error: $e');
      }
      throw ServerException();
    }

    String apiLogin = GlobalConfiguration().getValue(GlobalVars.API_LOGIN_PATH);
    if (Env().isInDebugMode) {
      // apiLogin += '?env=' + GlobalConfiguration().getValue(GlobalVars.ENV);
      print('[signInWithCredentials] apiLogin url: $apiLogin');
    }
    return _signInWithCredentials(apiLogin, {
      "username": username,
      "password": password,
      "device_id": deviceId,
      "device_brand": deviceBrand,
      "device_model": deviceModel,
      "device_manufacture": deviceManufacture,
      "device_os": deviceOS,
      "device_os_version": deviceOSVersion,
      "application_version": applicationVersion,
    });
  }

  Future<UserModel> _signInWithCredentials(
      String url, Map<String, dynamic> body) async {
    final response = await httpManager.post(
      url: url,
      body: body,
    );

    if (response != null && response.statusCode == 201) {
      return UserModel.fromJson(response.data);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<void> signOut() => _signOut('/logout');

  Future<void> _signOut(url) async {
    var token = await dbService.getData(HiveDbServices.boxToken);

    await httpManager.post(
      url: url,
      headers: {
        HttpHeaders.authorizationHeader: 'bearer $token',
      },
    );
  }

  @override
  Future<UserModel> getUserProfiles() =>
      _getUserProfilesFromUrl('/users/session');

  Future<UserModel> _getUserProfilesFromUrl(String url) async {
    var token = await dbService.getData(HiveDbServices.boxToken);

    final response = await httpManager.get(
      url: url,
      headers: {
        HttpHeaders.authorizationHeader: 'bearer $token',
      },
    );

    if (response != null && response.statusCode == 201) {
      return UserModel.fromJson(response.data);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<DashboardModel> getDashboard() =>
      _getDashboardFromUrl('/home?with_region=true');

  Future<DashboardModel> _getDashboardFromUrl(String url) async {
    var token = await dbService.getData(HiveDbServices.boxToken);

    final response = await httpManager.get(
      url: url,
      headers: {
        HttpHeaders.authorizationHeader: 'bearer $token',
      },
    );
    if (response != null && response.statusCode == 201) {
      return DashboardModel.fromJson(response.data);
    } else {
      throw ServerException();
    }
  }

  String _getAuthUrl(String username) {
    String path =
        "${GlobalConfiguration().getValue(GlobalVars.API_AUTH_URL)}${GlobalConfiguration().getValue(GlobalVars.API_AUTH_PATH)}/$username";
    path +=
        "?application=${GlobalConfiguration().getValue(GlobalVars.APP_NAME)}";

    if (Env().isInDebugMode) {
      path += '&env=' + GlobalConfiguration().getValue(GlobalVars.ENV);
      print('[_getAuthUrl] $path');
    }
    return path;
  }

  //
}
