import 'dart:convert';
import 'dart:io';

import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:kmp_petugas_app/config/global_vars.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
  String get dnsResolveAddresses;
  Stream<InternetConnectionStatus> get onInternetStatusChange;

  void addGlobalDns(List<AddressCheckOptions> addresses);
}

class NetworkInfoImpl implements NetworkInfo {
  NetworkInfoImpl(this.connectionChecker) {
    final List<AddressCheckOptions> globalAddresses =
        _getDefaultHostAddresses();

    if (globalAddresses != null && globalAddresses.length > 0) {
      // overrides default addresses
      this.connectionChecker.addresses = globalAddresses;
    }

    this.connectionChecker.checkInterval = _getDefaultCheckInterval();
  }

  final InternetConnectionChecker connectionChecker;

  @override
  String get dnsResolveAddresses => connectionChecker.addresses.toString();

  @override
  Future<bool> get isConnected => connectionChecker.hasConnection;

  @override
  void addGlobalDns(List<AddressCheckOptions> addresses) {
    if (addresses != null && addresses.length > 0) {
      addresses.forEach((element) {
        //
        if (!this.connectionChecker.addresses.contains(element)) {
          this.connectionChecker.addresses.insert(0, element);
        }
      });
    }
  }

  @override
  Stream<InternetConnectionStatus> get onInternetStatusChange =>
      connectionChecker.onStatusChange;

  List<AddressCheckOptions> _getDefaultHostAddresses() {
    // LOAD CONNECTION CHECKER PRIMARY DNS
    final appConfig = GlobalConfiguration().appConfig;
    List<AddressCheckOptions> addresses = [];

    if (appConfig.containsKey(GlobalVars.CONFIG_CONNECTION_CHECKER_ENABLED)) {
      final String jsonHosts =
          appConfig[GlobalVars.CONFIG_CONNECTION_CHECKER_IP_ADDRESSES];

      if (jsonHosts != null && jsonHosts.isNotEmpty) {
        List hosts = jsonDecode(jsonHosts);

        if (hosts.length > 0) {
          addresses = hosts
              .map(
                (json) => new AddressCheckOptions(
                  InternetAddress(json["host"]),
                  port: json["port"],
                  timeout: new Duration(seconds: json["timeout_secs"]),
                ),
              )
              .toList();
        }
      }
    } else {
      addresses.add(
        AddressCheckOptions(
          InternetAddress('103.77.78.212'), // Default Nitoza Application Server
          port: 80,
          timeout: const Duration(seconds: 10),
        ),
      );
    }

    return addresses;
  }

  Duration _getDefaultCheckInterval() {
    // LOAD CONNECTION CHECKER PRIMARY DNS
    final appConfig = GlobalConfiguration().appConfig;

    if (appConfig.containsKey(GlobalVars.CONFIG_CONNECTION_CHECKER_ENABLED)) {
      final interval = GlobalConfiguration()
          .getValue(GlobalVars.CONFIG_CONNECTION_CHECKER_INTERVAL_IN_SEC);
      return Duration(seconds: interval);
    } else {
      return connectionChecker.checkInterval;
    }
  }
  //
}
