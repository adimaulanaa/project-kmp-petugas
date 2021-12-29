import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kmp_petugas_app/theme/button.dart';
import 'package:kmp_petugas_app/theme/colors.dart';
import 'package:kmp_petugas_app/theme/enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:kmp_petugas_app/theme/size.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kmp_petugas_app/features/authentication/presentation/bloc/bloc.dart';
import 'package:kmp_petugas_app/service_locator.dart';

// ignore: must_be_immutable
class WalkthroughPage extends StatefulWidget {
  WalkthroughPage({Key? key}) : super(key: key);

  SharedPreferences prefs = serviceLocator.get<SharedPreferences>();

  @override
  _WalkthroughPageState createState() => _WalkthroughPageState();
}

class _WalkthroughPageState extends State<WalkthroughPage> {
  final introKey = GlobalKey<IntroductionScreenState>();
  bool lastPage = false;
  double pageposition = 0;

  void _onIntroEnd(context) {
    _setPreference();
    BlocProvider.of<AuthenticationBloc>(context).add(ShowLogin());
  }

  void _nextPage() {
    introKey.currentState!.controller
        .nextPage(duration: Duration(milliseconds: 250), curve: Curves.easeIn);
  }

  Widget _buildImage(String assetName, [double width = 350]) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Image.asset('assets/images/$assetName', width: width),
    );
  }

  @override
  void initState() {
    super.initState();
    // _setPreference();
  }

  void _setPreference() async {
    await widget.prefs.setBool('seen', true);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    const pageDecoration = const PageDecoration(
      titleTextStyle: TextStyle(
          fontSize: 28.0,
          fontWeight: FontWeight.w800,
          color: Colors.white,
          fontFamily: 'Nunito'),
      descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      imagePadding: EdgeInsets.only(
        top: 40,
      ),
      bodyTextStyle:
          TextStyle(fontSize: 14.0, color: Colors.white, fontFamily: 'Nunito'),
    );

    var introList = [
      PageViewModel(
        image: _buildImage("walk1.png"),
        titleWidget: Container(
          padding: EdgeInsets.only(left: 15, top: 15),
          child: Align(
            alignment: Alignment.center,
            child: Text(
              "Fleksibel",
              textAlign: TextAlign.center,
              style: TextPalette.registerTitleStyle,
            ),
          ),
        ),
        bodyWidget: Container(
          height: Screen(size).hp(68),
          child: Column(children: [
            Align(
              alignment: Alignment.center,
              child: Text(
                  "Kini anda dapat membangun kampung digital hanya dengan menginstal aplikasi ini",
                  textAlign: TextAlign.center,
                  style: TextPalette.registerSubtitleStyle),
            ),
            Flexible(
                child: SizedBox(
              height: 65,
            )),
            // Expanded(child: Container()),
            InkWell(
              onTap: () {
                _nextPage();
              },
              child: Container(
                  padding: EdgeInsets.all(15),
                  child: SvgPicture.asset(
                    'assets/icon/next.svg',
                  ),
                  height: 56,
                  width: 56,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  )),
            ),
          ]),
        ),
        decoration: pageDecoration,
      ),
      PageViewModel(
        image: _buildImage("walk2.png"),
        titleWidget: Container(
          padding: EdgeInsets.only(left: 15, top: 15),
          child: Align(
            alignment: Alignment.center,
            child: Text(
              "Transparansi",
              textAlign: TextAlign.center,
              style: TextPalette.registerTitleStyle,
            ),
          ),
        ),
        bodyWidget: Container(
          height: Screen(size).hp(68),
          child: Column(children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                  "Mencatat pemasukan dan pengeluaran dana secara efektif dan efisien",
                  textAlign: TextAlign.center,
                  style: TextPalette.registerSubtitleStyle),
            ),

            Flexible(
                child: SizedBox(
              height: 65,
            )),
            // Expanded(
            //   child:
            //       Align(alignment: Alignment.bottomCenter, child: SizedBox()),
            // ),
            InkWell(
              onTap: () {
                _nextPage();
              },
              child: Container(
                  padding: EdgeInsets.all(15),
                  child: SvgPicture.asset(
                    'assets/icon/next.svg',
                  ),
                  height: 56,
                  width: 56,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  )),
            ),
          ]),
        ),
        decoration: pageDecoration,
      ),
      PageViewModel(
        image: _buildImage("walk3.png"),
        titleWidget: Container(
          padding: EdgeInsets.only(left: 15, top: 15),
          child: Align(
            alignment: Alignment.center,
            child: Text(
              "Wujudkan Kampung Digital",
              textAlign: TextAlign.center,
              style: TextPalette.registerTitleStyle,
            ),
          ),
        ),
        bodyWidget: Container(
          height: Screen(size).hp(68),
          child: Column(children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                  "Menuju Kampung Digital dengan mudah, cepat, dan transparan",
                  textAlign: TextAlign.center,
                  style: TextPalette.registerSubtitleStyle),
            ),

            Flexible(
                child: SizedBox(
              height: 30,
            )),
            // Expanded(
            //   child:
            //       Align(alignment: Alignment.bottomCenter, child: SizedBox()),
            // ),
            KmpFlatButton(
              minWidth: 230,
              buttonType: ButtonType.secondary,
              onPressed: () => _onIntroEnd(context),
              title: 'Get Started',
            ),
          ]),
        ),
        decoration: pageDecoration,
      ),
    ];
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xffF54748), Color(0xffD23435)])),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: IntroductionScreen(
            globalBackgroundColor: Colors.transparent,
            onChange: (page) {
              pageposition = page.toDouble();
              setState(() {});
              if (page == introList.length - 1) {
                setState(() {
                  lastPage = true;
                });
              } else {
                setState(() {
                  lastPage = false;
                });
              }
            },
            key: introKey,
            globalHeader: Container(
                padding: EdgeInsets.only(left: 20, right: 20, top: 5),
                width: double.infinity,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 33,
                        height: 33,
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.white),
                        child: Center(
                          child: Icon(
                            Icons.close,
                            color: Colors.red,
                          ),
                        ),
                      ),
                      DotsIndicator(
                        position: pageposition,
                        dotsCount: introList.length,
                        decorator: DotsDecorator(
                          size: Size(10.0, 10.0),
                          color: Color(0x66ffffff),
                          activeColor: Colors.white,
                          activeSize: Size(21.0, 10.0),
                          activeShape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(25.0)),
                          ),
                        ),
                      )
                    ])),
            // globalFooter: Container(),
            pages: introList,
            onDone: () => _onIntroEnd(context),
            showNextButton: false,
            showDoneButton: false,
            isProgress: false,
          ),
        ),
      ),
    );
  }
}
