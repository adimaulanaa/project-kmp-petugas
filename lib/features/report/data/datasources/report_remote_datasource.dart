import 'dart:io';
import 'package:ext_storage/ext_storage.dart';
import 'package:kmp_petugas_app/features/authentication/data/models/user_model.dart';
import 'package:kmp_petugas_app/features/report/data/models/data.dart';
import 'package:kmp_petugas_app/features/report/data/models/report_model.dart';
import 'package:kmp_petugas_app/framework/core/exceptions/app_exceptions.dart';
import 'package:kmp_petugas_app/framework/managers/hive_db_helper.dart';
import 'package:kmp_petugas_app/framework/managers/http_manager.dart';

abstract class ReportRemoteDataSource {
  Future<ReportModel> getCashBook(ReportData dataCashBook);
  Future<String> getPdf(ReportData getPdf);
  Future<UserModel> getSession();
}

class ReportRemoteDataSourceImpl implements ReportRemoteDataSource {
  ReportRemoteDataSourceImpl({
    required this.httpManager,
    required this.dbServices,
  });

  final HttpManager httpManager;
  final HiveDbServices dbServices;

  @override
  Future<ReportModel> getCashBook(ReportData data) => _getCashBookFromUrl(
      '/transactions/report?is_pdf=' +
          data.ispaid.toString() +
          '&month=' +
          data.monthstart.toString() +
          '&year=' +
          data.yearstart.toString() +
          '&type=' +
          data.type.toString(),
      data);

  Future<ReportModel> _getCashBookFromUrl(String url, ReportData data) async {
    var token = await dbServices.getData(HiveDbServices.boxToken);

    final response = await httpManager.get(url: url, headers: {
      HttpHeaders.authorizationHeader: 'bearer $token',
    });

    if (response != null && response.statusCode == 201) {
      return ReportModel.fromJson(response.data);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<String> getPdf(ReportData getPdf) => _getPdfFromurl(
      '/transactions/report?is_pdf=' +
          getPdf.ispaid.toString() +
          '&month=' +
          getPdf.monthstart.toString() +
          '&year=' +
          getPdf.yearstart.toString() +
          '&type=' +
          getPdf.type.toString(),
      getPdf);

  Future<String> _getPdfFromurl(String url, ReportData data) async {
    var token = await dbServices.getData(HiveDbServices.boxToken);
    var path = await ExtStorage.getExternalStoragePublicDirectory(
        ExtStorage.DIRECTORY_DOWNLOADS);
    String savePath = path! +
        "/LaporanKeuangan_${data.monthstart}" +
        "_" +
        "${data.yearstart}" +
        ".pdf";

    final response =
        await httpManager.download(url: url, path: savePath, headers: {
      HttpHeaders.authorizationHeader: 'bearer $token',
    });

    if (response != null && response.statusCode == 200) {
      return savePath;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<UserModel> getSession() => _getUserSessionFromUrl('/users/session');

  Future<UserModel> _getUserSessionFromUrl(String url) async {
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
}
