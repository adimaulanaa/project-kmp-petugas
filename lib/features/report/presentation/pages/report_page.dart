import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:kmp_petugas_app/features/report/presentation/bloc/bloc.dart';
import 'package:kmp_petugas_app/features/report/presentation/pages/report_screen.dart';
import 'package:kmp_petugas_app/service_locator.dart';
import 'package:kmp_petugas_app/theme/colors.dart';

class ReportPage extends StatefulWidget {
  //!ubah disini
  static const routeName = '/cashbook';

  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
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
              create: (_) => serviceLocator.get<ReportBloc>(),
            ),
          ],
          child: ProgressHUD(child: ReportScreen()),
        ),
      ),
    );
  }
}
