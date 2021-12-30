import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:kmp_petugas_app/env.dart';
import 'package:kmp_petugas_app/framework/core/exceptions/app_exceptions.dart';
import 'package:kmp_petugas_app/framework/managers/helper.dart';

abstract class HttpManager {
  Future<dynamic> get({
    required String url,
    Map<String, dynamic> query,
    required Map<String, String> headers,
  });

  Future<dynamic> download({
    required String url,
    String path,
    Map body,
    required Map<String, String> headers,
  });
  Future<dynamic> downloadreport({
    required String url,
    String path,
    required Map<String, String> headers,
  });


  Future<dynamic> post({
    String url,
    Map body,
    Map<String, dynamic> query,
    Map<String, dynamic> headers,
    FormData formData,
    bool isUploadImage = false,
  });

  Future<dynamic> put({
    String url,
    Map body,
    Map<String, dynamic> query,
    Map<String, String> headers,
    FormData formData,
    bool isUploadImage = false,
  });

  Future<dynamic> delete({
    String url,
    Map<String, dynamic> query,
    Map<String, String> headers,
  });
}

class CustomInterceptors extends Interceptor {
  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    printError(
        "<-- ${err.message} ${(err.response?.requestOptions != null ? (err.response!.requestOptions.path) : 'URL')}");
    printError(
        "${err.response != null ? err.response!.data : 'Unknown Error'}");
    printError("<-- End error");
    return super.onError(err, handler);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    printWarning("--> ${options.method.toUpperCase()} ${"" + (options.path)}");

    // printWarning("Headers:");
    // options.headers.forEach((k, v) => printWarning('$k: $v'));

    // printWarning("queryParameters:");
    // options.queryParameters.forEach((k, v) => printWarning('$k: $v'));

    if (options.data != null) {
      printWarning("Body: ${options.data}");
    }
    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    printWarning("<-- ${response.statusCode} ${response.requestOptions.path}");
    // printWarning("Headers:");
    // response.headers.forEach((k, v) => printWarning('$k: $v'));
    printWarning("Response: ${response.data}");
    printWarning("<-- END HTTP");
    return super.onResponse(response, handler);
  }
}

class AppHttpManager implements HttpManager {
  static final AppHttpManager instance = AppHttpManager._instantiate();
  final String _baseUrl = Env().apiBaseUrl!;
  final Dio _dio = new Dio();

  Duration _httpTimeout = Duration(seconds: 20);
  Duration _httpUploadTimeout = Duration(seconds: 35);

