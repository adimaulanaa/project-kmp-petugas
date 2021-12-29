// import 'dart:convert';
// import 'package:background_fetch/background_fetch.dart';
// import 'package:global_configuration/global_configuration.dart';
// import 'package:kmp_petugas_app/config/global_vars.dart';
// import 'package:kmp_petugas_app/env.dart';
// import 'package:kmp_petugas_app/offline_sync.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// const EVENTS_KEY = "task_events";

// class BackgroundTask {
//   static final BackgroundTask instance = BackgroundTask._instantiate();

//   BackgroundTask() {
//     // initPlatformState();
//   }

//   List<String> _events = [];
//   String syncTaskId = Env().value.appId + ".offlinesync";

//   BackgroundTask._instantiate();

//   Future<void> init() async {
//     // Load persisted fetch events from SharedPreferences
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String json = prefs.getString(EVENTS_KEY);
//     if (json != null) {
//       _events = jsonDecode(json).cast<String>();
//     }

//     // Configure BackgroundFetch.
//     BackgroundFetch.configure(
//       BackgroundFetchConfig(
//         minimumFetchInterval: 1,
//         forceAlarmManager: false,
//         stopOnTerminate: true,
//         startOnBoot: false,
//         enableHeadless: false,
//         requiresBatteryNotLow: false,
//         requiresCharging: false,
//         requiresStorageNotLow: false,
//         requiresDeviceIdle: false,
//         requiredNetworkType: NetworkType.ANY,
//       ),
//       _onBackgroundFetch,
//     ).then((int status) {
//       if (Env().value.isInDebugMode) {
//         print('[BackgroundFetch] configure success: $status');
//       }
//     }).catchError((e) {
//       if (Env().value.isInDebugMode) {
//         print('[BackgroundFetch] configure ERROR: $e');
//       }
//     });

//     BackgroundFetch.scheduleTask(TaskConfig(
//       taskId: syncTaskId,
//       delay: GlobalConfiguration().getValue(GlobalVars.SCHEDULE_TASK_DELAY) ??
//           10000,
//       periodic: true,
//       forceAlarmManager: true,
//       stopOnTerminate: true,
//       enableHeadless: false,
//     ));
//   }

//   void stop() {
//     BackgroundFetch.stop();
//   }

//   void _onBackgroundFetch(String taskId) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     DateTime timestamp = new DateTime.now();
//     // This is the fetch-event callback.
//     if (Env().value.isInDebugMode) {
//       print("[BackgroundFetch] Event received: $taskId");
//     }

//     _events.insert(0, "$taskId@${timestamp.toString()}");

//     // Persist fetch events in SharedPreferences
//     prefs.setString(EVENTS_KEY, jsonEncode(_events));

//     if (taskId == syncTaskId) {
//       if (Env().value.isInDebugMode) {
//         var now = new DateTime.now();
//         print('[Scheduler] syncOffline $now');
//       }

//       OfflineSync();
//     }

//     // IMPORTANT:  You must signal completion of your fetch task or the OS can punish your app
//     // for taking too long in the background.
//     BackgroundFetch.finish(taskId);
//   }
//   //
// }
