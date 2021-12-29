import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kmp_petugas_app/features/financial/presentation/bloc/bloc.dart';
import 'package:kmp_petugas_app/features/financial/presentation/pages/financial_statement_screen.dart';
import 'package:kmp_petugas_app/main.dart';
import 'package:kmp_petugas_app/service_locator.dart';
import 'package:kmp_petugas_app/theme/colors.dart';

class FinancialStatementPage extends StatefulWidget {
  //!ubah disini
  static const routeName = '/cashbook';

  @override
  _FinancialStatementPageState createState() => _FinancialStatementPageState();
}

class _FinancialStatementPageState extends State<FinancialStatementPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: null,
      child: Scaffold(
          backgroundColor: ColorPalette.primary,
          appBar: AppBar(
            toolbarHeight: 80,
            elevation: 0,
            backgroundColor: Color(0xffF8F8F8),
            automaticallyImplyLeading: false,
            title: Padding(
              padding: const EdgeInsets.only(
                left: 5,
                right: 5,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      // Navigator.pop(context);
                      Navigator.of(context).pushAndRemoveUntil(
                        CupertinoPageRoute(
                          builder: (BuildContext context) {
                            return App();
                          },
                        ),
                        (_) => false,
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      height: 33,
                      width: 33,
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              spreadRadius: 1.5,
                              blurRadius: 15,
                              offset: Offset(0, 1),
                            ),
                          ],
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.white),
                      child: SvgPicture.asset(
                        "assets/icon/back.svg",
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: Column(
            children: [Text("data")],
          )),
    );
  }
}
