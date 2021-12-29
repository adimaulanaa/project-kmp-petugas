import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:kmp_petugas_app/config/global_vars.dart';
import 'package:kmp_petugas_app/config/string_resources.dart';
import 'package:kmp_petugas_app/env.dart';
import 'package:kmp_petugas_app/features/home/presentation/pages/home_page.dart';
import 'package:kmp_petugas_app/features/login/presentation/pages/login_page.dart';
import 'package:kmp_petugas_app/features/walkthrough/presentation/pages/walkthrough_page.dart';
import 'package:kmp_petugas_app/framework/core/network/network_info.dart';
import 'package:kmp_petugas_app/framework/managers/hive_db_helper.dart';
import 'package:kmp_petugas_app/framework/widgets/loading_indicator.dart';
import 'package:kmp_petugas_app/service_locator.dart';
import 'package:kmp_petugas_app/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'features/authentication/presentation/bloc/bloc.dart';
import 'framework/blocs/messaging/index.dart';

class SimpleBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    if (Env().isInDebugMode) {
      print(event);
    }
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    if (Env().isInDebugMode) {
      print(transition);
    }
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    if (Env().isInDebugMode) {
      print(error);
    }
    super.onError(bloc, error, stackTrace);
  }
}

void main() async {
  await Hive.initFlutter();
  Hive.openBox(HiveDbServices.boxLoggedInUser);

  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  await Firebase.initializeApp();

  // check apakah aplikasi baru di install/reinstall
  final prefs = await SharedPreferences.getInstance();
  GlobalConfiguration().loadFromAsset("app_settings");
  await dotenv.load(fileName: ".env");

  //  load static environment wrapper
  Env();
  if (prefs.getBool('first_run') ?? true) {
    await Hive.deleteFromDisk();
    debugPrint("=====Aplikasi baru di install hapus local storage=====");
    prefs.setBool('first_run', false);
  }

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await initDependencyInjection();

  Bloc.observer = SimpleBlocObserver();

  if (Env().value.isInDebugMode) {
    print('app: ${Env().value.appName}');
    print('API Base Url: ${Env().value.apiBaseUrl}');
    print("API Config Url: ${Env().apiConfigUrl}${Env().apiConfigPath}");
  }

  initDataConnectionChecker(isDefault: true);

  try {
    await DotEnv().load(fileName: '.env');

    // load static environment wrapper
    Env();

    if (Env().apiConfigUrl != '') {
      String path = "${Env().apiConfigUrl}${Env().apiConfigPath}";
      path += "?application=${Env().appName}";
      if (Env().isInDebugMode) {
        path += '&env=' + Env().envName!;
        debugPrint('[CONFIG] Loading global configuration from ' + path);
      }

      final result = await GlobalConfiguration().loadFromUrl(path);
      await loadFromGlobalConfig(result);
    }
  } catch (e, trace) {
    if (Env().isInDebugMode) {
      debugPrint('[CONFIG] $e & $trace');
    }
  }
  runZonedGuarded<Future<void>>(() async {
    if (Env().value.isInDebugMode) {
    } else {
      FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    }

    runApp(
      MultiBlocProvider(
        providers: [
          BlocProvider<AuthenticationBloc>(
            create: (BuildContext context) =>
                serviceLocator.get<AuthenticationBloc>()..add(AppStarted()),
          ),
          BlocProvider<MessagingBloc>(
            create: (BuildContext context) =>
                serviceLocator.get<MessagingBloc>()..add(MessagingStarted()),
          ),
        ],
        child: App(),
      ),
    );
  }, (error, stack) => FirebaseCrashlytics.instance.recordError(error, stack));
}

Future<void> loadFromGlobalConfig(GlobalConfiguration result) async {
  if (result != null) {
    // add addition DNS Checking from remote config
    initDataConnectionChecker();
  }

  return;
}

void initDataConnectionChecker({bool isDefault = false}) {
  final appConfig = GlobalConfiguration().appConfig;

  // LOAD CONNECTION CHECKER PRIMARY DNS
  if (appConfig.containsKey(GlobalVars.CONFIG_CONNECTION_CHECKER_ENABLED)) {
    final bool isCheckerEnabled =
        appConfig[GlobalVars.CONFIG_CONNECTION_CHECKER_ENABLED];

    if (isCheckerEnabled) {
      final String jsonHosts =
          appConfig[GlobalVars.CONFIG_CONNECTION_CHECKER_IP_ADDRESSES];

      if (jsonHosts != null && jsonHosts.isNotEmpty) {
        List hosts = jsonDecode(jsonHosts);

        if (hosts.length > 0) {
          List<AddressCheckOptions> addresses = hosts
              .map(
                (json) => new AddressCheckOptions(
                  InternetAddress(json["host"]),
                  port: json["port"],
                  timeout: new Duration(seconds: json["timeout_secs"]),
                ),
              )
              .toList();

          if (isDefault) {
            // initialized
            serviceLocator<NetworkInfo>();
          } else {
            serviceLocator<NetworkInfo>().addGlobalDns(addresses);
          }
        }
      }
    }
  }
}

class App extends StatefulWidget {
  App({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return AppState();
  }
}

class AppState extends State<App> {
  StreamSubscription<InternetConnectionStatus> _connection =
      InternetConnectionChecker().onStatusChange.listen((event) {});

  @override
  void initState() {
    super.initState();
    bool isConnected = false;
    _connection =
        serviceLocator<NetworkInfo>().onInternetStatusChange.listen((status) {
      switch (status) {
        case InternetConnectionStatus.connected:
          isConnected = true;
          break;
        case InternetConnectionStatus.disconnected:
          isConnected = false;
          break;
      }

      BlocProvider.of<MessagingBloc>(context)
          .add(InternetConnectionChanged(connected: isConnected));
    });
  }

  @override
  void dispose() {
    _connection.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: StringResources.APLICATION_TITLE,
      theme: appTheme,
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (Env().value.isInDebugMode) {
            print('state $state');
          }
          if (state is ViewWalkthrough) {
            return WalkthroughPage();
          } else if (state is ViewLogin) {
            return LoginPage();
          } else if (state is AuthenticationAuthenticated) {
            return HomePage();
          } else if (state is AuthenticationUnauthenticated) {
            return LoginPage();
          } else if (state is AuthenticationLoading) {
            return LoadingIndicator();
          }
          return LoadingIndicator();
        },
      ),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
