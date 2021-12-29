import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:kmp_petugas_app/features/dues/presentation/bloc/bloc.dart';
import 'package:kmp_petugas_app/features/dues/presentation/pages/dues_master_screen.dart';
import 'package:kmp_petugas_app/service_locator.dart';
import 'package:kmp_petugas_app/theme/colors.dart';

class DuesPage extends StatefulWidget {
  static const routeName = '/dues';

  @override
  _DuesPageState createState() => _DuesPageState();
}

class _DuesPageState extends State<DuesPage> {
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
              create: (_) => serviceLocator.get<DuesBloc>(),
            ),
          ],
          child: ProgressHUD(child: DuesMasterScreen()),
        ),
      ),
    );
  }
}
