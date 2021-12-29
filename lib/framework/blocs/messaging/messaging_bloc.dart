import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:kmp_petugas_app/framework/blocs/messaging/index.dart';
import 'package:kmp_petugas_app/framework/core/network/network_info.dart';
import 'package:kmp_petugas_app/service_locator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MessagingBloc extends Bloc<MessagingEvent, MessagingState> {
  MessagingBloc() : super(MessagingUninitialized()) {
    //
    _prefs = serviceLocator.get<SharedPreferences>();
  }

  late SharedPreferences _prefs;

  @override
  Stream<MessagingState> mapEventToState(
    MessagingEvent event,
  ) async* {
    if (event is MessagingStarted) {
      //
    } else if (event is MessageLoaded) {
      //
      bool connectionStatus = await serviceLocator<NetworkInfo>().isConnected;
      String lastMessage = '';

      if (_prefs.containsKey(LAST_MESSAGE_EVENTS_KEY)) {
        lastMessage = _prefs.getString(LAST_MESSAGE_EVENTS_KEY) ?? '';
      }

      yield MessagingInitialized(
        isInternetConnected: connectionStatus,
        lastMessage: lastMessage,
      );
    } else if (event is InternetConnectionChanged) {
      //
      _prefs.setBool(INTERNET_STATUS_EVENTS_KEY, event.connected);
      yield InternetConnectionState(event.connected);
    } else if (event is MessageBroadcasted) {
      //
      yield InMessagingState(message: event.message);
    }
  }

  bool getConnection() {
    bool isConnected = true;

    if (_prefs.containsKey(INTERNET_STATUS_EVENTS_KEY)) {
      isConnected = _prefs.getBool(INTERNET_STATUS_EVENTS_KEY) ?? false;
    }

    return isConnected;
  }
}
