import 'dart:io';
import 'package:ext_storage/ext_storage.dart';
import 'package:kmp_petugas_app/features/authentication/data/models/user_model.dart';
import 'package:kmp_petugas_app/features/financial/data/models/cash_book_model.dart';
import 'package:kmp_petugas_app/features/financial/data/models/data.dart';
import 'package:kmp_petugas_app/framework/core/exceptions/app_exceptions.dart';
import 'package:kmp_petugas_app/framework/managers/hive_db_helper.dart';
import 'package:kmp_petugas_app/framework/managers/http_manager.dart';

abstract class FinancialStatementRemoteDataSource {
  Future<CashBookModel> getCashBook(CashBookData dataCashBook);
  Future<String> getPdf(CashBookData getPdf);
  Future<UserModel> getSession();
}

class FinancialStatementRemoteDataSourceImpl
    implements FinancialStatementRemoteDataSource {
  FinancialStatementRemoteDataSourceImpl({
    required this.httpManager,
    required this.dbServices,
  });

  final HttpManager httpManager;
  final HiveDbServices dbServices;

  @override
  Future<CashBookModel> getCashBook(CashBookData data) => _getCashBookFromUrl(
      '/citizen_subscriptions/report?is_pdf=' +
          data.ispaid.toString() +
          '&month_start=' +
          data.monthstart.toString() +
          '&year_start=' +
          data.yearstart.toString() +
          '&month_end=' +
          data.monthend.toString() +
          '&year_end=' +
          data.yearend.toString() +
          '&type=' +
          data.type.toString(),
      data);

  Future<CashBookModel> _getCashBookFromUrl(
      String url, CashBookData data) async {
    var token = await dbServices.getData(HiveDbServices.boxToken);

    final response = await httpManager.get(url: url, headers: {
      HttpHeaders.authorizationHeader: 'bearer $token',
    });

    if (response != null && response.statusCode == 201) {
      return CashBookModel.fromJson(response.data);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<String> getPdf(CashBookData getPdf) => _getPdfFromurl(
      '/citizen_subscriptions/report?is_pdf=' +
          getPdf.ispaid.toString() +
          '&month_start=' +
          getPdf.monthstart.toString() +
          '&year_start=' +
          getPdf.yearstart.toString() +
          '&month_end=' +
          getPdf.monthstart.toString() +
          '&year_end=' +
          getPdf.yearstart.toString() +
          '&type=' +
          getPdf.type.toString(),
      getPdf);

  Future<String> _getPdfFromurl(String url, CashBookData data) async {
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
