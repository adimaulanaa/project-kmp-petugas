import 'package:another_flushbar/flushbar_helper.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:kmp_petugas_app/config/global_vars.dart';
import 'package:kmp_petugas_app/config/string_resources.dart';
import 'package:kmp_petugas_app/features/profile/data/models/post_password.dart';
import 'package:kmp_petugas_app/features/profile/presentation/bloc/bloc.dart';
import 'package:kmp_petugas_app/theme/colors.dart';

class EditPasswordScreen extends StatefulWidget {
  EditPasswordScreen({Key? key}) : super(key: key);

  @override
  _EditPasswordScreenState createState() => _EditPasswordScreenState();
}

class _EditPasswordScreenState extends State<EditPasswordScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool secureTextNew = false;
  bool secureTextOld = false;
  bool secureTextConfirm = false;
  bool isLoading = false;

  TextEditingController oldController = TextEditingController();
  TextEditingController newController = TextEditingController();
  TextEditingController confirmController = TextEditingController();

  PostPassword? itemPassword;

  @override
  Widget build(BuildContext context) {
    return _build(context);
  }

  Widget _build(BuildContext context) {
    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) async {
        if (state is ProfileLoading) {
          isLoading = false;
          setState(() {});
        } else if (state is ChangePasswordSuccess) {
          // Navigator.pop(context);
          // logout(context, "Log out auto");
          _thankYouPopup();
        }
      },
      child: _buildBody(context),
    );
  }

  @override
  Widget _buildBody(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF8F8F8),
      appBar: AppBar(
        toolbarHeight: 50,
        elevation: 0,
        backgroundColor: Color(0xffF8F8F8),
        automaticallyImplyLeading: false,
        title: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            padding: EdgeInsets.all(10),
            height: 33,
            width: 33,
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                spreadRadius: 1.5,
                blurRadius: 15,
                offset: Offset(0, 1),
              ),
            ], borderRadius: BorderRadius.circular(16), color: Colors.white),
            child: SvgPicture.asset(
              "assets/icon/back.svg",
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.all(25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Ubah Password',
                  style: TextStyle(
                      fontFamily: "Nunito",
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Colors.black.withOpacity(0.8),
                      fontStyle: FontStyle.normal)),
              Text('Masukan Password Anda',
                  style: TextStyle(
                      fontFamily: "Nunito",
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      fontSize: 12,
                      color: Color(0xff979797))),
              SizedBox(
                height: 20,
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
                        obscureText: secureTextOld ? false : true,
                        name: 'oldpass',
                        controller: oldController,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() => secureTextOld = !secureTextOld);
                            },
                            icon: secureTextOld
                                ? Icon(
                                    Icons.visibility,
                                    color: Color(0xffD1D5DB),
                                  )
                                : Icon(
                                    Icons.visibility_off,
                                    color: Color(0xffD1D5DB),
                                  ),
                          ),
                          labelText: 'Password Lama',
                          prefixIcon: Container(
                            height: 60,
                            padding: EdgeInsets.only(right: 15, left: 10),
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
                        obscureText: secureTextNew ? false : true,
                        name: 'newPass',
                        controller: newController,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() => secureTextNew = !secureTextNew);
                            },
                            icon: secureTextNew
                                ? Icon(
                                    Icons.visibility,
                                    color: Color(0xffD1D5DB),
                                  )
                                : Icon(
                                    Icons.visibility_off,
                                    color: Color(0xffD1D5DB),
                                  ),
                          ),
                          labelText: 'Password Baru',
                          prefixIcon: Container(
                            height: 60,
                            padding: EdgeInsets.only(right: 15, left: 10),
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
                        obscureText: secureTextConfirm ? false : true,
                        name: 'confirmPass',
                        controller: confirmController,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(
                                  () => secureTextConfirm = !secureTextConfirm);
                            },
                            icon: secureTextConfirm
                                ? Icon(
                                    Icons.visibility,
                                    color: Color(0xffD1D5DB),
                                  )
                                : Icon(
                                    Icons.visibility_off,
                                    color: Color(0xffD1D5DB),
                                  ),
                          ),
                          labelText: 'Konfirmasi Password',
                          prefixIcon: Container(
                            height: 60,
                            padding: EdgeInsets.only(right: 15, left: 10),
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
        backgroundColor: Color(0xffF54748),
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            final progress = ProgressHUD.of(context);

            progress!.showWithText(
                GlobalConfiguration().getValue(GlobalVars.TEXT_LOADING_TITLE) ??
                    StringResources.PLEASE_WAIT);

            FocusScope.of(context).requestFocus(new FocusNode());

            setState(() {
              itemPassword = PostPassword(
                  oldPassword: oldController.text,
                  newPassword: newController.text,
                  confirmPassword: confirmController.text);
            });

            BlocProvider.of<ProfileBloc>(context)
                .add(ChangePasswordEvent(changePassword: itemPassword!));
            progress.dismiss();
          } else {
            final progress = ProgressHUD.of(context);
            progress!.showWithText(
                GlobalConfiguration().getValue(GlobalVars.TEXT_LOADING_TITLE) ??
                    StringResources.PLEASE_WAIT);
            progress.dismiss();
            FlushbarHelper.createError(
                message: "Harap Memasukkan Data Valid",
                title: "Warning",
                duration: Duration(seconds: 3))
              ..show(context);
          }
        },
        child: Icon(
          Icons.check,
          size: 36,
        ),
      ),
    );
  }

  Future<void> _thankYouPopup() {
    return CoolAlert.show(
        context: context,
        type: CoolAlertType.success,
        text: "Update Password Berhasil, Silahkan Login Ulang",
        confirmBtnText: 'Ok',
        onConfirmBtnTap: () async {
          int count = 0;
          Navigator.of(context).popUntil((_) => count++ >= 2);
        });
  }
}
