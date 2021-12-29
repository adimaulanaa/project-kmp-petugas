import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:kmp_petugas_app/features/login/presentation/pages/success_screen.dart';
import 'package:kmp_petugas_app/framework/managers/helper.dart';

class OtpInputScreen extends StatefulWidget {
  OtpInputScreen({Key? key}) : super(key: key);

  @override
  _OtpInputScreenState createState() => _OtpInputScreenState();
}

class _OtpInputScreenState extends State<OtpInputScreen> {
  String? val;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF8F8F8),
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 25),
              child: Text(
                'Verifikasi OTP',
                style: TextStyle(
                    fontFamily: "Nunito",
                    fontWeight: FontWeight.w800,
                    color: Colors.black.withOpacity(0.8),
                    fontSize: 22,
                    fontStyle: FontStyle.normal),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25),
              child: Text(
                'Isi Dengan 4 Digit Terakhir Nomor Yang Menghubungi Anda',
                style: TextStyle(
                    fontFamily: "Nunito",
                    fontWeight: FontWeight.w400,
                    color: Color(0xff979797),
                    fontSize: 12,
                    fontStyle: FontStyle.normal),
              ),
            ),
            SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.only(left: 25, right: 79),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _textFieldOTP(first: true, last: false),
                  _textFieldOTP(first: true, last: false),
                  _textFieldOTP(first: true, last: false),
                  _textFieldOTP(first: true, last: false),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            context.push(SuccessScreen());
          },
          child: SvgPicture.asset(
            "assets/icon/next.svg",
            color: Colors.white,
          ),
          backgroundColor: val == null ? Color(0xffC4C4C4) : Color(0xffF54748)),
    );
  }

  Widget _textFieldOTP({required bool first, last}) {
    return Container(
      // color: Colors.amber,
      alignment: Alignment.bottomCenter,
      height: 60,
      child: AspectRatio(
        aspectRatio: 1.0,
        child: TextField(
          autofocus: true,
          onChanged: (value) {
            if (value.length == 1 && last == false) {
              FocusScope.of(context).nextFocus();
            }
            if (value.length == 0 && first == false) {
              FocusScope.of(context).previousFocus();
            }
            setState(() {
              val = value;
              print(val);
            });
          },
          showCursor: false,
          readOnly: false,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
          keyboardType: TextInputType.number,
          maxLength: 1,
          decoration: InputDecoration(
            counter: Offstage(),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xffCCCED3)),
                borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xffCCCED3)),
                borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
    );
  }
}
