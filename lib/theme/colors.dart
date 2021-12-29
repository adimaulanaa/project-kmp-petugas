import 'package:flutter/material.dart';

class ColorPalette {
  static const main = Color(0xfffcfcfc);
  static const primary = Color(0xffF54748); // Merah
  static const secondary = Color(0xffF4EB44); // Kuning
  static const disabledButonColor = Color(0xff7E7E7E); // abu2 Disable
  static const disabledBTextolor = Color(0xffCCCED3); // abu2 title
  static const grey = Color(0xffe5e5e5); // abu2
  static const black = Colors.black87; // abu2 title
}

class TextPalette {
  static TextStyle txt36 = TextStyle(fontSize: 36, fontFamily: 'Nunito');
  static TextStyle txt28 = TextStyle(fontSize: 28, fontFamily: 'Nunito');
  static TextStyle txt24 = TextStyle(fontSize: 24, fontFamily: 'Nunito');
  static TextStyle txt22 = TextStyle(fontSize: 22, fontFamily: 'Nunito');
  static TextStyle txt18 = TextStyle(fontSize: 18, fontFamily: 'Nunito');
  static TextStyle txt16 = TextStyle(fontSize: 16, fontFamily: 'Nunito');
  static TextStyle txt14 = TextStyle(fontSize: 14, fontFamily: 'Nunito');
  static TextStyle txt13 = TextStyle(fontSize: 13, fontFamily: 'Nunito');
  static TextStyle txt12 = TextStyle(fontSize: 12, fontFamily: 'Nunito');
  static TextStyle txt10 = TextStyle(fontSize: 10, fontFamily: 'Nunito');

  static TextStyle hintTextStyle = TextStyle(
      fontFamily: "Nunito",
      fontWeight: FontWeight.w700,
      fontStyle: FontStyle.normal,
      color: Color(0xffD1D5DB));

  static TextStyle registerTitleStyle = TextStyle(
      fontFamily: "Nunito",
      fontWeight: FontWeight.w800,
      fontStyle: FontStyle.normal,
      fontSize: 28,
      color: Colors.white);

  static TextStyle registerSubtitleStyle = TextStyle(
      fontFamily: "Nunito",
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
      fontSize: 14,
      color: Colors.white);

  static TextStyle dashboardTextStyle = TextStyle(
      fontFamily: "Nunito",
      fontWeight: FontWeight.w700,
      fontStyle: FontStyle.normal,
      fontSize: 10,
      color: Color(0xff121212));
}

final appTheme = ThemeData(
  fontFamily: 'Nunito',
  // accentColor: Colors.red,
  // primaryColor: ColorPalette.main,
  // brightness: Brightness.light,
  // textTheme: TextTheme(
  //   bodyText1: TextStyle(
  //       fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.5),
  //   bodyText2: TextStyle(
  //       fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.25),
  // ),
);
