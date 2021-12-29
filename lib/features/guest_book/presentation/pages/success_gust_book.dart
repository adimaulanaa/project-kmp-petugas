import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kmp_petugas_app/features/guest_book/presentation/bloc/guest_book_bloc.dart';
import 'package:kmp_petugas_app/features/guest_book/presentation/pages/guest_book_screen.dart';
import 'package:kmp_petugas_app/service_locator.dart';

class SuccessGuestBook extends StatefulWidget {
  SuccessGuestBook({Key? key}) : super(key: key);

  @override
  _SuccessGuestBookState createState() => _SuccessGuestBookState();
}

class _SuccessGuestBookState extends State<SuccessGuestBook> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Color(0xffF54748), Color(0xffD23435)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter),
          ),
          child: Column(
            children: [
              SizedBox(height: 110),
              SvgPicture.asset('assets/icon/arrow-success.svg'),
              Padding(
                padding: const EdgeInsets.only(top: 90, bottom: 20),
                child: Center(
                  child: Text(
                    "Berhasil",
                    style: TextStyle(
                        fontFamily: "Nunito",
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w800,
                        fontSize: 28,
                        color: Colors.white),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Pembayaran berhasil di konfirmasi',
                    style: TextStyle(
                        fontFamily: "Nunito",
                        fontStyle: FontStyle.normal,
                        fontSize: 14,
                        color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Bukti Transaksi akan dikirim ke warga',
                    style: TextStyle(
                        fontFamily: "Nunito",
                        fontStyle: FontStyle.normal,
                        fontSize: 14,
                        color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              SizedBox(height: 40),
              FloatingActionButton(
                  onPressed: () async {
                    await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BlocProvider(
                                  create: (context) =>
                                      serviceLocator.get<GuestBookBloc>(),
                                  child: ProgressHUD(child: GustBookScreen()),
                                )));
                  },
                  child: SvgPicture.asset(
                    "assets/icon/next.svg",
                    color: Color(0xffF54748),
                  ),
                  backgroundColor: Color(0xffFFFFFF)),
            ],
          ),
        ),
      ),
    );
  }
}
