import 'package:kmp_petugas_app/features/login/presentation/pages/login_screen.dart';
import 'package:kmp_petugas_app/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen({Key? key}) : super(key: key);

  @override
  _NewPasswordScreenState createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  bool secureText1 = false;
  bool secureText2 = false;
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormBuilderState>();
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      color: ColorPalette.main,
      child: Scaffold(
        backgroundColor: Colors.transparent,
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
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Reset Password',
                style: TextStyle(
                    fontFamily: "Nunito",
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                    fontStyle: FontStyle.normal)),
            Text('Masukkan password baru anda',
                style: TextStyle(
                    fontFamily: "Nunito",
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    fontSize: 12,
                    color: Color(0xff979797))),
            SizedBox(
              height: 30,
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
                      obscureText: secureText1 ? false : true,
                      name: 'password1',
                      decoration: InputDecoration(
                        suffix: IconButton(
                          onPressed: () {
                            setState(() => secureText1 = true);
                          },
                          icon: secureText1
                              ? Icon(Icons.visibility)
                              : Icon(Icons.visibility_off),
                        ),
                        labelText: 'Password',
                        prefixIcon: Container(
                          padding: EdgeInsets.all(10),
                          child: SvgPicture.asset(
                            'assets/icon/lock.svg',
                            color: Color(0xffD1D5DB),
                          ),
                        ),
                      ),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(context),
                      ]),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    FormBuilderTextField(
                      obscureText: secureText1 ? false : true,
                      name: 'password2',
                      decoration: InputDecoration(
                        suffix: IconButton(
                          onPressed: () {
                            setState(() => secureText2 = true);
                          },
                          icon: secureText2
                              ? Icon(Icons.visibility, color: Colors.black)
                              : Icon(Icons.visibility_off, color: Colors.black),
                        ),
                        labelText: 'Password',
                        prefixIcon: Container(
                          padding: EdgeInsets.all(10),
                          child: SvgPicture.asset(
                            'assets/icon/lock.svg',
                            color: Color(0xffD1D5DB),
                          ),
                        ),
                      ),
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
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => LoginScreen()));
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
