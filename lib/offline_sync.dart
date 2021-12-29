// import 'dart:convert';
// import 'dart:io';
// import 'package:internet_connection_checker/internet_connection_checker.dart';
// import 'package:dio/dio.dart' as dio;
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:kmp_petugas_app/env.dart';
// import 'package:kmp_petugas_app/features/dashboard/data/models/sync_offline_result_model.dart';
// import 'package:kmp_petugas_app/features/dashboard/data/models/sync_offline_value_model.dart';
// import 'package:kmp_petugas_app/features/dashboard/domain/entities/sync_offline_result.dart';
// import 'package:kmp_petugas_app/features/dashboard/domain/entities/sync_offline_value.dart';
// import 'package:kmp_petugas_app/framework/managers/hive_db_helper.dart';
// import 'features/authentication/data/models/user_model.dart';
// import 'framework/core/exceptions/app_exceptions.dart';
// import 'framework/managers/secure_storage_manager.dart';

// class OfflineSync {
//   OfflineSync() {
//     runTask();
//   }

//   final _storage = FlutterSecureStorage();
//   final dbServices = HiveDbServices();
//   final dio.Dio _dio = new dio.Dio();
//   final DataConnectionChecker connectionChecker = new DataConnectionChecker();

//   Future<void> runTask() async {
//     String offlineData =
//         await _storage.read(key: SecureStorageManager.keySyncOfflineValue);
//     if (offlineData != null) {
//       List<SyncOfflineValue> _offlineData =
//           syncOfflineValuesModelFromJson(offlineData);
//       try {
//         await postSyncOfflineNotes(_offlineData);
//       } catch (e) {
//         if (Env().value.isInDebugMode) {
//           print('Error running background task: ${e.toString()}');
//         }
//       }
//     }
//   }

//   Future<SyncOfflineResult> postSyncOfflineNotes(
//           List<SyncOfflineValue> dataOfflineNotes) =>
//       _postSyncOfflineNotesFromUrl('/witnesses/offline_data', dataOfflineNotes);

//   Future<SyncOfflineResult> _postSyncOfflineNotesFromUrl(
//       String url, List<SyncOfflineValue> dataOfflineNotes) async {
//     // String user =
//     //     await _storage.read(key: SecureStorageManager.keyLoggedInUser);
//     // UserModel _user = userModelFromJson(user);
//     final _user = await dbServices.getUser();

//
//     // await _storage.read(key: SecureStorageManager.keyAccessToken);

//     SyncOfflineValue _userOfflineValue =
//         dataOfflineNotes.singleWhere((element) => element.userId == _user.id);
//     var data = [];
//     if (_userOfflineValue != null) {
//       if (_userOfflineValue.data.length > 0) {
//         var syncList = _userOfflineValue.data
//             .where((element) => element.isSync == false)
//             .toList();
//         if (syncList != null && syncList.length > 0) {
//           _userOfflineValue.data.forEach((element) {
//             var mData = {
//               'type': element.type,
//               'name': element.name,
//               'is_sync': element.isSync,
//               'sync_time': element.syncTime.toString(),
//               'timestamp': element.timestamp
//             };

//             if (element.type == 'presence' ||
//                 element.type == 'open_tps' ||
//                 element.type == 'close_tps' ||
//                 element.type == 'start_counting' ||
//                 element.type == 'stop_counting') {
//               mData['value'] = {
//                 'location_lat': element.value['location_lat'],
//                 'location_lng': element.value['location_lng']
//               };
//             } else if (element.type == 'delivered_c1_document') {
//               //
//             } else if (element.type == 'complete') {
//               mData['value'] = {
//                 'complete': element.value['complete'],
//               };
//             } else if (element.type == 'qrc_sent') {
//               var values = [];
//               if (element.values.length >= 4) {
//                 element.values.forEach((el) {
//                   values.add({el.id: int.parse(el.voteString)});
//                 });
//               }
//               mData['values'] = values;
//             }
//             data.add(mData);
//           });
//         }
//       } else {
//         SyncOfflineResultModel data =
//             SyncOfflineResultModel(data: [], result: false, timestamp: 0);
//         return data;
//       }
//     }

