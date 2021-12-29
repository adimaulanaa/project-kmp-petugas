import 'package:kmp_petugas_app/config/string_resources.dart';

class AppException implements Exception {
  AppException([
    this.message,
    this._prefix = '',
  ]);

  final message;
  final _prefix;

  String toString() {
    return "$_prefix$message";
  }
}

class NetworkException extends AppException {
  NetworkException() : super(StringResources.NETWORK_FAILURE_MESSAGE);
}

class FetchDataException extends AppException {
  FetchDataException([String? message])
      : super(message, "Terdapat kesalahan dalam proses: ");
}

class BadRequestException extends AppException {
  BadRequestException([message]) : super(message);
}

class UnauthorisedException extends AppException {
  UnauthorisedException([message]) : super(message);
}

class NotFoundException extends AppException {
  NotFoundException([message]) : super(message);
}

class MissingParamsException extends AppException {
  MissingParamsException()
      : super(
            "There is some missing params, check the widget for further information!");
}

class InvalidCredentialException extends AppException {
  InvalidCredentialException([message]) : super(message);
}

class ServerException extends AppException {
  ServerException([message]) : super(message);
}

class CacheException implements Exception {}
