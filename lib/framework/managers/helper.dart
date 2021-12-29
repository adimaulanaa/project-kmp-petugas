import 'package:another_flushbar/flushbar_helper.dart';
import 'package:kmp_petugas_app/features/authentication/presentation/bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kmp_petugas_app/config/global_vars.dart';
import 'package:kmp_petugas_app/config/string_resources.dart';
import 'package:kmp_petugas_app/env.dart';
import 'package:kmp_petugas_app/framework/core/exceptions/failures.dart';
import 'package:kmp_petugas_app/framework/managers/http_manager.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:global_configuration/global_configuration.dart';
import 'package:intl/intl.dart';

late HttpManager httpManager;

catchAllException(BuildContext context, String message,
    [bool showError = false]) {
  if (message == StringResources.INVALID_CREDENTIAL_FAILURE_MESSAGE ||
      message == StringResources.UNAUTHORISED_FAILURE_MESSAGE) {
    logout(context, message);
  } else {
    if (showError) {
      FlushbarHelper.createError(
          message: message, title: "Error", duration: Duration(seconds: 3))
        ..show(context);
    }
  }
}

logout(BuildContext context, [String message = '']) async {
  await clearLoginInfo();

  BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());

  if (message.isNotEmpty) {
    FlushbarHelper.createError(
        message: message, title: "Error", duration: Duration(seconds: 3))
      ..show(context);
  }
}

clearLoginInfo() async {
  var url = Uri.parse(Env().apiBaseUrl!);
}

String removeAllHtmlTags(String htmlText) {
  RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);

  return htmlText.replaceAll(exp, ' ');
}

RegExp kanban = RegExp(r'K\w+-L\w+');

String stringDate(DateTime date) {
  var exp = DateFormat('yyyy-MM-dd HH:mm:ss').format(date);

  return exp;
}

extension Context on BuildContext {
  void showCustomDialog(String text) {
    showDialog(
      context: this,
      builder: (BuildContext context) {
        return AlertDialog(title: Text(text));
      },
    );
  }

  void push(Widget screen, {bool withNavBar = false}) {
    Navigator.of(this, rootNavigator: !withNavBar).push(
      MaterialPageRoute(
        builder: (_) => screen,
      ),
    );
  }

  void pushReplacement(Widget screen, {bool withNavBar = false}) {
    Navigator.of(this, rootNavigator: !withNavBar).pushReplacement(
      MaterialPageRoute(
        builder: (_) => screen,
      ),
    );
  }

  void pop() {
    Navigator.of(this).pop();
  }

  void clearAllAndNavigateTO(Widget screen, {bool withNavBar = false}) {
    Navigator.of(this, rootNavigator: !withNavBar).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => screen),
      (_) => false,
    );
  }
}

String mapFailureToMessage(Failure failure) {
  switch (failure.runtimeType) {
    case BadRequestFailure:
      return failure.message.isNotEmpty
          ? failure.message
          : GlobalConfiguration()
                  .getValue(GlobalVars.ERR_MESSAGE_BAD_REQUEST_FAILURE) ??
              StringResources.BAD_REQUEST_FAILURE_MESSAGE;
    case UnauthorisedFailure:
      return failure.message.isNotEmpty
          ? failure.message
          : GlobalConfiguration()
                  .getValue(GlobalVars.ERR_MESSAGE_UNAUTHORISED_FAILURE) ??
              StringResources.UNAUTHORISED_FAILURE_MESSAGE;
    case NotFoundFailure:
      return failure.message.isNotEmpty
          ? failure.message
          : GlobalConfiguration()
                  .getValue(GlobalVars.ERR_MESSAGE_NOT_FOUND_FAILURE) ??
              StringResources.NOT_FOUND_MESSAGE;
    case FetchDataFailure:
      return failure.message.isNotEmpty
          ? failure.message
          : GlobalConfiguration()
                  .getValue(GlobalVars.ERR_MESSAGE_FETCH_DATA_FAILURE) ??
              StringResources.FETCH_DATA_FAILURE_MESSAGE;
    case InvalidCredentialFailure:
      return failure.message.isNotEmpty
          ? failure.message
          : GlobalConfiguration().getValue(
                  GlobalVars.ERR_MESSAGE_INVALID_CREDENTIAL_FAILURE) ??
              StringResources.INVALID_CREDENTIAL_FAILURE_MESSAGE;
    case ServerFailure:
      return failure.message.isNotEmpty
          ? failure.message
          : GlobalConfiguration()
                  .getValue(GlobalVars.ERR_MESSAGE_SERVER_FAILURE) ??
              StringResources.SERVER_FAILURE_MESSAGE;
    case AuthenticationFailure:
      return failure.message.isNotEmpty
          ? failure.message
          : GlobalConfiguration()
                  .getValue(GlobalVars.ERR_MESSAGE_AUTH_FAILURE) ??
              StringResources.AUTHENTICATION_FAILURE_MESSAGE;
    case NetworkFailure:
      return failure.message.isNotEmpty
          ? failure.message
          : GlobalConfiguration()
                  .getValue(GlobalVars.ERR_MESSAGE_NETWORK_FAILURE) ??
              StringResources.NETWORK_FAILURE_MESSAGE;
    default:
      return failure.message.isNotEmpty
          ? failure.message
          : GlobalConfiguration()
                  .getValue(GlobalVars.ERR_MESSAGE_APP_FAILURE) ??
              'Unexpected error';
  }
}

void printWarning(dynamic text) {
  if (Env().isInDebugMode) {
    print('\x1B[33m$text\x1B[0m');
  }
}

void printError(dynamic text) {
  if (Env().isInDebugMode) {
    print('\x1B[31m$text\x1B[0m');
  }
}