//     if (await connectionChecker.hasConnection) {
//       try {
//         const timeout = Duration(seconds: 3);

//         var body = {
//           'data': data,
//         };
//         var headers = {
//
//         };

//         if (Env().isInDebugMode) {
//           print('Api Post request url $url, with $body');
//         }

//         final response = await _dio
//             .post(_queryBuilder(url, null),
//                 data: body != null ? json.encode(body) : null,
//                 options: dio.Options(
//                   headers: _headerBuilder(headers),
//                 ))
//             .timeout(timeout, onTimeout: () {
//           throw NetworkException();
//         });
//         _returnResponse(response);
//         if (response != null && response.statusCode == 200) {
//           var result = SyncOfflineResultModel.fromJson(response.data);
//           var time =
//               DateTime.fromMillisecondsSinceEpoch(result.timestamp * 1000)
//                   .toLocal();
//           _userOfflineValue.syncTime = time;

//           List<OfflineValue> syncList = [];
//           if (result.data.length > 0) {
//             _userOfflineValue.data.forEach((element) {
//               if (element.isSync == false) {
//                 var value = result.data
//                     .singleWhere((timestamp) => timestamp == element.timestamp);
//                 if (value != null) {
//                   element.isSync = true;
//                   element.syncTime = time;
//                 }
//                 syncList.add(element);
//               }
//             });
//             _userOfflineValue.data
//                 .removeWhere((element) => element.isSync = true);
//           }

//           String offlineData = await _storage.read(
//               key: SecureStorageManager.keySyncOfflineValue);

//           if (offlineData != null) {
//             List<SyncOfflineValue> _offlineData =
//                 syncOfflineValuesModelFromJson(offlineData);

//             _offlineData.removeWhere((element) => element.userId == _user.id);
//             _offlineData.add(_userOfflineValue);

//             String syncOfflineValueText =
//                 syncOfflineValuesModelToJson(_offlineData);
//             await _storage.write(
//                 key: SecureStorageManager.keySyncOfflineValue,
//                 value: syncOfflineValueText);
//           }

//           return result;
//         } else {
//           throw ServerException();
//         }
//       } catch (error) {
//         print(error.message);
//         throw ServerException();
//       }
//     } else {
//       throw NetworkException();
//     }
//   }

//   Map<String, String> _headerBuilder(Map<String, String> headers) {
//     if (headers == null) {
//       headers = {};
//     }

//     headers[HttpHeaders.acceptHeader] = 'application/json';
//     if (headers[HttpHeaders.contentTypeHeader] == null) {
//       headers[HttpHeaders.contentTypeHeader] = 'application/json';
//     }

//     if (headers != null && headers.isNotEmpty) {
//       headers.forEach((key, value) {
//         headers[key] = value;
//       });
//     }

//     return headers;
//   }

//   String _queryBuilder(String path, Map<String, dynamic> query) {
//     final buffer = StringBuffer();
//     buffer.write(Env().apiBaseUrl + path);
//     if (query != null) {
//       if (query.isNotEmpty) {
//         buffer.write('?');
//       }
//       query.forEach((key, value) {
//         buffer.write('$key=$value&');
//       });
//     }
//     return buffer.toString();
//   }

//   String removeAllHtmlTags(String htmlText) {
//     RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);

//     return htmlText.replaceAll(exp, '');
//   }

//   dynamic _returnResponse(dio.Response response) {
//     var data = response;

//     final responseJson = data;
//     if (response.statusCode >= 200 && response.statusCode <= 299) {
//       if (Env().isInDebugMode) {
//         print('Api response success with $responseJson');
//       }
//     } else {
//       if (Env().isInDebugMode) {
//         print('Api response failed with $response');
//         print('Api response failed with ${response.data['message']}');
//       }
//     }
//   }
// }
