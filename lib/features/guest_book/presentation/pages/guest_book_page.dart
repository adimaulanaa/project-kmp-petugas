import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:kmp_petugas_app/features/guest_book/presentation/bloc/bloc.dart';
import 'package:kmp_petugas_app/features/guest_book/presentation/pages/guest_book_screen.dart';
import 'package:kmp_petugas_app/service_locator.dart';
import 'package:kmp_petugas_app/theme/colors.dart';

class GustBookPage extends StatefulWidget {
  static const routeName = '/subscriptions';

  @override
  _GustBookPageState createState() => _GustBookPageState();
}

class _GustBookPageState extends State<GustBookPage> {
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
              create: (_) => serviceLocator.get<GuestBookBloc>(),
            ),
          ],
          child: ProgressHUD(child: GustBookScreen()),
        ),
      ),
    );
  }
}
