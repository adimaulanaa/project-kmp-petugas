import 'package:kmp_petugas_app/features/login/presentation/pages/login_screen.dart';
import 'package:kmp_petugas_app/features/login/presentation/pages/register_verify_screen.dart';
import 'package:kmp_petugas_app/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool secureText = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 70,
              ),
              Text('Register',
                  style: TextStyle(
                      fontFamily: "Nunito",
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Colors.black.withOpacity(0.8),
                      fontStyle: FontStyle.normal)),
              Text('Silakan masukkan detail untuk mendaftar',
                  style: TextStyle(
                      fontFamily: "Nunito",
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      fontSize: 12,
                      color: Color(0xff979797))),
              SizedBox(
                height: 60,
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
                        name: 'username',
                        decoration: InputDecoration(
                          prefixIcon: Container(
                            padding: EdgeInsets.all(10),
                            child: SvgPicture.asset(
                              'assets/icon/user.svg',
                              color: Color(0xffD1D5DB),
                            ),
                          ),
                          labelText: 'Username',
                        ),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(context),
                        ]),
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(height: 20),
                      FormBuilderTextField(
                        name: 'phone',
                        decoration: InputDecoration(
                          prefixIcon: Container(
                            padding: EdgeInsets.all(10),
                            child: SvgPicture.asset(
                              'assets/icon/phone.svg',
                              color: Color(0xffD1D5DB),
                            ),
                          ),
                          labelText: 'Phone Number',
                        ),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(context),
                        ]),
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(height: 20),
                      FormBuilderTextField(
                        obscureText: secureText ? false : true,
                        name: 'password',
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() => secureText = !secureText);
                            },
                            icon: secureText
                                ? Icon(Icons.visibility)
                                : Icon(
                                    Icons.visibility_off,
                                    color: Color(0xffD1D5DB),
                                  ),
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
        ),
      ),
      floatingActionButton: Container(
        padding: EdgeInsets.only(left: 15, right: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 45),
                child: Text(
                  "Login",
                  style: TextStyle(
                      fontFamily: "Nunito",
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.normal,
                      color: Color(0xffF54748)),
                ),
              ),
            ),
            FloatingActionButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RegisterverifyScreen()));
              },
              child: SvgPicture.asset(
                "assets/icon/next.svg",
                color: Colors.white,
              ),
              backgroundColor: ColorPalette.primary,
            )
          ],
        ),
      ),
    );
  }
}
