import 'package:flutter_svg/flutter_svg.dart';
import 'package:kmp_petugas_app/features/login/presentation/pages/otp_input_screen.dart';
import 'package:kmp_petugas_app/theme/button.dart';
import 'package:kmp_petugas_app/theme/colors.dart';
import 'package:kmp_petugas_app/theme/enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:kmp_petugas_app/framework/managers/helper.dart';

class RegisterverifyScreen extends StatelessWidget {
  const RegisterverifyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormBuilderState>();
    return Container(
      color: ColorPalette.primary,
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 70,
              ),
              Text('Verifikasi Nomor HP',
                  style: TextStyle(
                      fontFamily: "Nunito",
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                      fontStyle: FontStyle.normal)),
              Text('Masukkan Nomor Hp Anda Untuk Mendapatkan Kode OTP',
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
                            context.push(OtpInputScreen());
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
