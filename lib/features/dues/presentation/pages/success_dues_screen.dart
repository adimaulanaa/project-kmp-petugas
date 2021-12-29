import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kmp_petugas_app/features/dues/presentation/pages/dues_page.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class SuccesDuesScreen extends StatefulWidget {
  SuccesDuesScreen({Key? key}) : super(key: key);

  @override
  _SuccesDuesScreenState createState() => _SuccesDuesScreenState();
}

class _SuccesDuesScreenState extends State<SuccesDuesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                onPressed: () {
                  pushNewScreen(
                    context,
                    screen: DuesPage(),
                    withNavBar: false,
                    pageTransitionAnimation: PageTransitionAnimation.cupertino,
                  );
                },
                child: SvgPicture.asset(
                  "assets/icon/next.svg",
                  color: Color(0xffF54748),
                ),
                backgroundColor: Color(0xffFFFFFF)),
          ],
        ),
      ),
    );
  }
}
