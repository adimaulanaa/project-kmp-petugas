import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grouped_list/sliver_grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:kmp_petugas_app/features/authentication/data/models/user_model.dart';
import 'package:kmp_petugas_app/features/report/data/models/month.dart';
import 'package:kmp_petugas_app/features/report/data/models/report_model.dart';
import 'package:kmp_petugas_app/features/report/data/models/year.dart';

import 'package:kmp_petugas_app/features/report/presentation/bloc/bloc.dart';
import 'package:kmp_petugas_app/framework/managers/helper.dart';
import 'package:kmp_petugas_app/framework/widgets/loading_indicator.dart';
import 'package:kmp_petugas_app/theme/button.dart';

import 'package:kmp_petugas_app/theme/colors.dart';
import 'package:kmp_petugas_app/theme/enum.dart';
import 'package:kmp_petugas_app/theme/size.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';

class ReportScreen extends StatefulWidget {
  final int? month;
  final int? year;

  const ReportScreen({Key? key, this.month, this.year}) : super(key: key);

  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool isLoading = false;
  bool semua = false;
  bool pemasukan = true;
  bool pengeluaran = false;
  bool lunas = false;
  bool belumLunas = false;

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
  List<CashBook> listCashbook = [];
  List<CashBook> listPemasukan = [];
  List<CashBook> listPengeluaran = [];
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
  String? gettipe;
  bool getisPaid = true;

  @override
  void initState() {
    super.initState();

    month = widget.month;
    year = widget.year;

    bulanstart = DateTime.now().month;
    tahunstart = DateTime.now().year;
    tipe = 'financial_statement';

    listCashbook.clear();
    listPemasukan.clear();
    listPengeluaran.clear();

    BlocProvider.of<ReportBloc>(context).add(GetSessionEvent());
    BlocProvider.of<ReportBloc>(context).add(GetCashBookFinancialEvent(
        yearstart: tahunstart,
        monthstrat: bulanstart,
        type: tipe,
        ispaid: isPaid));
  }

  @override
  Widget build(BuildContext context) {
    return _build(context);
  }

