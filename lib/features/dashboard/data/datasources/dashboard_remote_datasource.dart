import 'dart:io';
import 'package:kmp_petugas_app/features/authentication/data/models/user_model.dart';
import 'package:kmp_petugas_app/features/dashboard/data/models/dashboard_model.dart';
import 'package:kmp_petugas_app/features/guest_book/data/models/guest_book_today_model.dart';
import 'package:kmp_petugas_app/framework/core/exceptions/app_exceptions.dart';
import 'package:kmp_petugas_app/framework/managers/hive_db_helper.dart';
import 'package:kmp_petugas_app/framework/managers/http_manager.dart';

abstract class DashboardRemoteDataSource {
  Future<DashboardModel> getDashboard();
  Future<GuestBookTodayModel> getGuestBook();
  Future<UserModel> getUserProfiles();
}

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  DashboardRemoteDataSourceImpl({
    required this.httpManager,
    required this.dbServices,
  });

  final HttpManager httpManager;
  final HiveDbServices dbServices;

  @override
  Future<DashboardModel> getDashboard() =>
      _getDasboardFromUrl('/home?with_region=true');

  Future<DashboardModel> _getDasboardFromUrl(String url) async {
    var token = await dbServices.getData(HiveDbServices.boxToken);

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

  @override
  Future<UserModel> getUserProfiles() =>
      _getUserProfilesFromUrl('/users/session');

  Future<UserModel> _getUserProfilesFromUrl(String url) async {
    var token = await dbServices.getData(HiveDbServices.boxToken);

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
  Future<GuestBookTodayModel> getGuestBook() =>
      _getGuestBookFromUrl('/visitors/today');

  Future<GuestBookTodayModel> _getGuestBookFromUrl(String url) async {
    var token = await dbServices.getData(HiveDbServices.boxToken);

    final response = await httpManager.post(url: url, headers: {
      HttpHeaders.authorizationHeader: 'bearer $token',
    }, body: {
      "date": DateTime.now().toString()
    });

    if (response != null && response.statusCode == 201) {
      return GuestBookTodayModel.fromJson(response.data);
    } else {
      throw ServerException();
    }
  }
}
