import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:grouped_list/sliver_grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:kmp_petugas_app/config/global_vars.dart';
import 'package:kmp_petugas_app/config/string_resources.dart';
import 'package:kmp_petugas_app/features/authentication/data/models/user_model.dart';
import 'package:kmp_petugas_app/features/financial/data/models/cash_book_model.dart';
import 'package:kmp_petugas_app/features/financial/data/models/month.dart';
import 'package:kmp_petugas_app/features/financial/data/models/year.dart';

import 'package:kmp_petugas_app/features/financial/presentation/bloc/bloc.dart';
import 'package:kmp_petugas_app/framework/managers/helper.dart';
import 'package:kmp_petugas_app/framework/widgets/loading_indicator.dart';
import 'package:kmp_petugas_app/theme/button.dart';

import 'package:kmp_petugas_app/theme/colors.dart';
import 'package:kmp_petugas_app/theme/enum.dart';
import 'package:kmp_petugas_app/theme/size.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';

class FinancialStatementScreen extends StatefulWidget {
  final int? month;
  final int? year;

  const FinancialStatementScreen({Key? key, this.month, this.year})
      : super(key: key);

  @override
  _FinancialStatementScreenState createState() =>
      _FinancialStatementScreenState();
}

class _FinancialStatementScreenState extends State<FinancialStatementScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool isLoading = false;
  bool lunas = false;
  bool belumLunas = false;
  bool semua = true;
  bool pemasukan = false;
  bool pengeluaran = false;

  int? month;
  int? year;
  List<MonthData> listMonth = [
    MonthData(name: 'Januari', value: 1),
    MonthData(name: 'Febuari', value: 2),
    MonthData(name: 'Maret', value: 3),
    MonthData(name: 'April', value: 4),
    MonthData(name: 'Mei', value: 5),
    MonthData(name: 'Juni', value: 6),
    MonthData(name: 'Juli', value: 7),
    MonthData(name: 'Agustus', value: 8),
    MonthData(name: 'September', value: 9),
    MonthData(name: 'Oktober', value: 10),
    MonthData(name: 'November', value: 11),
    MonthData(name: 'Desember', value: 12)
  ];
  List<YearData> listYear = [
    YearData(name: '2021', value: 2021),
    YearData(name: '2022', value: 2022),
    YearData(name: '2023', value: 2023),
    YearData(name: '2024', value: 2024),
  ];
  List<String> listNama = [];
  final List<Map<String, dynamic>> daftar = [
    {"nama": "RT 01", "ketua": "Pak Maulana", "isChecked": false},
    {"nama": "RT 02", "ketua": "Pak Davit", "isChecked": false},
    {"nama": "RT 04", "ketua": "Pak Ardy", "isChecked": false},
    {"nama": "RT 03", "ketua": "Pak Amir", "isChecked": false},
    {"nama": "RT 05", "ketua": "Ibu Alfi", "isChecked": false},
    {"nama": "RT 08", "ketua": "Pak Joko", "isChecked": false},
    {"nama": "RT 07", "ketua": "Pak Andri", "isChecked": false},
    {"nama": "RT 09", "ketua": "Ibu Zahra", "isChecked": false},
  ];
  Total? listTotal;
  List<Report> listCashbook = [];
  List<Report> listPemasukan = [];
  List<Report> listPengeluaran = [];
  UserModel? session;
  Officer? off;
  String nama = '';
  String rt = '';
  String rw = '';

  int? bulanstart;
  int? tahunstart;
  int? bulanend;
  int? tahunend;
  String? tipe;
  bool isPaid = false;
  //
  String? getbulanstart;
  String? gettahunstart;
  String? getbulanend;
  String? gettahunend;
  String? gettipe;
  int getpaid = 0;
  int getunpaid = 0;
  bool getisPaid = true;

  @override
  void initState() {
    super.initState();

    month = widget.month;
    year = widget.year;

    bulanstart = DateTime.now().month;
    tahunstart = DateTime.now().year;
    bulanend = DateTime.now().month;
    tahunend = DateTime.now().year;
    tipe = 'all';

    listCashbook.clear();
    listPemasukan.clear();
    listPengeluaran.clear();

    BlocProvider.of<FinancialStatementBloc>(context).add(GetSessionEvent());
    BlocProvider.of<FinancialStatementBloc>(context).add(
        GetCashBookFinancialEvent(
            yearstart: tahunstart,
            monthstrat: bulanstart,
            monthend: bulanend,
            yearend: tahunend,
            type: tipe,
            ispaid: isPaid));
  }

  @override
  Widget build(BuildContext context) {
    return _build(context);
  }

  Widget _build(BuildContext context) {
    return BlocListener<FinancialStatementBloc, FinancialStatementState>(
      listener: (context, state) async {
        if (state is CashBookFinancialLoading) {
          // final progress = ProgressHUD.of(context);
          // progress?.showWithText(
          //     GlobalConfiguration().getValue(GlobalVars.TEXT_LOADING_TITLE) ??
          //         StringResources.PLEASE_WAIT);
          setState(() {});
          //
        } else if (state is CashBookFinancialLoaded) {
          final progress = ProgressHUD.of(context);
          if (state.data!.reports!.length > 0 && state.data!.total != null) {
            listCashbook = state.data!.reports!;
            listTotal = state.data!.total!;

            isLoading = true;
            setState(() {});
          }
          progress!.dismiss();
        } else if (state is SessionLoaded) {
          setState(() {
            if (state.data != null) {
              session = state.data;
              off = state.data!.officer;
              nama = session!.name.toString();
              rt = off!.rt.toString();
              rw = off!.rw.toString();
              print(nama);
            }
          });
        } else if (state is GetPdfReportLoaded) {
          OpenFile.open(state.data);
        } else if (state is FinancialStatementFailure) {
          catchAllException(context, state.error, true);
          setState(() {});
        }
      },
      child: isLoading ? _buildBody(context) : LoadingIndicator(),
    );
  }

  Widget _buildBody(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool small = false;
    if (size.width <= 320) {
      small = true;
    }
    print(small);
    return Scaffold(
      backgroundColor: Color(0xffF54748),
      appBar: AppBar(
        toolbarHeight: 70,
        elevation: 0,
        backgroundColor: Color(0xffF54748),
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.only(
            left: 5,
            right: 5,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Transaksi Iuran",
                style: TextStyle(
                    fontFamily: "Nunito",
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                    color: Colors.white),
              ),
              Container(
                height: 27,
                width: 65,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(21),
                    color: Colors.black.withOpacity(0.1)),
                child: Container(
                  padding: EdgeInsets.only(left: 5),
                  child: Center(
                      child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Theme(
                            data: Theme.of(context).copyWith(
                              canvasColor: Color(0xffDD4041),
                            ),
                            child: DropdownButton<int>(
                              value: tahunstart,
                              icon: SvgPicture.asset(
                                  "assets/icon/arrow-down.svg"),
                              iconSize: 24,
                              underline: Container(
                                height: 2,
                              ),
                              onChanged: (int? newValue) {
                                setState(() {
                                  tahunstart = newValue!;
                                  printWarning(tahunstart);
                                  listCashbook.clear();
                                  listPemasukan.clear();
                                  listPengeluaran.clear();

                                  final progress = ProgressHUD.of(context);

                                  progress!.showWithText(GlobalConfiguration()
                                          .getValue(
                                              GlobalVars.TEXT_LOADING_TITLE) ??
                                      StringResources.PLEASE_WAIT);

                                  FocusScope.of(context)
                                      .requestFocus(new FocusNode());

                                  BlocProvider.of<FinancialStatementBloc>(
                                          context)
                                      .add(GetCashBookFinancialEvent(
                                          yearstart: tahunstart,
                                          monthstrat: bulanstart,
                                          yearend: tahunstart,
                                          monthend: bulanstart,
                                          type: tipe,
                                          ispaid: isPaid));
                                  // progress.dismiss();
                                });
                              },
                              items: listYear
                                  .map((e) => DropdownMenuItem(
                                      value: e.value,
                                      child: Text(
                                        "${e.name}",
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                            fontFamily: "Nunito"),
                                      )))
                                  .toList(),
                            ),
                          ))),
                ),
              ),
              Container(
                height: 27,
                width: 100,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(21),
                    color: Colors.black.withOpacity(0.1)),
                child: Container(
                  padding: EdgeInsets.only(left: 10),
                  child: Center(
                      child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Theme(
                            data: Theme.of(context).copyWith(
                              canvasColor: Color(0xffDD4041),
                            ),
                            child: DropdownButton<int>(
                              value: bulanstart,
                              icon: SvgPicture.asset(
                                  "assets/icon/arrow-down.svg"),
                              iconSize: 24,
                              underline: Container(
                                height: 2,
                              ),
                              onChanged: (int? newValue) {
                                setState(() {
                                  bulanstart = newValue!;
                                  printWarning(bulanstart);
                                  listCashbook.clear();
                                  listPemasukan.clear();
                                  listPengeluaran.clear();

                                  final progress = ProgressHUD.of(context);

                                  // progress!.showWithText(GlobalConfiguration()
                                  //         .getValue(
                                  //             GlobalVars.TEXT_LOADING_TITLE) ??
                                  //     StringResources.PLEASE_WAIT);

                                  FocusScope.of(context)
                                      .requestFocus(new FocusNode());

                                  BlocProvider.of<FinancialStatementBloc>(
                                          context)
                                      .add(GetCashBookFinancialEvent(
                                          yearstart: tahunstart,
                                          monthstrat: bulanstart,
                                          yearend: tahunstart,
                                          monthend: bulanstart,
                                          type: tipe,
                                          ispaid: isPaid));
                                  // progress.dismiss();
                                });
                              },
                              items: listMonth
                                  .map((e) => DropdownMenuItem(
                                      value: e.value,
                                      child: Text(
                                        "${e.name}",
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                            fontFamily: "Nunito"),
                                      )))
                                  .toList(),
                            ),
                          ))),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SizedBox(
          child: Stack(
        children: <Widget>[
          // bagian atas
          Column(
            children: [
              // Container(
              //   padding: EdgeInsets.only(left: 20, right: 20),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       Text(
              //         nama,
              //         style: TextStyle(
              //             fontSize: 15,
              //             color: Colors.white,
              //             fontWeight: FontWeight.w700,
              //             fontFamily: "Nunito"),
              //       ),
              //       Container()
              //     ],
              //   ),
              // ),
              // Container(
              //   padding: EdgeInsets.only(left: 20, right: 20),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       Text(
              //         "RT ${rt.toString()} / RW ${rw.toString()}",
              //         style: TextStyle(
              //             fontSize: 13,
              //             color: Colors.white,
              //             fontWeight: FontWeight.w700,
              //             fontFamily: "Nunito"),
              //       ),
              //       Container()
              //     ],
              //   ),
              // ),

              Container(
                padding: EdgeInsets.only(left: 20, right: 20, top: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total Lunas",
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontFamily: "Nunito"),
                    ),
                    Container(
                      child: listTotal == null
                          ? Text(
                              NumberFormat.currency(
                                      locale: 'id',
                                      symbol: 'Rp. ',
                                      decimalDigits: 0)
                                  .format(0),
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  fontFamily: "Nunito"),
                            )
                          : Text(
                              NumberFormat.currency(
                                      locale: 'id',
                                      symbol: 'Rp. ',
                                      decimalDigits: 0)
                                  .format(listTotal!.paid),
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  fontFamily: "Nunito"),
                            ),
                    )
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 20, right: 20, top: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total Belum Lunas ",
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontFamily: "Nunito"),
                    ),
                    Container(
                      child: listTotal == null
                          ? Text(
                              NumberFormat.currency(
                                      locale: 'id',
                                      symbol: 'Rp. ',
                                      decimalDigits: 0)
                                  .format(0),
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  fontFamily: "Nunito"),
                            )
                          : Text(
                              NumberFormat.currency(
                                      locale: 'id',
                                      symbol: 'Rp. ',
                                      decimalDigits: 0)
                                  .format(listTotal!.unpaid),
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  fontFamily: "Nunito"),
                            ),
                    )
                  ],
                ),
              ),
              Container(
                padding:
                    EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 10),
                child: KmpFlatButton(
                    onPressed: () async {
                      var result = await showModalBottomSheet(
                          useRootNavigator: true,
                          isScrollControlled: true,
                          context: context,
                          // builder:
                          builder: (context) {
                            return StatefulBuilder(builder:
                                (BuildContext context, StateSetter setState) {
                              return Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.7,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 25, vertical: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Download Laporan',
                                            style: TextStyle(
                                                fontFamily: "Nunito",
                                                fontWeight: FontWeight.w700,
                                                fontSize: 18,
                                                fontStyle: FontStyle.normal,
                                                color: Colors.black)),
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              lunas = false;
                                              belumLunas = false;
                                            });
                                            Navigator.pop(context);
                                          },
                                          child: Container(
                                            height: 28,
                                            width: 28,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(14),
                                                color: Colors.white),
                                            child: Icon(Icons.close),
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 20),
                                    Container(
                                      height: Screen(size).wp(80),
                                      child: ListView(
                                        shrinkWrap: true,
                                        children: [
                                          FormBuilder(
                                              key: _formKey,
                                              child: Theme(
                                                  data: ThemeData(
                                                    inputDecorationTheme:
                                                        InputDecorationTheme(
                                                      contentPadding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 20,
                                                              vertical: 10),
                                                      errorBorder: OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                              width: 1,
                                                              color: Colors
                                                                  .transparent),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      16)),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          width: 3,
                                                          color: Colors
                                                              .transparent,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(16),
                                                      ),
                                                      focusedErrorBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          width: 3,
                                                          color: Colors
                                                              .transparent,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(16),
                                                      ),
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          width: 3,
                                                          color: Colors
                                                              .transparent,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(16),
                                                      ),
                                                      hintStyle: TextStyle(
                                                          color: Color(
                                                              0xffD1D5DB)),
                                                      labelStyle: TextStyle(
                                                          color: Color(
                                                              0xffD1D5DB)),
                                                      errorStyle: TextStyle(
                                                          color: ColorPalette
                                                              .primary),
                                                      filled: true,
                                                      fillColor:
                                                          Color(0xffE5E5E5)
                                                              .withOpacity(0.5),
                                                      floatingLabelBehavior:
                                                          FloatingLabelBehavior
                                                              .never,
                                                    ),
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text('Dari',
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  "Nunito",
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              fontSize: 13,
                                                              fontStyle:
                                                                  FontStyle
                                                                      .normal,
                                                              color: Colors
                                                                  .black)),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Container(
                                                              width:
                                                                  Screen(size)
                                                                      .wp(40),
                                                              child:
                                                                  FormBuilderDropdown(
                                                                name:
                                                                    'yearStart',
                                                                onChanged:
                                                                    (val) {
                                                                  setState(() {
                                                                    gettahunstart =
                                                                        val.toString();
                                                                    printWarning(
                                                                        gettahunstart);
                                                                  });
                                                                },
                                                                decoration:
                                                                    InputDecoration(),
                                                                hint: Text(
                                                                  'Pilih Tahun',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          13,
                                                                      color: Colors
                                                                          .black
                                                                          .withOpacity(
                                                                              0.8),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700,
                                                                      fontFamily:
                                                                          "Nunito"),
                                                                ),
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        "Nunito",
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700),
                                                                validator:
                                                                    FormBuilderValidators
                                                                        .compose([
                                                                  FormBuilderValidators
                                                                      .required(
                                                                          context)
                                                                ]),
                                                                items: listYear
                                                                    .map((e) =>
                                                                        DropdownMenuItem(
                                                                            value:
                                                                                e.value,
                                                                            child: Text(
                                                                              "${e.name}",
                                                                              style: TextStyle(fontSize: 13, color: Colors.black.withOpacity(0.8), fontWeight: FontWeight.w700, fontFamily: "Nunito"),
                                                                            )))
                                                                    .toList(),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 15,
                                                            ),
                                                            Container(
                                                              width:
                                                                  Screen(size)
                                                                      .wp(40),
                                                              child:
                                                                  FormBuilderDropdown(
                                                                name:
                                                                    'monthStart',
                                                                onChanged:
                                                                    (val) {
                                                                  setState(() {
                                                                    getbulanstart =
                                                                        val.toString();
                                                                    printWarning(
                                                                        getbulanstart);
                                                                  });
                                                                },
                                                                decoration:
                                                                    InputDecoration(),
                                                                hint: Text(
                                                                  'Pilih Bulan',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          13,
                                                                      color: Colors
                                                                          .black
                                                                          .withOpacity(
                                                                              0.8),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700,
                                                                      fontFamily:
                                                                          "Nunito"),
                                                                ),
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        "Nunito",
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700),
                                                                validator:
                                                                    FormBuilderValidators
                                                                        .compose([
                                                                  FormBuilderValidators
                                                                      .required(
                                                                          context)
                                                                ]),
                                                                items: listMonth
                                                                    .map((e) =>
                                                                        DropdownMenuItem(
                                                                            value:
                                                                                e.value,
                                                                            child: Text(
                                                                              "${e.name}",
                                                                              style: TextStyle(fontSize: 13, color: Colors.black.withOpacity(0.8), fontWeight: FontWeight.w700, fontFamily: "Nunito"),
                                                                            )))
                                                                    .toList(),
                                                              ),
                                                            )
                                                          ]),
                                                      SizedBox(height: 10),
                                                      Divider(),
                                                      SizedBox(height: 10),
                                                      Text('Sampai',
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  "Nunito",
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              fontSize: 13,
                                                              fontStyle:
                                                                  FontStyle
                                                                      .normal,
                                                              color: Colors
                                                                  .black)),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Container(
                                                              width:
                                                                  Screen(size)
                                                                      .wp(40),
                                                              child:
                                                                  FormBuilderDropdown(
                                                                name: 'yearEnd',
                                                                onChanged:
                                                                    (val) {
                                                                  setState(() {
                                                                    gettahunend =
                                                                        val.toString();
                                                                    printWarning(
                                                                        gettahunend);
                                                                  });
                                                                },
                                                                decoration:
                                                                    InputDecoration(),
                                                                hint: Text(
                                                                  'Pilih Tahun',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          13,
                                                                      color: Colors
                                                                          .black
                                                                          .withOpacity(
                                                                              0.8),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700,
                                                                      fontFamily:
                                                                          "Nunito"),
                                                                ),
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        "Nunito",
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700),
                                                                validator:
                                                                    FormBuilderValidators
                                                                        .compose([
                                                                  FormBuilderValidators
                                                                      .required(
                                                                          context)
                                                                ]),
                                                                items: listYear
                                                                    .map((e) =>
                                                                        DropdownMenuItem(
                                                                            value:
                                                                                e.value,
                                                                            child: Text(
                                                                              "${e.name}",
                                                                              style: TextStyle(fontSize: 13, color: Colors.black.withOpacity(0.8), fontWeight: FontWeight.w700, fontFamily: "Nunito"),
                                                                            )))
                                                                    .toList(),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 15,
                                                            ),
                                                            Container(
                                                              width:
                                                                  Screen(size)
                                                                      .wp(40),
                                                              child:
                                                                  FormBuilderDropdown(
                                                                name:
                                                                    'monthEnd',
                                                                onChanged:
                                                                    (val) {
                                                                  setState(() {
                                                                    getbulanend =
                                                                        val.toString();
                                                                    printWarning(
                                                                        getbulanend);
                                                                  });
                                                                },
                                                                decoration:
                                                                    InputDecoration(),
                                                                hint: Text(
                                                                  'Pilih Bulan',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          13,
                                                                      color: Colors
                                                                          .black
                                                                          .withOpacity(
                                                                              0.8),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700,
                                                                      fontFamily:
                                                                          "Nunito"),
                                                                ),
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        "Nunito",
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700),
                                                                validator:
                                                                    FormBuilderValidators
                                                                        .compose([
                                                                  FormBuilderValidators
                                                                      .required(
                                                                          context)
                                                                ]),
                                                                items: listMonth
                                                                    .map((e) =>
                                                                        DropdownMenuItem(
                                                                            value:
                                                                                e.value,
                                                                            child: Text(
                                                                              "${e.name}",
                                                                              style: TextStyle(fontSize: 13, color: Colors.black.withOpacity(0.8), fontWeight: FontWeight.w700, fontFamily: "Nunito"),
                                                                            )))
                                                                    .toList(),
                                                              ),
                                                            )
                                                          ]),
                                                    ],
                                                  ))),
                                          SizedBox(height: 10),
                                          Divider(),
                                          SizedBox(height: 10),
                                          Text('Status Iuran',
                                              style: TextStyle(
                                                  fontFamily: "Nunito",
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 13,
                                                  fontStyle: FontStyle.normal,
                                                  color: Colors.black)),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Row(children: [
                                            Container(
                                              height: 50,
                                              child: InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      lunas = !lunas;
                                                      if (gettipe != 'paid') {
                                                        gettipe = 'paid';
                                                        belumLunas = false;
                                                      } else {}
                                                    });
                                                    print(gettipe);
                                                  },
                                                  child: Container(
                                                      height: 50,
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.4,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(16),
                                                          color: lunas == false
                                                              ? Color(0xffE5E5E5)
                                                                  .withOpacity(
                                                                      0.5)
                                                              : Color(0xff58C863)
                                                                  .withOpacity(
                                                                      0.5)),
                                                      child: Center(
                                                        child: Text(
                                                          "Lunas",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  "Nunito",
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              fontSize: 14,
                                                              color: lunas ==
                                                                      false
                                                                  ? Colors.black
                                                                      .withOpacity(
                                                                          0.8)
                                                                  : Colors
                                                                      .white),
                                                        ),
                                                      ))),
                                            ),
                                            SizedBox(
                                              width: 15,
                                            ),
                                            Container(
                                              height: 50,
                                              child: InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      belumLunas = !belumLunas;
                                                      if (gettipe != 'unpaid') {
                                                        gettipe = 'unpaid';
                                                        lunas = false;
                                                      } else {}
                                                    });
                                                    print(gettipe);
                                                  },
                                                  child: Container(
                                                      height: 50,
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.4,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(16),
                                                          color: belumLunas ==
                                                                  false
                                                              ? Color(0xffE5E5E5)
                                                                  .withOpacity(
                                                                      0.5)
                                                              : Color(0xffE33A4E)
                                                                  .withOpacity(
                                                                      0.5)),
                                                      child: Center(
                                                        child: Text(
                                                          "Belum Lunas",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  "Nunito",
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              fontSize: 14,
                                                              color: belumLunas ==
                                                                      false
                                                                  ? Colors.black
                                                                      .withOpacity(
                                                                          0.8)
                                                                  : Colors
                                                                      .white),
                                                        ),
                                                      ))),
                                            )
                                          ]),
                                          SizedBox(height: 10),
                                          Divider(),
                                          SizedBox(height: 10),
                                          Text("Pilih RT",
                                              style: TextStyle(
                                                  fontFamily: "Nunito",
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 13,
                                                  fontStyle: FontStyle.normal,
                                                  color: Colors.black)),
                                          SizedBox(height: 10),
                                          Container(
                                            height: 50,
                                            child: ListView.builder(
                                              // shrinkWrap: true,
                                              itemCount: daftar.length,
                                              scrollDirection: Axis.horizontal,
                                              itemBuilder: (context, index) {
                                                final item = daftar[index];

                                                return InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      item['isChecked'] =
                                                          !item['isChecked'];
                                                      this.onchange(
                                                          item['nama'],
                                                          item['isChecked']);
                                                    });
                                                  },
                                                  child: Container(
                                                    padding: EdgeInsets.only(
                                                        left: 8, right: 8),
                                                    margin: EdgeInsets.only(
                                                        right: 10),
                                                    height: 50,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                        color: item['isChecked'] ==
                                                                true
                                                            ? Color(0xff58C863)
                                                                .withOpacity(
                                                                    0.5)
                                                            : Color(
                                                                0xffE5E5E5)),
                                                    child: Center(
                                                      child: Text(
                                                        item['nama'],
                                                        style: TextStyle(
                                                          fontFamily: "Nunito",
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontSize: 13,
                                                          color:
                                                              item['isChecked'] ==
                                                                      true
                                                                  ? Colors.white
                                                                  : Colors
                                                                      .black,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(child: SizedBox()),
                                    KmpFlatButton(
                                      fullWidth: true,
                                      buttonType: ButtonType.primary,
                                      onPressed: () async {
                                        var status =
                                            await Permission.storage.status;

                                        if (!status.isGranted) {
                                          await Permission.storage.request();
                                        }
                                        var data = GetPdfReportEvent(
                                            yearstart:
                                                int.parse(gettahunstart!),
                                            monthstrat:
                                                int.parse(getbulanstart!),
                                            monthend: int.parse(getbulanend!),
                                            yearend: int.parse(gettahunend!),
                                            type: gettipe,
                                            ispaid: getisPaid);
                                        Navigator.pop(context, data);
                                      },
                                      title: 'Download',
                                    ),
                                    SizedBox(height: 10),
                                  ],
                                ),
                              );
                            });
                          });
                      if (result != null) {
                        BlocProvider.of<FinancialStatementBloc>(context)
                            .add(result);
                      }
                    },
                    fullWidth: true,
                    buttonType: ButtonType.secondary,
                    title: "Unduh Laporan"),
              )
            ],
          ),
          // bagian bawah
          SizedBox.expand(
            child: DraggableScrollableSheet(
              initialChildSize: 0.7,
              minChildSize: 0.7,
              maxChildSize: 1,
              builder: (BuildContext c, s) {
                return Container(
                  padding: EdgeInsets.only(bottom: 65),
                  color: Color(0xffF8F8F8),
                  child: CustomScrollView(
                    controller: s,
                    slivers: <Widget>[
                      SliverAppBar(
                        // bottom: PreferredSize(
                        //   preferredSize: Size.fromHeight(10.0),
                        //   child: Container(),
                        // ),
                        backgroundColor: Color(0xffF8F8F8),
                        elevation: 0,
                        pinned: true,
                        automaticallyImplyLeading: false,
                        flexibleSpace: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: SvgPicture.asset("assets/icon/line.svg"),
                            ),
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: Container(
                                padding: EdgeInsets.only(left: 25, top: 15),
                                child: Text(
                                  "Daftar Transaksi Iuran",
                                  style: TextStyle(
                                      fontFamily: "Nunito",
                                      fontWeight: FontWeight.w800,
                                      fontSize: 16,
                                      fontStyle: FontStyle.normal,
                                      color: Colors.black.withOpacity(0.8)),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SliverGroupedListView<dynamic, String>(
                        elements: listCashbook,
                        groupBy: (element) => element.periodName,
                        groupComparator: (value1, value2) =>
                            value2.compareTo(value1),
                        itemComparator: (item1, item2) =>
                            item1.paidName.compareTo(item2.paidName),
                        order: GroupedListOrder.DESC,
                        groupSeparatorBuilder: (String value) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            value,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                                fontFamily: "Nunito"),
                          ),
                        ),
                        itemBuilder: (c, element) {
                          return InkWell(
                            onTap: () {},
                            child: Center(
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 15, right: 15),
                                child: Column(
                                  children: [
                                    Container(
                                      height: 60,
                                      child: listCashbook.length <= 0
                                          ? Container(
                                              child: Text(
                                                "Tidak Ada Data",
                                                maxLines: 3,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontFamily: "Nunito",
                                                    fontWeight: FontWeight.w800,
                                                    fontSize: small ? 10 : 12,
                                                    fontStyle: FontStyle.normal,
                                                    color: Colors.black
                                                        .withOpacity(0.8)),
                                              ),
                                            )
                                          : Card(
                                              elevation: 1,
                                              shadowColor: Colors.black38,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(16.0),
                                              ),
                                              child: Container(
                                                padding: EdgeInsets.only(
                                                    left: 18, right: 16),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Container(
                                                          padding:
                                                              EdgeInsets.all(3),
                                                          height: 23,
                                                          width: 23,
                                                          decoration: BoxDecoration(
                                                              border: Border.all(
                                                                  width: 1.5,
                                                                  color: Color(
                                                                      0xff58C863)),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          16)),
                                                          child: SvgPicture.asset(
                                                              "assets/icon/arrow_down.svg"),
                                                        ),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        Container(
                                                          width: Screen(size)
                                                              .wp(40),
                                                          child: Text(
                                                            element.citizenName! +
                                                                ' - ' +
                                                                element
                                                                    .houseBlock! +
                                                                ' ' +
                                                                element
                                                                    .houseNumber!,
                                                            maxLines: 3,
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    "Nunito",
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w800,
                                                                fontSize: small
                                                                    ? 10
                                                                    : 12,
                                                                fontStyle:
                                                                    FontStyle
                                                                        .normal,
                                                                color: Colors
                                                                    .black
                                                                    .withOpacity(
                                                                        0.8)),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                    Text(
                                                      "+ " +
                                                          NumberFormat.currency(
                                                                  locale: 'id',
                                                                  symbol:
                                                                      'Rp. ',
                                                                  decimalDigits:
                                                                      0)
                                                              .format(element
                                                                  .paidTotal),
                                                      style: TextStyle(
                                                          fontFamily: "Nunito",
                                                          fontWeight:
                                                              FontWeight.w800,
                                                          fontSize:
                                                              small ? 10 : 12,
                                                          fontStyle:
                                                              FontStyle.normal,
                                                          color: Color(
                                                              0xff58C863)),
                                                    )
                                                  ],
                                                ),
                                              )),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    ],
                  ),
                );
              },
            ),
          )
        ],
      )),
    );
  }

  void onchange(String nama, bool isCheck) {
    setState(() {
      if (isCheck) {
        if (listNama.contains(nama)) {
        } else {
          listNama.add(nama.toString());
        }
      } else {
        if (listNama.contains(nama)) {
          listNama.remove(nama);
        }
      }
      print(listNama.toString());
    });
  }
}
