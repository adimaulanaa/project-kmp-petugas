import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kmp_petugas_app/features/profile/presentation/pages/profile_screen.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class EditNewPassword extends StatefulWidget {
  EditNewPassword({Key? key}) : super(key: key);

  @override
  _EditNewPasswordState createState() => _EditNewPasswordState();
}

class _EditNewPasswordState extends State<EditNewPassword> {
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
                  'Melakukan Proses Edit Password ',
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
                    screen: ProfileScreen(),
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
