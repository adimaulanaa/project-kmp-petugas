import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:kmp_petugas_app/config/global_vars.dart';
import 'package:kmp_petugas_app/config/string_resources.dart';
import 'package:kmp_petugas_app/theme/colors.dart';

class LoadingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: <Widget>[
            Center(
              child: Platform.isIOS
                  ? CupertinoActivityIndicator()
                  : CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(ColorPalette.primary),
                    ),
            ),
            Center(
              child: Container(
                margin: EdgeInsets.only(top: 80.0),
                child: Text(GlobalConfiguration()
                        .getValue(GlobalVars.TEXT_PLEASE_WAIT) ??
                    StringResources.PLEASE_WAIT),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
