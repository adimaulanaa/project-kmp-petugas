import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:kmp_petugas_app/config/global_vars.dart';
import 'package:kmp_petugas_app/config/string_resources.dart';
import 'package:kmp_petugas_app/env.dart';
import 'package:kmp_petugas_app/features/authentication/presentation/bloc/bloc.dart';
import 'package:kmp_petugas_app/features/login/presentation/bloc/bloc.dart';
import 'package:kmp_petugas_app/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:kmp_petugas_app/framework/managers/helper.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool secureText = false;
  String? username;
  String? password;

  @override
  void initState() {
    if (Env().isInDebugMode) {
      username = Env().demoUsername;
      password = Env().demoPassword;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) async {
        if (state is LoadLogin) {
          final progress = ProgressHUD.of(context);
          progress?.showWithText(
              GlobalConfiguration().getValue(GlobalVars.TEXT_LOADING_TITLE) ??
                  StringResources.PLEASE_WAIT);
          setState(() {});
          //
        } else if (state is LoginSuccess) {
          final progress = ProgressHUD.of(context);
          progress!.dismiss();
          Navigator.pop(context);
          BlocProvider.of<AuthenticationBloc>(context)
              .add(LoggedIn(loggedInData: state.success));

          //
        } else if (state is LoginFailure) {
          catchAllException(context, state.error, true);
          final progress = ProgressHUD.of(context);
          progress!.dismiss();
          setState(() {
            // isLoadingData = true;
          });
        }
      },
      child: Scaffold(
        backgroundColor: ColorPalette.main,
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.all(25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 40,
                ),
                Text('Login',
                    style: TextStyle(
                        fontFamily: "Nunito",
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Colors.black.withOpacity(0.8),
                        fontStyle: FontStyle.normal)),
                Text('Silakan Masukkan Username dan Password Anda',
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
                          initialValue: username ?? null,
                          onSaved: (val) {
                            setState(() {
                              username = val;
                            });
                          },
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
                        SizedBox(
                          height: 20,
                        ),
                        FormBuilderTextField(
                          initialValue: password ?? null,
                          onSaved: (val) {
                            setState(() {
                              password = val;
                              print(val);
                            });
                          },
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
                SizedBox(
                  height: 60,
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (_formKey.currentState!.saveAndValidate()) {
              BlocProvider.of<LoginBloc>(context).add(
                  LoginWithCredentialsPressed(
                      username: username!, password: password!));
            }
          },
          backgroundColor: username != null && password != null
              ? Color(0xffF54748)
              : Color(0xffC4C4C4),
          child: SvgPicture.asset(
            "assets/icon/next.svg",
            color: Color(0xffFFFFFF),
          ),
        ),
      ),
    );
  }
}