  Widget _build(BuildContext context) {
    return BlocListener<ReportBloc, ReportState>(
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
          if (state.data != null && state.data!.total != null) {
            if (state.data!.cashBooks!.length > 0) {
              listCashbook.clear();
              listPemasukan.clear();
              listPengeluaran.clear();

              listCashbook = state.data!.cashBooks!;
              listCashbook.forEach((element) {
                if (element.type == 'PEMASUKAN') {
                  listPemasukan.add(element);
                } else if (element.type == 'PENGELUARAN') {
                  listPengeluaran.add(element);
                }
              });
            } else {
              listCashbook = [];
              listPemasukan = [];
              listPengeluaran = [];
            }

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
        } else if (state is ReportFailure) {
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
                "Laporan Keuangan",
                style: TextStyle(
                    fontFamily: "Nunito",
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                    color: Colors.white),
              ),
              Container(
                height: 27,
                width: 70,
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

                                  BlocProvider.of<ReportBloc>(context).add(
                                      GetCashBookFinancialEvent(
                                          yearstart: tahunstart,
                                          monthstrat: bulanstart,
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
                width: 106,
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

                                  BlocProvider.of<ReportBloc>(context).add(
                                      GetCashBookFinancialEvent(
                                          yearstart: tahunstart,
                                          monthstrat: bulanstart,
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
              Container(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      nama,
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontFamily: "Nunito"),
                    ),
                    Container()
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "RT ${rt.toString()} / RW ${rw.toString()}",
                      style: TextStyle(
                          fontSize: 13,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontFamily: "Nunito"),
                    ),
                    Container()
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 20, right: 20, top: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total Pemasukan",
                      style: TextStyle(
                          fontSize: 13,
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
                                  .format(listTotal!.income),
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
                      "Total Pengeluaran",
                      style: TextStyle(
                          fontSize: 13,
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
                                  .format(listTotal!.outcome),
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
                      BlocProvider.of<ReportBloc>(context).add(
                          GetPdfReportEvent(
                              yearstart: tahunstart,
                              monthstrat: bulanstart,
                              ispaid: getisPaid,
                              type: 'financial_statement'));
                      printWarning("--------------------");
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
              initialChildSize: 0.67,
              minChildSize: 0.67,
              maxChildSize: 1,
              builder: (BuildContext c, s) {
                return Container(
                  padding: EdgeInsets.only(bottom: 65),
                  color: Color(0xffF8F8F8),
                  child: CustomScrollView(
                    controller: s,
                    slivers: <Widget>[
                      SliverAppBar(
                        bottom: PreferredSize(
                          preferredSize: Size.fromHeight(20.0),
                          child: Container(),
                        ),
                        backgroundColor: Color(0xffF8F8F8),
                        elevation: 0,
                        pinned: true,
                        automaticallyImplyLeading: false,
                        flexibleSpace: Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 5, bottom: 10),
                              child: SvgPicture.asset("assets/icon/line.svg"),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                left: 20,
                                right: 20,
                              ),
                              width: MediaQuery.of(context).size.width * 0.9,
                              height: 40,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Color(0xffE5E5E5).withOpacity(0.5)),
                              child: Row(children: [
                                // Flexible(
                                //   //!Semua
                                //   child: InkWell(
                                //       child: Container(
                                //     width:
                                //         MediaQuery.of(context).size.width * 0.3,
                                //     height: 40,
                                //     decoration: BoxDecoration(
                                //         borderRadius: BorderRadius.circular(10),
                                //         color: semua == false
                                //             ? Colors.transparent
                                //             : ColorPalette.primary),
                                //     child: TextButton(
                                //         onPressed: () {
                                //           setState(() {
                                //             semua = true;
                                //             pemasukan = false;
                                //             pengeluaran = false;
                                //           });
                                //         },
                                //         child: Text(
                                //           "Semua",
                                //           style: TextStyle(
                                //               fontFamily: "Nunito",
                                //               fontWeight: FontWeight.w700,
                                //               fontSize: 13,
                                //               color: semua == false
                                //                   ? Color(0xffC4C4C4)
                                //                   : Colors.white),
                                //         )),
                                //   )),
                                // ),

                                Flexible(
                                  //!Pemasukan
                                  child: InkWell(
                                      child: Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.45,
                                    height: 40,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: pemasukan == false
                                            ? Colors.transparent
                                            : ColorPalette.primary),
                                    child: TextButton(
                                        onPressed: () {
                                          setState(() {
                                            semua = false;
                                            pemasukan = true;
                                            pengeluaran = false;
                                          });
                                        },
                                        child: Text(
                                          "Pemasukan",
                                          style: TextStyle(
                                              fontFamily: "Nunito",
                                              fontWeight: FontWeight.w700,
                                              fontSize: 13,
                                              color: pemasukan == false
                                                  ? Color(0xffC4C4C4)
                                                  : Colors.white),
                                        )),
                                  )),
                                ),
                                Flexible(
                                  //!Pengeluaran
                                  child: InkWell(
                                      child: Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.45,
                                    height: 40,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: pengeluaran == false
                                            ? Colors.transparent
                                            : ColorPalette.primary),
                                    child: TextButton(
                                        onPressed: () {
                                          setState(() {
                                            semua = false;
                                            pemasukan = false;
                                            pengeluaran = true;
                                          });
                                        },
                                        child: Text(
                                          "Pengeluaran",
                                          style: TextStyle(
                                              fontFamily: "Nunito",
                                              fontWeight: FontWeight.w700,
                                              fontSize: 13,
                                              color: pengeluaran == false
                                                  ? Color(0xffC4C4C4)
                                                  : Colors.white),
                                        )),
                                  )),
                                )
                              ]),
                            ),
                          ],
                        ),
                      ),
                      semua
                          ? SliverGroupedListView<dynamic, String>(
                              elements: listCashbook,
                              groupBy: (element) => element.paymentMonthName,
                              groupComparator: (value1, value2) =>
                                  value2.compareTo(value1),
                              itemComparator: (item1, item2) =>
                                  item1.name.compareTo(item2.name),
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
                                return
                                    // semua
                                    //     ?
                                    InkWell(
                                  onTap: () {},
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 15, right: 15),
                                      child: Column(
                                        children: [
                                          Container(
                                            height: 60,
                                            child: listCashbook.length <= 0
                                                ? Container(
                                                    child: Text(
                                                      "Tidak Ada Data",
                                                      maxLines: 3,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontFamily: "Nunito",
                                                          fontWeight:
                                                              FontWeight.w800,
                                                          fontSize:
                                                              small ? 10 : 12,
                                                          fontStyle:
                                                              FontStyle.normal,
                                                          color: Colors.black
                                                              .withOpacity(
                                                                  0.8)),
                                                    ),
                                                  )
                                                : Card(
                                                    elevation: 1,
                                                    shadowColor: Colors.black38,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              16.0),
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
                                                                    EdgeInsets
                                                                        .all(3),
                                                                height: 23,
                                                                width: 23,
                                                                decoration: BoxDecoration(
                                                                    border: Border.all(
                                                                        width:
                                                                            1.5,
                                                                        color: element.name !=
                                                                                null
                                                                            ? Color(
                                                                                0xff58C863)
                                                                            : ColorPalette
                                                                                .primary),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            16)),
                                                                child: element
                                                                            .name !=
                                                                        null
                                                                    ? SvgPicture
                                                                        .asset(
                                                                            "assets/icon/arrow_down.svg")
                                                                    : SvgPicture
                                                                        .asset(
                                                                            "assets/icon/arrow-up.svg"),
                                                              ),
                                                              SizedBox(
                                                                width: 10,
                                                              ),
                                                              Container(
                                                                width:
                                                                    Screen(size)
                                                                        .wp(40),
                                                                child: Text(
                                                                  element.name!,
                                                                  maxLines: 3,
                                                                  textAlign:
                                                                      TextAlign
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
                                                            element.name != null
                                                                ? "+ " +
                                                                    NumberFormat.currency(
                                                                            locale:
                                                                                'id',
                                                                            symbol:
                                                                                'Rp. ',
                                                                            decimalDigits:
                                                                                0)
                                                                        .format(element
                                                                            .total)
                                                                : "- " +
                                                                    NumberFormat.currency(
                                                                            locale:
                                                                                'id',
                                                                            symbol:
                                                                                'Rp. ',
                                                                            decimalDigits:
                                                                                0)
                                                                        .format(
                                                                            element.total),
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
                                                                color: element
                                                                            .name !=
                                                                        null
                                                                    ? Color(
                                                                        0xff58C863)
                                                                    : ColorPalette
                                                                        .primary),
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
                          : pemasukan
                              ? SliverGroupedListView<dynamic, String>(
                                  elements: listPemasukan,
                                  groupBy: (element) =>
                                      element.paymentMonthName,
                                  groupComparator: (value1, value2) =>
                                      value2.compareTo(value1),
                                  itemComparator: (item1, item2) =>
                                      item1.name.compareTo(item2.name),
                                  order: GroupedListOrder.DESC,
                                  groupSeparatorBuilder: (String value) =>
                                      Padding(
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
                                          padding: const EdgeInsets.only(
                                              left: 15, right: 15),
                                          child: Column(
                                            children: [
                                              Container(
                                                height: 60,
                                                child: listPemasukan.length <= 0
                                                    ? Container(
                                                        child: Text(
                                                          "Tidak Ada Data",
                                                          maxLines: 3,
                                                          textAlign:
                                                              TextAlign.center,
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
                                                    : Card(
                                                        elevation: 1,
                                                        shadowColor:
                                                            Colors.black38,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      16.0),
                                                        ),
                                                        child: Container(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 18,
                                                                  right: 16),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Container(
                                                                    padding:
                                                                        EdgeInsets
                                                                            .all(3),
                                                                    height: 23,
                                                                    width: 23,
                                                                    decoration: BoxDecoration(
                                                                        border: Border.all(
                                                                            width:
                                                                                1.5,
                                                                            color: Color(
                                                                                0xff58C863)),
                                                                        borderRadius:
                                                                            BorderRadius.circular(16)),
                                                                    child: SvgPicture
                                                                        .asset(
                                                                            "assets/icon/arrow_down.svg"),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 10,
                                                                  ),
                                                                  Container(
                                                                    width: Screen(
                                                                            size)
                                                                        .wp(40),
                                                                    child: Text(
                                                                      element
                                                                          .name!,
                                                                      maxLines:
                                                                          3,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style: TextStyle(
                                                                          fontFamily:
                                                                              "Nunito",
                                                                          fontWeight: FontWeight
                                                                              .w800,
                                                                          fontSize: small
                                                                              ? 10
                                                                              : 12,
                                                                          fontStyle: FontStyle
                                                                              .normal,
                                                                          color: Colors
                                                                              .black
                                                                              .withOpacity(0.8)),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                              Text(
                                                                "+ " +
                                                                    NumberFormat.currency(
                                                                            locale:
                                                                                'id',
                                                                            symbol:
                                                                                'Rp. ',
                                                                            decimalDigits:
                                                                                0)
                                                                        .format(
                                                                            element.total),
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        "Nunito",
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w800,
                                                                    fontSize:
                                                                        small
                                                                            ? 10
                                                                            : 12,
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .normal,
                                                                    color: element.name !=
                                                                            null
                                                                        ? Color(
                                                                            0xff58C863)
                                                                        : ColorPalette
                                                                            .primary),
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
                              : pengeluaran
                                  ? SliverGroupedListView<dynamic, String>(
                                      elements: listPengeluaran,
                                      groupBy: (element) =>
                                          element.paymentMonthName,
                                      groupComparator: (value1, value2) =>
                                          value2.compareTo(value1),
                                      itemComparator: (item1, item2) =>
                                          item1.name.compareTo(item2.name),
                                      order: GroupedListOrder.DESC,
                                      groupSeparatorBuilder: (String value) =>
                                          Padding(
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
                                              padding: const EdgeInsets.only(
                                                  left: 15, right: 15),
                                              child: Column(
                                                children: [
                                                  Container(
                                                    height: 60,
                                                    child: listPengeluaran
                                                                .length <=
                                                            0
                                                        ? Container(
                                                            child: Text(
                                                              "Tidak Ada Data",
                                                              maxLines: 3,
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      "Nunito",
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w800,
                                                                  fontSize:
                                                                      small
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
                                                        : Card(
                                                            elevation: 1,
                                                            shadowColor:
                                                                Colors.black38,
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          16.0),
                                                            ),
                                                            child: Container(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      left: 18,
                                                                      right:
                                                                          16),
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
                                                                        height:
                                                                            23,
                                                                        width:
                                                                            23,
                                                                        decoration: BoxDecoration(
                                                                            border:
                                                                                Border.all(width: 1.5, color: ColorPalette.primary),
                                                                            borderRadius: BorderRadius.circular(16)),
                                                                        child: SvgPicture.asset(
                                                                            "assets/icon/arrow-up.svg"),
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            10,
                                                                      ),
                                                                      Container(
                                                                        width: Screen(size)
                                                                            .wp(40),
                                                                        child:
                                                                            Text(
                                                                          element
                                                                              .name!,
                                                                          maxLines:
                                                                              3,
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                          style: TextStyle(
                                                                              fontFamily: "Nunito",
                                                                              fontWeight: FontWeight.w800,
                                                                              fontSize: small ? 10 : 12,
                                                                              fontStyle: FontStyle.normal,
                                                                              color: Colors.black.withOpacity(0.8)),
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                  Text(
                                                                    "- " +
                                                                        NumberFormat.currency(
                                                                                locale: 'id',
                                                                                symbol: 'Rp. ',
                                                                                decimalDigits: 0)
                                                                            .format(element.total)
                                                                            .toString(),
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
                                                                        color: ColorPalette
                                                                            .primary),
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
                                  : Container()
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
