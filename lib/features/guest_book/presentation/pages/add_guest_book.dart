import 'dart:io';

import 'package:another_flushbar/flushbar_helper.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kmp_petugas_app/config/global_vars.dart';
import 'package:kmp_petugas_app/config/string_resources.dart';
import 'package:kmp_petugas_app/env.dart';
import 'package:kmp_petugas_app/features/dues/data/models/house_model.dart';
import 'package:kmp_petugas_app/features/guest_book/domain/entities/post_guest_book.dart';
import 'package:kmp_petugas_app/features/guest_book/presentation/bloc/bloc.dart';
import 'package:kmp_petugas_app/features/guest_book/presentation/bloc/guest_book_bloc.dart';
import 'package:kmp_petugas_app/framework/managers/helper.dart';
import 'package:kmp_petugas_app/theme/colors.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:uuid/uuid.dart';

class AddGuestBookScreen extends StatefulWidget {
  const AddGuestBookScreen({Key? key}) : super(key: key);

  @override
  _AddGuestBookScreenState createState() => _AddGuestBookScreenState();
}

class _AddGuestBookScreenState extends State<AddGuestBookScreen> {
  late PostGuestBook itemGustBook;

  String? idHouse;
  String? nameHouse;
  PageController pageController = PageController(initialPage: 0);
  final _formKey = GlobalKey<FormBuilderState>();
  TextEditingController nmTamuCtr = TextEditingController();
  TextEditingController jmTamuCtr = TextEditingController();
  TextEditingController nmrCtr = TextEditingController();
  TextEditingController keperluanCtr = TextEditingController();
  TextEditingController kepadaCtr = TextEditingController();
  double pagePosition = 0;
  File? imgRess;
  String? pathRes = '';
  File? imgSelf;
  String? pathSelf = '';
  List<Houses> listData = [];
  Houses? selectedHouses;
  bool isLoading = false;
  bool select = false;

  Houses? item;

  final ImagePicker _picker = ImagePicker();

