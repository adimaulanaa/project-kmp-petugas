import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:kmp_petugas_app/features/financial/presentation/bloc/bloc.dart';
import 'package:kmp_petugas_app/features/financial/presentation/pages/financial_statement_screen.dart';
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
        body: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => serviceLocator.get<FinancialStatementBloc>(),
            ),
          ],
          child: ProgressHUD(child: FinancialStatementScreen()),
        ),
      ),
    );
  }
}
