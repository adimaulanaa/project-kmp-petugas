import 'dart:convert';
import 'package:kmp_petugas_app/env.dart';
import 'package:kmp_petugas_app/features/authentication/domain/usecases/index.dart';
import 'package:kmp_petugas_app/features/login/presentation/bloc/bloc.dart';
import 'package:kmp_petugas_app/framework/managers/helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kmp_petugas_app/framework/managers/hive_db_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:package_info_plus/package_info_plus.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final SigninUseCase _signIn;
  final SharedPreferences _prefs;
  final HiveDbServices _dbServices;

  LoginBloc({
    required SigninUseCase signIn,
    required SharedPreferences prefs,
    required HiveDbServices dbServices,
  })  : _signIn = signIn,
        _prefs = prefs,
        _dbServices = dbServices,
        super(LoginInitial());

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoadLogin) {
      String username = '';
      String password = '';
      if (Env().isInDebugMode) {
        username = Env().demoUsername!;
        password = Env().demoPassword!;

        if (_prefs.containsKey('last_username')) {
          username = _prefs.getString('last_username')!.trim();
          password = password;
        }
      } else {
        if (_prefs.containsKey('last_username')) {
          username = _prefs.getString('last_username')!.trim();
        }
      }

      yield LoginLoaded(username: username, password: password);
    }
    if (event is LoginWithCredentialsPressed) {
      yield LoginSubmitting();
      var asd = await _dbServices.getData(HiveDbServices.boxDeviceInfo);
      var device = jsonDecode(asd);
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String appVersion = packageInfo.version + '+' + packageInfo.buildNumber;
      final failureOrSuccess = await _signIn(SignInParams(
          username: event.username,
          password: event.password,
          applicationVersion: appVersion,
          deviceId: device['androidId'] ?? "",
          deviceBrand: device['brand'] ?? "",
          deviceManufacture: device['manufacturer'] ?? "",
          deviceModel: device['model'] ?? "",
          deviceOS: device['Android'] ?? "",
          deviceOSVersion: (device["version.release"] == null
              ? ""
              : "${device["version.release"]} (API ${device["version.sdkInt"]})")));
      yield failureOrSuccess.fold(
          (failure) => LoginFailure(error: mapFailureToMessage(failure)),
          (loggedInUser) => LoginSuccess(success: loggedInUser));
    }
  }
}
