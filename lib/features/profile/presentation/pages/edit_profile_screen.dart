import 'dart:io';
import 'dart:ui';
import 'package:another_flushbar/flushbar_helper.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kmp_petugas_app/env.dart';
import 'package:kmp_petugas_app/features/authentication/data/models/user_model.dart';
import 'package:kmp_petugas_app/features/dashboard/data/models/dashboard_model.dart';
import 'package:kmp_petugas_app/features/dashboard/data/models/region_model.dart';
import 'package:kmp_petugas_app/features/profile/domain/entities/post_profile.dart';
import 'package:kmp_petugas_app/features/profile/presentation/bloc/bloc.dart';
import 'package:kmp_petugas_app/framework/managers/helper.dart';
import 'package:kmp_petugas_app/theme/colors.dart';
import 'package:uuid/uuid.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class EditProfile extends StatefulWidget {
  final Officer? data;
  EditProfile({Key? key, this.data}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  bool isMale = false;
  bool isFemale = false;
  List<RegionModel> masterRegion = [];
  List<RegionModel> listProvinsi = [];
  List<RegionModel> listKoKab = [];
  List<RegionModel> listKec = [];
  List<RegionModel> listKel = [];
  List<Officer>? listOfficer = [];

  List<Village> listVillage = [];
  String noKtp = '';
  String nama = '';
  String gender = '';
  String noTelp = '';
  String kelurahanId = '';
  String provinsiId = '';
  String rt = '';
  String rw = '';
  String email = '';
  String jalan = '';
  late PostProfile itemProfile;

  final _formKey = GlobalKey<FormBuilderState>();
  bool secureTextNew = false;
  bool secureTextOld = false;
  File? imgRes;
  String? pathRes = '';
  final ImagePicker _picker = ImagePicker();

  Future getImageRes(ImageSource media) async {
    var resultRes = await _picker.pickImage(source: media);

    if (resultRes != null) {
      setState(() {
        imgRes = File(resultRes.path);
      });
      final dirRes = await path_provider.getTemporaryDirectory();
      final filenameRes = Uuid().v4();
      final targetPathRes = dirRes.absolute.path + "/doc$filenameRes.jpg";

      final int imageQualityRes = Env().configImageCompressQuality!;

      try {
        final compressedFileRes = await FlutterImageCompress.compressAndGetFile(
          resultRes.path,
          targetPathRes,
          quality: imageQualityRes,
        );

        setState(() {
          if (compressedFileRes != null && compressedFileRes.lengthSync() > 0) {
            print(targetPathRes);
            pathRes = targetPathRes;
          } else {
            pathRes = resultRes.path;
          }
        });
      } catch (e) {
        // surpress error since we don't care
        if (Env().isInDebugMode) {
          print('[pertama ] error $e');
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    gender = widget.data!.gender!;
    if (gender == 'L') {
      isMale = true;
    } else if (gender == 'P') {
      isFemale = true;
    }

    nama = widget.data!.name!;
    noKtp = widget.data!.idCard!;
    noTelp = widget.data!.phone!;
    kelurahanId = widget.data!.subDistrict!;
    provinsiId = widget.data!.province!;
    rt = widget.data!.rt!;
    rw = widget.data!.rw!;
    email = widget.data!.email!;
    jalan = widget.data!.street!;

    // listOfficer = widget.data.officer;

    BlocProvider.of<ProfileBloc>(context).add(EditLoadProfile());
  }

  @override
  Widget build(BuildContext context) {
    return _build(context);
  }

  Widget _build(BuildContext context) {
    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) async {
        if (state is ProfileLoading) {
          // final progress = ProgressHUD.of(context);
          // progress?.showWithText(
          //     GlobalConfiguration().getValue(GlobalVars.TEXT_LOADING_TITLE) ??
          //         StringResources.PLEASE_WAIT);
          setState(() {});
          //
        } else if (state is EditProfileLoaded) {
          final progress = ProgressHUD.of(context);
          if (state.listVillage!.length > 0 && state.listRegion!.length > 0) {
            // if (state.listVillage != null) {
            // masterRegion = state.listVillage!;
            masterRegion = state.listRegion!;

            listProvinsi = masterRegion
                .where((element) =>
                    element.level == 2 && element.type == 'Provinsi')
                .toList();
            listKoKab = masterRegion
                .where((element) => element.parent == widget.data!.province!)
                .toList();
            listKec = masterRegion
                .where((element) => element.parent == widget.data!.city!)
                .toList();
            listKel = masterRegion
                .where((element) => element.parent == widget.data!.district!)
                .toList();
            print("sadasdasd");
            setState(() {});
          }
          progress!.dismiss();

          //
        } else if (state is EditProfileSuccess) {
          // _thankYouPopup();
          Navigator.pop(context);
          // serviceLocator.get<DashboardBloc>()..add(LoadDashboard());
        } else if (state is ProfileFailure) {
          catchAllException(context, state.error, true);
          final progress = ProgressHUD.of(context);
          progress!.dismiss();
          setState(() {});
          FlushbarHelper.createError(
            message: state.error,
            title: "Error",
          )..show(context);
        }
      },
      child: _buildBody(context),
    );
  }

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
                offset: Offset(0, 1), // changes position of shadow
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
          padding: const EdgeInsets.all(25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Edit Profile',
                  style: TextStyle(
                      fontFamily: "Nunito",
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Colors.black.withOpacity(0.8),
                      fontStyle: FontStyle.normal)),
              Text('Lengkapi Identitas Anda',
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
                      InkWell(
                        onTap: () {
                          alertFotoRes();
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 27),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: Colors.white),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8, right: 8),
                              child: Row(
                                children: [
                                  imgRes == null
                                      ? DottedBorder(
                                          padding: const EdgeInsets.all(8),
                                          radius: const Radius.circular(8),
                                          borderType: BorderType.RRect,
                                          strokeWidth: 0.5,
                                          color: Color(0xffC4C4C4),
                                          child: SvgPicture.asset(
                                            "assets/icon/person.svg",
                                            height: 30,
                                          ))
                                      : Container(
                                          width: 40,
                                          height: 40,
                                          child: Image.file(
                                            imgRes!,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Container(
                                    width: imgRes == null ? 190 : 150,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Foto Selfie",
                                          style: TextStyle(
                                              fontFamily: "Nunito",
                                              fontWeight: FontWeight.w700,
                                              fontStyle: FontStyle.normal,
                                              fontSize: 16,
                                              color: Colors.black),
                                        ),
                                        Text(
                                          "Tambahkan Foto Selfie",
                                          style: TextStyle(
                                              fontFamily: "Nunito",
                                              fontWeight: FontWeight.w400,
                                              fontStyle: FontStyle.normal,
                                              fontSize: 10,
                                              color: Color(0xffCCCED3)),
                                        ),
                                      ],
                                    ),
                                  ),
                                  imgRes == null
                                      ? IconButton(
                                          onPressed: () {
                                            alertFotoRes();
                                          },
                                          icon: Icon(Icons.add))
                                      : Row(
                                          children: [
                                            IconButton(
                                                onPressed: () {
                                                  // alertKtp();
                                                },
                                                icon: Icon(
                                                  Icons.done,
                                                  color: Colors.green,
                                                )),
                                            IconButton(
                                                onPressed: () {
                                                  alertFotoRes();
                                                },
                                                icon: Icon(Icons.add)),
                                          ],
                                        )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      FormBuilderTextField(
                        name: 'noktp',
                        initialValue: noKtp,
                        decoration: InputDecoration(
                          prefixIcon: Container(
                            padding: EdgeInsets.all(16),
                            child: SvgPicture.asset(
                              'assets/icon/id_card.svg',
                              color: Color(0xffD1D5DB),
                              height: 30,
                            ),
                          ),
                          labelText: 'Nomor KTP',
                          labelStyle: TextPalette.hintTextStyle,
                        ),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(context),
                          FormBuilderValidators.min(context, 16),
                          FormBuilderValidators.maxLength(context, 16)
                        ]),
                        keyboardType: TextInputType.number,
                        onChanged: (ktpVal) {
                          setState(() {
                            noKtp = ktpVal!;
                          });
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      FormBuilderTextField(
                        initialValue: nama,
                        onChanged: (nameVal) {
                          setState(() {
                            nama = nameVal!;
                          });
                        },
                        name: 'username',
                        decoration: InputDecoration(
                          labelText: 'Username',
                          prefixIcon: Container(
                            height: 60,
                            padding: EdgeInsets.only(right: 15, left: 10),
                            child: SvgPicture.asset(
                              'assets/icon/user.svg',
                              color: Color(0xffD1D5DB),
                            ),
                          ),
                        ),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(context),
                        ]),
                        keyboardType: TextInputType.name,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      FormBuilderTextField(
                        initialValue: noTelp,
                        onChanged: (telpVal) {
                          setState(() {
                            noTelp = telpVal!;
                          });
                        },
                        name: 'nowa',
                        decoration: InputDecoration(
                          labelText: 'Nomor Telepon',
                          prefixIcon: Container(
                            height: 60,
                            padding: EdgeInsets.only(right: 15, left: 10),
                            child: SvgPicture.asset(
                              'assets/icon/phone.svg',
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
                        initialValue: email == "" ? " - " : email,
                        onChanged: (emailVal) {
                          setState(() {
                            email = emailVal!;
                          });
                        },
                        name: 'email',
                        decoration: InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Container(
                            height: 60,
                            padding: EdgeInsets.only(right: 15, left: 10),
                            child: SvgPicture.asset(
                              'assets/icon/email.svg',
                              color: Color(0xffD1D5DB),
                            ),
                          ),
                        ),
                        validator: FormBuilderValidators.compose([
                          // FormBuilderValidators.required(context),
                        ]),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(children: [
                        Flexible(
                          //!Laki Laki
                          child: InkWell(
                              child: Container(
                            width: MediaQuery.of(context).size.width * 0.5,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: isMale == false
                                    ? Color(0xffE5E5E5).withOpacity(0.5)
                                    : Color(0xff58C863).withOpacity(0.5)),
                            child: TextButton.icon(
                                onPressed: () {
                                  isMale = !isMale;
                                  if (isFemale == true) {
                                    isFemale = false;
                                  }
                                  setState(() {});
                                },
                                icon: Icon(
                                  Icons.male,
                                  color: isMale == false
                                      ? Color(0xffD1D5DB)
                                      : Colors.white,
                                ),
                                label: Text(
                                  "Laki-Laki",
                                  style: TextStyle(
                                      fontFamily: "Nunito",
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                      color: isMale == false
                                          ? Color(0xffD1D5DB)
                                          : Colors.white),
                                )),
                          )),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Flexible(
                          //!Perempuan
                          child: InkWell(
                              child: Container(
                            width: MediaQuery.of(context).size.width * 0.5,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: isFemale == false
                                    ? Color(0xffE5E5E5).withOpacity(0.5)
                                    : Color(0xffE33A4E).withOpacity(0.5)),
                            child: TextButton.icon(
                                onPressed: () {
                                  isFemale = !isFemale;
                                  if (isMale == true) {
                                    isMale = false;
                                  }
                                  setState(() {});
                                },
                                icon: Icon(
                                  Icons.female,
                                  color: isFemale == false
                                      ? Color(0xffD1D5DB)
                                      : Colors.white,
                                ),
                                label: Text(
                                  "Perempuan",
                                  style: TextStyle(
                                      fontFamily: "Nunito",
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                      color: isFemale == false
                                          ? Color(0xffD1D5DB)
                                          : Colors.white),
                                )),
                          )),
                        )
                      ]),

                      SizedBox(
                        height: 20,
                      ),
                      FormBuilderTextField(
                        name: 'jalan',
                        initialValue: jalan,
                        decoration: InputDecoration(
                          prefixIcon: Container(
                            padding: EdgeInsets.all(16),
                            child: SvgPicture.asset(
                              'assets/icon/arrow.svg',
                              color: Color(0xffD1D5DB),
                              height: 30,
                            ),
                          ),
                          labelText: 'Jalan',
                          labelStyle: TextPalette.hintTextStyle,
                        ),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(context),
                          FormBuilderValidators.min(context, 16),
                          FormBuilderValidators.maxLength(context, 16)
                        ]),
                        keyboardType: TextInputType.text,
                        onChanged: (ktpVal) {
                          setState(() {
                            noKtp = ktpVal!;
                          });
                        },
                      ),

                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        child: FormBuilderDropdown(
                          initialValue: provinsiId,
                          name: 'province',
                          decoration: InputDecoration(
                            prefixIcon: Container(
                              padding: EdgeInsets.all(16),
                              child: SvgPicture.asset(
                                'assets/icon/map.svg',
                                color: Color(0xffADB3BC),
                                height: 30,
                              ),
                            ),
                            labelStyle: TextPalette.hintTextStyle,
                          ),
                          allowClear: true,
                          hint: Text(
                            'Pilih Provinsi',
                            style: TextStyle(
                                fontFamily: "Nunito",
                                fontWeight: FontWeight.w700,
                                color: Color(0xffD1D5DB),
                                fontSize: 12,
                                fontStyle: FontStyle.normal),
                          ),
                          validator: FormBuilderValidators.compose(
                              [FormBuilderValidators.required(context)]),
                          items: listProvinsi
                              .map((e) => DropdownMenuItem(
                                  value: '${e.id}',
                                  child: Text(
                                    "${e.name}",
                                    style: TextStyle(
                                      color: Colors.grey[800],
                                    ),
                                  )))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              var isi = value.toString().split('-');
                              FocusScope.of(context)
                                  .requestFocus(new FocusNode());
                              var provinceName = isi[1];
                              var provinceId = isi[0];
                              listKoKab = masterRegion
                                  .where((element) =>
                                      element.level == 3 &&
                                      element.parent == provinceId)
                                  .toList();
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      //!  Kabupaten
                      FormBuilderDropdown(
                        name: 'district',
                        initialValue: widget.data!.city,
                        decoration: InputDecoration(
                          prefixIcon: Container(
                            padding: EdgeInsets.all(16),
                            child: SvgPicture.asset(
                              'assets/icon/building.svg',
                              color: Color(0xffADB3BC),
                            ),
                          ),
                          labelStyle: TextPalette.hintTextStyle,
                        ),
                        allowClear: true,
                        hint: Text(
                          'Pilih Kota / Kabupaten',
                          style: TextStyle(
                              fontFamily: "Nunito",
                              fontWeight: FontWeight.w700,
                              color: Color(0xffD1D5DB),
                              fontSize: 12,
                              fontStyle: FontStyle.normal),
                        ),
                        validator: FormBuilderValidators.compose(
                            [FormBuilderValidators.required(context)]),
                        items: listKoKab
                            .map((e) => DropdownMenuItem(
                                value: '${e.id}',
                                child: Text(
                                  "${e.name}",
                                  style: TextStyle(
                                    color: Colors.grey[800],
                                  ),
                                )))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            var isi = value.toString().split('-');
                            FocusScope.of(context)
                                .requestFocus(new FocusNode());
                            var cityName = isi[1];
                            var cityId = isi[0];
                            listKec = masterRegion
                                .where((element) =>
                                    element.level == 4 &&
                                    element.parent == cityId)
                                .toList();
                          });
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      //! Kecamatan
                      FormBuilderDropdown(
                        name: 'subdistrict',
                        initialValue: widget.data!.district,
                        decoration: InputDecoration(
                          prefixIcon: Container(
                            padding: EdgeInsets.all(16),
                            child: SvgPicture.asset(
                              'assets/icon/bank.svg',
                              color: Color(0xffADB3BC),
                              height: 30,
                            ),
                          ),
                          labelStyle: TextPalette.hintTextStyle,
                        ),
                        allowClear: true,
                        hint: Text(
                          'Pilih Kecamatan',
                          style: TextStyle(
                              fontFamily: "Nunito",
                              fontWeight: FontWeight.w700,
                              color: Color(0xffD1D5DB),
                              fontSize: 12,
                              fontStyle: FontStyle.normal),
                        ),
                        validator: FormBuilderValidators.compose(
                            [FormBuilderValidators.required(context)]),
                        items: listKec
                            .map((e) => DropdownMenuItem(
                                value: '${e.id}',
                                child: Text(
                                  "${e.name}",
                                  style: TextStyle(
                                    color: Colors.grey[800],
                                  ),
                                )))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            var isi = value.toString().split('-');
                            FocusScope.of(context)
                                .requestFocus(new FocusNode());
                            var districtName = isi[1];
                            var districtId = isi[0];
                            listKel = masterRegion
                                .where((element) =>
                                    element.level == 5 &&
                                    element.parent == districtId)
                                .toList();
                          });
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      //!  Kelurahan
                      FormBuilderDropdown(
                        name: 'ward',
                        decoration: InputDecoration(
                          prefixIcon: Container(
                            padding: EdgeInsets.all(16),
                            child: SvgPicture.asset(
                              'assets/icon/house.svg',
                              color: Color(0xffADB3BC),
                            ),
                          ),
                          labelStyle: TextPalette.hintTextStyle,
                        ),
                        initialValue: widget.data!.region,
                        allowClear: true,
                        hint: Text(
                          'Pilih Kelurahan',
                          style: TextStyle(
                              fontFamily: "Nunito",
                              fontWeight: FontWeight.w700,
                              color: Color(0xffD1D5DB),
                              fontSize: 12,
                              fontStyle: FontStyle.normal),
                        ),
                        validator: FormBuilderValidators.compose(
                            [FormBuilderValidators.required(context)]),
                        items: listKel
                            .map((e) => DropdownMenuItem(
                                value: '${e.id}',
                                child: Text(
                                  "${e.name}",
                                  style: TextStyle(
                                    color: Colors.grey[800],
                                  ),
                                )))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            var isi = value.toString().split('-');
                            FocusScope.of(context)
                                .requestFocus(new FocusNode());
                            var subdistrictName = isi[1];
                            kelurahanId = isi[0];
                          });
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      //!  Rt dan Rw
                      Row(children: [
                        Flexible(
                          //!RT
                          child: FormBuilderTextField(
                            name: 'rt',
                            initialValue: rt,
                            onChanged: (valRt) {
                              rt = valRt!;
                            },
                            decoration: InputDecoration(
                              prefixIcon: Container(
                                padding: EdgeInsets.all(16),
                                child: SvgPicture.asset(
                                  'assets/icon/location.svg',
                                  color: Color(0xffD1D5DB),
                                  height: 30,
                                ),
                              ),
                              labelText: 'RT',
                              labelStyle: TextPalette.hintTextStyle,
                            ),
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(context),
                            ]),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Flexible(
                          //!RW
                          child: FormBuilderTextField(
                            name: 'rw',
                            initialValue: rw,
                            onChanged: (valRw) {
                              rw = valRw!;
                            },
                            decoration: InputDecoration(
                              prefixIcon: Container(
                                padding: EdgeInsets.all(16),
                                child: SvgPicture.asset(
                                  'assets/icon/location.svg',
                                  color: Color(0xffD1D5DB),
                                  height: 30,
                                ),
                              ),
                              labelText: 'RW',
                              labelStyle: TextPalette.hintTextStyle,
                            ),
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(context),
                            ]),
                            keyboardType: TextInputType.number,
                          ),
                        )
                      ]),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xffF54748),
        onPressed: () {
          // final progress = ProgressHUD.of(context);

          // progress!.showWithText(
          //     GlobalConfiguration().getValue(GlobalVars.TEXT_LOADING_TITLE) ??
          //         StringResources.PLEASE_WAIT);

          FocusScope.of(context).requestFocus(new FocusNode());

          setState(() {
            if (isMale) {
              gender = "L";
            } else if (isFemale) {
              gender = "P";
            }

            itemProfile = PostProfile(
              idCard: noKtp,
              street: jalan,
              name: nama,
              gender: gender,
              subDistrict: kelurahanId,
              email: email,
              phone: noTelp,
              rt: rt,
              rw: rw,
              path: pathRes ?? '',
            );
          });

          BlocProvider.of<ProfileBloc>(context)
              .add(EditProfileEvent(profileEdit: itemProfile));
          // progress.dismiss();
        },
        child: SvgPicture.asset(
          "assets/icon/arrow-checklist.svg",
          color: Color(0xffFFFFFF),
        ),
      ),
    );
  }

  void alertFotoRes() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: Text(
              'Pilih Sumber Media',
              style: TextStyle(
                  fontFamily: "Nunito",
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  fontStyle: FontStyle.normal,
                  color: Colors.black),
            ),
            content: Container(
              height: 100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      getImageRes(ImageSource.gallery);
                    },
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.image,
                          color: Color(0xffE33A4E),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Dari Gallery',
                          style: TextStyle(
                              fontFamily: "Nunito",
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              fontStyle: FontStyle.normal,
                              color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      getImageRes(ImageSource.camera);
                      Navigator.pop(context);
                    },
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.camera, color: Color(0xffE33A4E)),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Dari Camera',
                          style: TextStyle(
                              fontFamily: "Nunito",
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              fontStyle: FontStyle.normal,
                              color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future<void> _thankYouPopup() {
    return CoolAlert.show(
        context: context,
        type: CoolAlertType.success,
        text: "Berhasil Update Data",
        confirmBtnText: 'Ok',
        onConfirmBtnTap: () async {
          int count = 0;
          Navigator.of(context).popUntil((_) => count++ >= 2);
        });
  }
}