  AppHttpManager() {
    _httpTimeout = Duration(seconds: Env().configHttpTimeout!);
    _httpUploadTimeout = Duration(seconds: Env().configHttpUploadTimeout!);
    _dio.options.baseUrl = _baseUrl;
    _dio.interceptors.add(
      DioCacheManager(
        CacheConfig(baseUrl: _baseUrl),
      ).interceptor,
    );
    _dio.interceptors.add(CustomInterceptors());
    (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
  }

  AppHttpManager._instantiate();

  @override
  Future<dynamic> delete({
    String? url,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await _dio
          .delete(_queryBuilder(url, query),
              options: Options(
                headers: _headerBuilder(headers),
              ))
          .timeout(_httpTimeout, onTimeout: () {
        throw NetworkException();
      });
      return _returnResponse(response);
    } catch (error) {
      return handleError(error);
    }
  }

  @override
  Future get({
    String? url,
    Map<String, dynamic>? query,
    required Map<String, String> headers,
  }) async {
    try {
      final response = await _dio
          .get(_queryBuilder(url, query),
              options: buildCacheOptions(
                Duration(days: 1),
                forceRefresh: true,
                options: Options(
                  headers: _headerBuilder(headers),
                ),
              ))
          .timeout(_httpTimeout, onTimeout: () {
        throw NetworkException();
      });
      return _returnResponse(response);
    } catch (error) {
      return handleError(error);
    }
  }

  @override
  Future download({
    String? url,
    String? path,
    Map? body,
    required Map<String, String> headers,
  }) async {
    try {
      final response = await _dio
          .download(
        _queryBuilder(url, {}),
        path,
        data: body != null
                      ? json.encode(body)
                      : null,
        options: Options(
          method: 'POST',
          headers: _headerBuilder(headers),
        ),
      )
          .timeout(_httpUploadTimeout, onTimeout: () {
        throw NetworkException();
      });

      return _returnResponse(response);
    } catch (error) {
      return handleError(error);
    }
  }

  @override
  Future downloadreport({
    String? url,
    String? path,
    required Map<String, String> headers,
  }) async {
    try {
      final response = await _dio
          .download(
        _queryBuilder(url, {}),
        path,
        options: Options(
          headers: _headerBuilder(headers),
        ),
      )
          .timeout(_httpUploadTimeout, onTimeout: () {
        throw NetworkException();
      }).whenComplete(
              () => printWarning('Download Done============================='));

      return _returnResponse(response);
    } catch (error) {
      return handleError(error);
    }
  }


  @override
  Future<dynamic> post({
    String? url,
    Map? body,
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
    FormData? formData,
    bool isUploadImage = false,
  }) async {
    try {
      final response = await _dio
          .post(_queryBuilder(url, query),
              data: formData != null
                  ? formData
                  : body != null
                      ? json.encode(body)
                      : null,
              options: Options(
                headers: _headerBuilder(headers),
              ))
          .timeout((isUploadImage) ? _httpUploadTimeout : _httpTimeout,
              onTimeout: () {
        throw NetworkException();
      });

      return _returnResponse(response);
    } catch (error) {
      return handleError(error);
    }
  }

  @override
  Future<dynamic> put({
    String? url,
    Map? body,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
    FormData? formData,
    bool isUploadImage = false,
  }) async {
    try {
      final response = await _dio
          .put(_queryBuilder(url, query),
              data: formData != null
                  ? formData
                  : body != null
                      ? json.encode(body)
                      : null,
              options: Options(
                headers: _headerBuilder(headers),
              ))
          .timeout(_httpTimeout, onTimeout: () {
        throw NetworkException();
      });
      return _returnResponse(response);
    } catch (error) {
      return handleError(error);
    }
  }

  // private methods
  Map<String, dynamic> _headerBuilder(Map<String, dynamic>? headers) {
    if (headers == null) {
      headers = {};
    }

    headers[HttpHeaders.acceptHeader] = 'application/json';
    if (headers[HttpHeaders.contentTypeHeader] == null) {
      headers[HttpHeaders.contentTypeHeader] = 'application/json';
    }

    if (headers != null && headers.isNotEmpty) {
      headers.forEach((key, value) {
        headers?[key] = value;
      });
    }

    return headers;
  }

  String _queryBuilder(String? path, Map<String, dynamic>? query) {
    final buffer = StringBuffer();
    buffer.write(Env().apiBaseUrl! + path.toString());
    print(buffer);
    if (query != null) {
      if (query.isNotEmpty) {
        buffer.write('?');
      }
      query.forEach((key, value) {
        buffer.write('$key=$value&');
      });
    }
    if (Env().isInDebugMode) {
      // print(buffer);
    }
    return buffer.toString();
  }

  String removeAllHtmlTags(String htmlText) {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);

    return htmlText.replaceAll(exp, '');
  }

  dynamic _returnResponse(Response response) {
    var data = response;
    final responseJson = data;
    if (response.statusCode! >= 200 && response.statusCode! <= 299) {
      return responseJson;
    } else {
      handleError(response);
    }
  }

  Future<dynamic> handleError(dynamic error) async {
    if (error is DioError) {
      var response = error.response;

      var message = '';
      try {
        message = response!.data['message'];
      } catch (e) {
        message = '';
      }

      if (message.isNotEmpty) {
        if (message.toUpperCase() == 'INVALID CREDENTIALS' ||
            message.toUpperCase() == 'MISSING AUTHENTICATION' ||
            message.toUpperCase() == 'FORBIDDEN') {
          if (Env().isInDebugMode) {
            printWarning('Force Logout...');
          }

          throw InvalidCredentialException(
              "Sesi telah habis, harap login kembali");
        }
      } else if (response!.data.runtimeType == String) {
        message = removeAllHtmlTags(response.data);
        if (message.contains('502')) {
          // Bad Gateway
          message = '502 Bad Gateway';
        }
      }

      switch (response!.statusCode) {
        case 400:
          throw BadRequestException(
              message.isNotEmpty ? message : "Bad request");
        case 401:
        case 403:
          throw UnauthorisedException(
              message.isNotEmpty ? message : "Invalid token");
        case 404:
          throw NotFoundException(message.isNotEmpty ? message : "Not found");
        case 422:
          throw UnauthorisedException(
              message.isNotEmpty ? message : "Invalid credentials");
        case 500:
        default:
          throw FetchDataException(
              message.isNotEmpty ? message : "Unknown Error");
      }
    }
  }
}
