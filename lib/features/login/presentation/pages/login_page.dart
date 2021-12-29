import 'package:kmp_petugas_app/features/login/presentation/bloc/bloc.dart';
import 'package:kmp_petugas_app/features/login/presentation/pages/login_screen.dart';
import 'package:kmp_petugas_app/service_locator.dart';
import 'package:kmp_petugas_app/theme/button.dart';
import 'package:kmp_petugas_app/theme/enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xffF54748), Color(0xffD23435)])),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 100,
              ),
              Container(
                  padding: EdgeInsets.only(left: 50, right: 50, bottom: 103),
                  child: Image.asset('assets/images/logo_putih.png')),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Padamu Negeri, Kami Berbakti',
                  style: TextStyle(
                      fontFamily: "Nunito",
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 117,
              ),
              KmpFlatButton(
                minWidth: 230,
                buttonType: ButtonType.secondary,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) {
                        return BlocProvider(
                          create: (_) => serviceLocator.get<LoginBloc>(),
                          child: ProgressHUD(
                            child: Builder(
                              builder: (context) => LoginScreen(),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
                title: 'Login',
              ),
              // SizedBox(
              //   height: 20,
              // ),
              // KmpFlatButton(
              //   minWidth: 230,
              //   buttonType: ButtonType.third,
              //   onPressed: () {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder: (_) {
              //           return BlocProvider(
              //             create: (_) => serviceLocator.get<LoginBloc>(),
              //             child: ProgressHUD(
              //               child: Builder(
              //                 builder: (context) => RegisterScreen(),
              //               ),
              //             ),
              //           );
              //         },
              //       ),
              //     );
              //   },
              //   title: 'Register',
              // ),
            ],
          ),
        ),

        //  BlocProvider(
        //   create: (_) => serviceLocator.get<LoginBloc>(),
        //   child: ProgressHUD(
        //     child: Builder(
        //       builder: (context) => LoginScreen(),
        //     ),
        //   ),
        // ),
      ),
    );
  }
}
