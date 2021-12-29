import 'package:flutter_svg/flutter_svg.dart';
import 'package:kmp_petugas_app/features/login/presentation/pages/new_password_screen.dart';
import 'package:kmp_petugas_app/theme/button.dart';
import 'package:kmp_petugas_app/theme/colors.dart';
import 'package:kmp_petugas_app/theme/enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:kmp_petugas_app/framework/managers/helper.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormBuilderState>();
    return Container(
      color: ColorPalette.primary,
      child: Scaffold(
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
                    Navigator.pop(context);
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
                            offset: Offset(0, 1), // changes position of shadow
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
        body: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Lupa Password',
                  style: TextStyle(
                      fontFamily: "Nunito",
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                      fontStyle: FontStyle.normal)),
              Text('Masukkan nomor hp anda untuk mereset password anda',
                  style: TextStyle(
                      fontFamily: "Nunito",
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      fontSize: 12,
                      color: Color(0xff979797))),
              SizedBox(
                height: 25,
              ),
              FormBuilder(
                key: _formKey,
                child: Theme(
                  data: ThemeData(
                    inputDecorationTheme: InputDecorationTheme(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      errorBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 1, color: Color(0xffCCCED3)),
                          borderRadius: BorderRadius.circular(16)),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 3,
                          color: Colors.transparent,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 3,
                          color: Colors.transparent,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 3,
                          color: Colors.transparent,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      hintStyle: TextStyle(color: Color(0xffD1D5DB)),
                      labelStyle: TextStyle(color: Color(0xffD1D5DB)),
                      errorStyle: TextStyle(color: ColorPalette.primary),
                      filled: true,
                      fillColor: Color(0xffE5E5E5).withOpacity(0.5),
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                    ),
                  ),
                  child: Column(
                    children: [
                      FormBuilderTextField(
                        decoration: InputDecoration(
                            prefixIcon: Container(
                              padding: EdgeInsets.all(10),
                              child: SvgPicture.asset(
                                'assets/icon/phone.svg',
                                color: Color(0xffD1D5DB),
                              ),
                            ),
                            labelText: 'Nomor Handphone'),
                        name: 'phoneVerification',
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(context),
                        ]),
                        keyboardType: TextInputType.number,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Navigator.push(context,
            //     MaterialPageRoute(builder: (context) => OtpInputScreen()));
            showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: (context) {
                  return Container(
                    height: 340,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25, vertical: 10),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Informasi',
                                style: TextStyle(
                                    fontFamily: "Nunito",
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18,
                                    fontStyle: FontStyle.normal,
                                    color: Colors.black)),
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                height: 28,
                                width: 28,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14),
                                    color: Colors.white),
                                child: Icon(Icons.close),
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 20),
                        Image.asset(
                          'assets/images/verifikasi.png',
                          height: 90,
                        ),
                        SizedBox(height: 30),
                        Text(
                          'Anda akan di hubungi oleh sistem kami. Untuk verifikasi nomor telpon anda',
                          textAlign: TextAlign.center,
                          style: TextPalette.txt14.copyWith(
                              color: ColorPalette.black,
                              fontWeight: FontWeight.w400),
                        ),
                        SizedBox(height: 30),
                        KmpFlatButton(
                          fullWidth: true,
                          buttonType: ButtonType.primary,
                          onPressed: () {
                            context.push(NewPasswordScreen());
                          },
                          title: 'OK',
                        ),
                      ],
                    ),
                  );
                });
          },
          child: SvgPicture.asset(
            "assets/icon/next.svg",
            color: Colors.white,
          ),
          backgroundColor: ColorPalette.primary,
        ),
      ),
    );
  }
}