  Future getImageRes(ImageSource media) async {
    var resultRes = await _picker.pickImage(source: media);

    if (resultRes != null) {
      setState(() {
        imgRess = File(resultRes.path);
        // imgRes = File(resultRes.path);
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

  Future getImageRest(ImageSource media) async {
    var resultRes = await _picker.pickImage(source: media);

    if (resultRes != null) {
      setState(() {
        imgSelf = File(resultRes.path);
        // imgRes = File(resultRes.path);
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
            pathSelf = targetPathRes;
          } else {
            pathSelf = resultRes.path;
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
    BlocProvider.of<GuestBookBloc>(context).add(AddLoadGuestBook());
    BlocProvider.of<GuestBookBloc>(context).add(LoadHouses());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _build(context);
  }

  Widget _build(BuildContext context) {
    return Scaffold(
      body: ProgressHUD(
        child: BlocListener<GuestBookBloc, GuestBookState>(
          listener: (context, state) async {
            if (state is GuestBookLoading) {
              final progress = ProgressHUD.of(context);
              progress?.showWithText(GlobalConfiguration()
                      .getValue(GlobalVars.TEXT_LOADING_TITLE) ??
                  StringResources.PLEASE_WAIT);
              setState(() {});
              //
            } else if (state is ProsesAdd) {
              final progress = ProgressHUD.of(context);
              progress?.showWithText(GlobalConfiguration()
                      .getValue(GlobalVars.TEXT_LOADING_TITLE) ??
                  StringResources.PLEASE_WAIT);
              setState(() {});
            } else if (state is HousesLoaded) {
              if (state.data != null && state.data.paginate!.docs!.length > 0) {
                listData = state.data.paginate!.docs!;
                isLoading = true;
                setState(() {});
              }
            } else if (state is GuestBookSuccess) {
              // int count = 0;
              // Navigator.of(context).popUntil((_) => count++ >= 1);
              _thankYouPopup();
            } else if (state is GuestBookFailure) {
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
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
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
                  BlocProvider.of<GuestBookBloc>(context).add(LoadGuestBook());
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
      body: FormBuilder(
        key: _formKey,
        child: Theme(
          data: ThemeData(
            inputDecorationTheme: InputDecorationTheme(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: Color(0xffCCCED3)),
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
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 25, top: 15),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Tambahkan Data Tamu",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontFamily: "Nunito",
                                fontWeight: FontWeight.w800,
                                fontStyle: FontStyle.normal,
                                fontSize: 22,
                                color: Colors.black),
                          ),
                          Text(
                            "Masukkan identitas tamu",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontFamily: "Nunito",
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.normal,
                                fontSize: 12,
                                color: Color(0xff979797)),
                          ),
                        ]),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 25, right: 25, top: 35),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //!Nama Tamu
                      FormBuilderTextField(
                        name: 'nmTamu',
                        controller: nmTamuCtr,
                        decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 20.0),
                          prefixIcon: Container(
                            padding: EdgeInsets.all(10),
                            child: SvgPicture.asset(
                              'assets/icon/user.svg',
                              height: 28,
                              width: 22,
                              color: Color(0xffD1D5DB),
                            ),
                          ),
                          labelText: 'Nama Tamu',
                          hintStyle: TextStyle(
                              fontFamily: "Nunito",
                              fontSize: 13,
                              color: Colors.black,
                              fontWeight: FontWeight.w700),
                          labelStyle: TextPalette.hintTextStyle,
                        ),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(context),
                        ]),
                        keyboardType: TextInputType.text,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      //!jumlah tamu
                      FormBuilderTextField(
                        name: 'jmTamu',
                        controller: jmTamuCtr,
                        decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 20.0),
                          prefixIcon: Container(
                            padding: EdgeInsets.all(10),
                            child: SvgPicture.asset(
                              'assets/icon/user.svg',
                              height: 28,
                              width: 22,
                              color: Color(0xffD1D5DB),
                            ),
                          ),
                          labelText: 'Jumlah Tamu',
                          hintStyle: TextStyle(
                              fontFamily: "Nunito",
                              fontSize: 13,
                              color: Colors.black,
                              fontWeight: FontWeight.w700),
                          labelStyle: TextPalette.hintTextStyle,
                        ),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(context),
                        ]),
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      DropdownSearch<Houses>(
                        popupTitle: Container(
                          margin: EdgeInsets.only(left: 10, top: 5, bottom: 5),
                          child: Text(
                            "Pilih Rumah",
                            style: TextStyle(
                                fontFamily: "Nunito",
                                fontWeight: FontWeight.w800,
                                fontStyle: FontStyle.normal,
                                fontSize: 18,
                                color: Colors.black),
                          ),
                        ),
                        mode: Mode.BOTTOM_SHEET,
                        showSearchBox: true,
                        dropdownBuilder: _customDropDownExample,
                        popupItemBuilder: _customPopupItemBuilderExample2,
                        isFilteredOnline: true,
                        onFind: (a) {
                          return getData(a);
                        },
                        onChanged: (val) {
                          print(val!.citizenName);
                          print(val.id);
                          idHouse = val.id;
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      FormBuilderTextField(
                        name: 'nowa',
                        controller: nmrCtr,
                        decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 20.0),
                          prefixIcon: Container(
                            padding: EdgeInsets.all(10),
                            child: SvgPicture.asset(
                              'assets/icon/phone.svg',
                              height: 28,
                              width: 17,
                              color: Color(0xffD1D5DB),
                            ),
                          ),
                          labelText: 'Nomor Telepon',
                          hintStyle: TextStyle(
                              fontFamily: "Nunito",
                              fontSize: 13,
                              color: Colors.black,
                              fontWeight: FontWeight.w700),
                          labelStyle: TextPalette.hintTextStyle,
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: 130,
                        color: Colors.transparent,
                        child: Column(
                          children: [
                            FormBuilderTextField(
                              maxLines: 5,
                              controller: keperluanCtr,
                              name: 'keperluan',
                              decoration:
                                  InputDecoration(labelText: "Keperluan"),
                              keyboardType: TextInputType.text,
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(context),
                              ]),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: InkWell(
                          onTap: () {
                            alertFotoRes();
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: Colors.white),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8, right: 8),
                              child: Row(
                                children: [
                                  imgRess == null
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
                                            imgRess!,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Container(
                                    width: imgRess == null ? 190 : 150,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Foto KTP",
                                          style: TextStyle(
                                              fontFamily: "Nunito",
                                              fontWeight: FontWeight.w700,
                                              fontStyle: FontStyle.normal,
                                              fontSize: 16,
                                              color: Colors.black),
                                        ),
                                        Text(
                                          "Tambahkan foto KTP",
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
                                  imgRess == null
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
                      Padding(
                        padding: const EdgeInsets.only(bottom: 27),
                        child: InkWell(
                          onTap: () {
                            alertFotoRest();
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: Colors.white),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8, right: 8),
                              child: Row(
                                children: [
                                  imgSelf == null
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
                                            imgSelf!,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Container(
                                    width: imgSelf == null ? 190 : 150,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Foto Selfi",
                                          style: TextStyle(
                                              fontFamily: "Nunito",
                                              fontWeight: FontWeight.w700,
                                              fontStyle: FontStyle.normal,
                                              fontSize: 16,
                                              color: Colors.black),
                                        ),
                                        Text(
                                          "Tambahkan foto Selfi",
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
                                  imgSelf == null
                                      ? IconButton(
                                          onPressed: () {
                                            alertFotoRest();
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
                                                  alertFotoRest();
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
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final progress = ProgressHUD.of(context);

              progress!.showWithText(GlobalConfiguration()
                      .getValue(GlobalVars.TEXT_LOADING_TITLE) ??
                  StringResources.PLEASE_WAIT);

              FocusScope.of(context).requestFocus(new FocusNode());

              setState(() {
                itemGustBook = PostGuestBook(
                    name: nmTamuCtr.text,
                    phone: nmrCtr.text,
                    necessity: keperluanCtr.text,
                    guestCount: int.parse(jmTamuCtr.text),
                    destinationPersonName: nmTamuCtr.text,
                    house: idHouse.toString(),
                    path: pathRes,
                    pathself: pathSelf);
              });

              BlocProvider.of<GuestBookBloc>(context)
                  .add(AddGuestBookEvent(guestBook: itemGustBook));
              progress.dismiss();
            } else {
              final progress = ProgressHUD.of(context);
              progress!.showWithText(GlobalConfiguration()
                      .getValue(GlobalVars.TEXT_LOADING_TITLE) ??
                  StringResources.PLEASE_WAIT);
              progress.dismiss();
              FlushbarHelper.createError(
                  message: "Harap Lengkapi Form diatas",
                  title: "Warning",
                  duration: Duration(seconds: 3))
                ..show(context);
            }
          },
          backgroundColor: ColorPalette.primary,
          child: SvgPicture.asset(
            "assets/icon/arrow-checklist.svg",
            color: Colors.white,
          )),
    );
  }

  Future<void> _thankYouPopup() {
    return CoolAlert.show(
        context: context,
        type: CoolAlertType.success,
        text: "Data berhasil dikirim",
        confirmBtnText: 'Ok',
        onConfirmBtnTap: () async {
          // context.pushReplacement(SuccessGuestBook());
          // Navigator.pop(context);
          int count = 0;
          Navigator.of(context).popUntil((_) => count++ >= 2);
        });
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

  void alertFotoRest() {
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
                      getImageRest(ImageSource.gallery);
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
                      getImageRest(ImageSource.camera);
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

  Widget _customDropDownExample(BuildContext context, Houses? item) {
    if (item == null) {
      return Container(
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              child: SvgPicture.asset(
                'assets/icon/user.svg',
                height: 28,
                width: 22,
                color: Color(0xffD1D5DB),
              ),
            ),
            Text(
              'Tujuan',
              style: TextStyle(
                  fontFamily: "Nunito",
                  fontSize: 13,
                  color: Color(0xffD1D5DB),
                  fontWeight: FontWeight.w700),
            ),
          ],
        ),
      );
    }

    return Container(
      child: (item.citizenName == null)
          ? ListTile(
              contentPadding: EdgeInsets.all(0),
              title: Text("No item selected"),
            )
          : Container(
              height: 68,
              child: ListTile(
                contentPadding: EdgeInsets.all(0),
                title: Text(
                  item.citizenName!,
                  style: TextStyle(
                      fontFamily: "Nunito",
                      fontWeight: FontWeight.w800,
                      fontStyle: FontStyle.normal,
                      fontSize: 18,
                      color: Colors.black),
                ),
                subtitle: Text(
                  item.houseBlock! + '-' + item.houseNumber!,
                  style: TextStyle(
                      fontFamily: "Nunito",
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      fontSize: 14,
                      color: Colors.black),
                ),
              ),
            ),
    );
  }

  Widget _customPopupItemBuilderExample2(
      BuildContext context, Houses? item, bool isSelected) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      decoration: !isSelected
          ? null
          : BoxDecoration(
              border: Border.all(color: Theme.of(context).primaryColor),
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
            ),
      child: Card(
        margin: EdgeInsets.only(top: 10, left: 10, right: 10),
        child: ListTile(
          selected: isSelected,
          title: Text(item?.citizenName ?? ''),
          subtitle: Text(item?.houseBlock ?? ''),
        ),
      ),
    );
  }

  Future<List<Houses>> getData(filter) async {
    // print(filter);
    var result = listData
        .where((element) => element.citizenName!
            .toString()
            .toLowerCase()
            .contains(filter.toLowerCase()))
        .toList();
    if (result != null && result.length > 0) {
      return result;
    }
    return listData;
  }
}
