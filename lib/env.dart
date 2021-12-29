import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:kmp_petugas_app/config/global_vars.dart';

class Env {
  late Env value;
  String? envName;
  String? appId;
  String? appName;
  String? appTitle;
  String? appVersion;
  String? apiBaseUrl;
  String? apiAuthUrl;
  String? apiConfigUrl;
  String? apiConfigPath;
  String? apiAuthPath;
  String? apiLoginPath;
  String? configSource;
  String? configVersion;
  String? demoUsername;
  String? demoPassword;
  int? configTimestamp;
  int? configHttpTimeout;
  int? configHttpUploadTimeout;
  int? configImageCompressQuality;
  String? errMessageNoRouteMatched;

  bool get isInDebugMode {
    bool inDebugMode = false;
    assert(inDebugMode = true);
    return inDebugMode;
  }

  Env() {
    var mapConfig = dotenv.env;
    loadConfig(mapConfig);
    value = this;
  }

  loadConfig(Map<String, dynamic> config) async {
    this.envName = config[GlobalVars.ENV] ??
        GlobalConfiguration().getValue(GlobalVars.ENV);
    this.appId = config[GlobalVars.APP_ID] ??
        GlobalConfiguration().getValue(GlobalVars.APP_ID);
    this.appName = config[GlobalVars.APP_NAME] ??
        GlobalConfiguration().getValue(GlobalVars.APP_NAME);
    this.apiConfigUrl = config[GlobalVars.API_CONFIG_URL] ??
        GlobalConfiguration().getValue(GlobalVars.API_CONFIG_URL);
    this.apiConfigPath = config[GlobalVars.API_CONFIG_PATH] ??
        GlobalConfiguration().getValue(GlobalVars.API_CONFIG_PATH);

    // demo user
    this.demoUsername = config[GlobalVars.DEMO_USERNAME] ??
        GlobalConfiguration().getValue(GlobalVars.DEMO_USERNAME);
    this.demoPassword = config[GlobalVars.DEMO_PASSWORD] ??
        GlobalConfiguration().getValue(GlobalVars.DEMO_PASSWORD);

    this.appTitle = GlobalConfiguration().getValue(GlobalVars.APP_TITLE);
    this.appVersion = GlobalConfiguration().getValue(GlobalVars.APP_VERSION);
    this.apiBaseUrl = GlobalConfiguration().getValue(GlobalVars.API_BASE_URL);
    this.apiAuthUrl = GlobalConfiguration().getValue(GlobalVars.API_AUTH_URL);
    this.apiAuthPath = GlobalConfiguration().getValue(GlobalVars.API_AUTH_PATH);
    this.apiLoginPath =
        GlobalConfiguration().getValue(GlobalVars.API_LOGIN_PATH);
    this.configVersion =
        GlobalConfiguration().getValue(GlobalVars.CONFIG_VERSION);
    this.configTimestamp =
        GlobalConfiguration().getValue(GlobalVars.CONFIG_TIMESTAMP);

    this.configHttpTimeout =
        GlobalConfiguration().getValue(GlobalVars.CONFIG_HTTP_TIMEOUT);
    this.configHttpUploadTimeout = GlobalConfiguration()
        .getValue(GlobalVars.CONFIG_HTTP_UPLOAD_IMAGE_TIMEOUT);
    this.configImageCompressQuality = GlobalConfiguration()
        .getValue(GlobalVars.CONFIG_IMAGE_COMPRESS_QUALITY);

    this.errMessageNoRouteMatched =
        GlobalConfiguration().getValue(GlobalVars.ERR_MESSAGE_NO_ROUTE_MATCHED);
  }
}
