import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kmp_petugas_app/env.dart';
import 'package:kmp_petugas_app/features/authentication/domain/usecases/index.dart';
import 'package:kmp_petugas_app/framework/managers/hive_db_helper.dart';
import 'package:device_info_plus/device_info_plus.dart';
import './bloc.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:flutter/services.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:kmp_petugas_app/config/global_vars.dart';
import 'package:kmp_petugas_app/features/authentication/domain/usecases/get_all_to_cache_token_usecase.dart';
import 'package:kmp_petugas_app/framework/core/network/network_info.dart';
import 'package:kmp_petugas_app/framework/core/usecases/usecase.dart';
import 'package:kmp_petugas_app/service_locator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({
    required CheckSigninUseCase checkSignIn,
    required PersistTokenUseCase persistToken,
    required GetAllToCacheUseCase getAllToCache,
    required SignOutUseCase signOut,
    required HiveDbServices dbServices,
    required SharedPreferences prefs,
  })  : _checkSignIn = checkSignIn,
        _persistToken = persistToken,
        _getAllToCache = getAllToCache,
        _signOut = signOut,
        _dbServices = dbServices,
        super(AuthenticationUninitialized()) {
    //
  }

  final CheckSigninUseCase _checkSignIn;
  final GetAllToCacheUseCase _getAllToCache;
  final SignOutUseCase _signOut;
  final PersistTokenUseCase _persistToken;
  final HiveDbServices _dbServices;
  bool _seen = false;
  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AppStarted) {
      final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();
      Map<String, dynamic> _deviceData;

      Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
        return <String, dynamic>{
          'version.securityPatch': build.version.securityPatch,
          'version.sdkInt': build.version.sdkInt,
          'version.release': build.version.release,
          'version.previewSdkInt': build.version.previewSdkInt,
          'version.incremental': build.version.incremental,
          'version.codename': build.version.codename,
          'version.baseOS': build.version.baseOS,
          'board': build.board,
          'bootloader': build.bootloader,
          'brand': build.brand,
          'device': build.device,
          'display': build.display,
          'fingerprint': build.fingerprint,
          'hardware': build.hardware,
          'host': build.host,
          'id': build.id,
          'manufacturer': build.manufacturer,
          'model': build.model,
          'product': build.product,
          'supported32BitAbis': build.supported32BitAbis,
          'supported64BitAbis': build.supported64BitAbis,
          'supportedAbis': build.supportedAbis,
          'tags': build.tags,
          'type': build.type,
          'isPhysicalDevice': build.isPhysicalDevice,
          'androidId': build.androidId,
          'systemFeatures': build.systemFeatures,
        };
      }

      Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
        return <String, dynamic>{
          'name': data.name,
          'systemName': data.systemName,
          'systemVersion': data.systemVersion,
          'model': data.model,
          'localizedModel': data.localizedModel,
          'identifierForVendor': data.identifierForVendor,
          'isPhysicalDevice': data.isPhysicalDevice,
          'utsname.sysname:': data.utsname.sysname,
          'utsname.nodename:': data.utsname.nodename,
          'utsname.release:': data.utsname.release,
          'utsname.version:': data.utsname.version,
          'utsname.machine:': data.utsname.machine,
        };
      }

      var deviceData = <String, dynamic>{};

      try {
        if (Platform.isAndroid) {
          deviceData =
              _readAndroidBuildData(await _deviceInfoPlugin.androidInfo);
        } else if (Platform.isIOS) {
          deviceData = _readIosDeviceInfo(await _deviceInfoPlugin.iosInfo);
        }
      } on PlatformException {
        deviceData = <String, dynamic>{
          'Error:': 'Failed to get platform version.'
        };
      }

      _deviceData = deviceData;

      if (_deviceData != null) {
        final textResult = json.encode(_deviceData);
        await _dbServices.addData(HiveDbServices.boxDeviceInfo, textResult);
      }

      var _prefs = serviceLocator<SharedPreferences>();
      _seen = (_prefs.getBool('seen') ?? false);
      final newSessionOrExisting = await _checkSignIn(NoParams());

      yield newSessionOrExisting.fold(
        (newSession) =>
            (_seen) ? AuthenticationUnauthenticated() : ViewWalkthrough(),
        (existing) => (existing)
            ? AuthenticationAuthenticated()
            : (_seen)
                ? AuthenticationUnauthenticated()
                : ViewWalkthrough(),
      );
    }

    if (event is ShowLogin) {
      yield AuthenticationLoading();
      yield ViewLogin();
    }

    if (event is LoggedIn) {
      yield AuthenticationLoading();
      await _persistToken(TokenParams(userData: event.loggedInData));
      await _getAllToCache(NoParams());
      yield AuthenticationAuthenticated();
    }

    if (event is LoggedOut) {
      yield AuthenticationLoading();
      await _signOut(NoParams());
      yield AuthenticationUnauthenticated();
    }
  }
}
