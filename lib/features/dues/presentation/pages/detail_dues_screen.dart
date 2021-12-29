import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:intl/intl.dart';
import 'package:kmp_petugas_app/config/global_vars.dart';
import 'package:kmp_petugas_app/config/string_resources.dart';
import 'package:kmp_petugas_app/features/dues/data/models/dues_model.dart';
import 'package:kmp_petugas_app/features/dues/domain/entities/post_dues.dart';
import 'package:kmp_petugas_app/features/dues/presentation/bloc/bloc.dart';
import 'package:kmp_petugas_app/framework/managers/helper.dart';
import 'package:kmp_petugas_app/framework/widgets/loading_indicator.dart';
import 'package:kmp_petugas_app/theme/button.dart';
import 'package:kmp_petugas_app/theme/colors.dart';
import 'package:kmp_petugas_app/theme/enum.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class DetailDuesScreen extends StatefulWidget {
  final String? bloc;
  final String? number;
  final String? name;
  final String? phone;
  final String? address;
  final String? idHouse;
  final int? duesYear;

  DetailDuesScreen({
    this.idHouse,
    this.duesYear,
    this.bloc,
    this.number,
    this.name,
    this.phone,
    this.address,
  });

  @override
  _DetailDuesScreenState createState() => _DetailDuesScreenState();
}

class _DetailDuesScreenState extends State<DetailDuesScreen> {
  late String lis;
  var status = 0;
  DateTime now = DateTime.now();
  int total = 0;
  bool check = false;

  String? idHouse;
  int? duesYear;
  String? bloc;
  String? number;
  String? name;
  String? phone;
  String? address;
  bool isLoading = false;

  List<Year> listYear = [];
  List<Month> listMonth = [];
  List<SubscriptionPayment> listSubscription = [];
  PostDues? itemDues;
  List<String> subscriptions = [];

  @override
  void initState() {
    super.initState();
    idHouse = widget.idHouse;
    duesYear = widget.duesYear;
    bloc = widget.bloc;
    number = widget.number;
    name = widget.name;
    phone = widget.phone;
    address = widget.address;
    BlocProvider.of<DuesBloc>(context)
        .add(GetMonthYearEvent(idHouse: idHouse, year: duesYear));
  }

  @override
  Widget build(BuildContext context) {
    return _build(context);
  }

  Widget _build(BuildContext context) {
    return Scaffold(
      body: ProgressHUD(
        child: BlocListener<DuesBloc, DuesState>(
          listener: (context, state) async {
            if (state is MonthYearLoaded) {
              final progress = ProgressHUD.of(context);
              if (state.data!.years != null) {
                listYear = state.data!.years!;
                listMonth = state.data!.months!;
                isLoading = true;
                setState(() {});
              }
              progress!.dismiss();
            } else if (state is DuesFailure) {
              final progress = ProgressHUD.of(context);
              progress!.dismiss();
              catchAllException(context, state.error, true);
              setState(() {});
            } else if (state is DuesSuccess) {
              final progress = ProgressHUD.of(context);
              progress!.dismiss();
              _thankYouPopup();
              BlocProvider.of<DuesBloc>(context)
                  .add(GetMonthYearEvent(idHouse: idHouse, year: duesYear));
              setState(() {
                total = 0;
              });
            } else if (state is HouseListLoading) {
              final progress = ProgressHUD.of(context);
              progress?.showWithText(GlobalConfiguration()
                      .getValue(GlobalVars.TEXT_LOADING_TITLE) ??
                  StringResources.PLEASE_WAIT);
            }
          },
          child: isLoading ? _buildBody(context) : LoadingIndicator(),
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
              SizedBox(
                width: 20,
              ),
              Text(
                bloc! + " - " + number!,
                style: TextStyle(
                    fontFamily: "Nunito",
                    fontWeight: FontWeight.w800,
                    color: Colors.black.withOpacity(0.8),
                    fontSize: 18,
                    fontStyle: FontStyle.normal),
              )
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        // physics: new NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 1,
              padding: EdgeInsets.only(left: 25, top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Pemilik",
                    style: TextStyle(
                        fontFamily: "Nunito",
                        fontWeight: FontWeight.w400,
                        color: Color(0xff979797),
                        fontSize: 11,
                        fontStyle: FontStyle.normal),
                  ),
                  Text(
                    name!,
                    style: TextStyle(
                        fontFamily: "Nunito",
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                        fontSize: 16,
                        fontStyle: FontStyle.normal),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Nomor Hp",
                    style: TextStyle(
                        fontFamily: "Nunito",
                        fontWeight: FontWeight.w400,
                        color: Color(0xff979797),
                        fontSize: 11,
                        fontStyle: FontStyle.normal),
                  ),
                  Text(
                    phone!,
                    style: TextStyle(
                        fontFamily: "Nunito",
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                        fontSize: 16,
                        fontStyle: FontStyle.normal),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Alamat",
                    style: TextStyle(
                        fontFamily: "Nunito",
                        fontWeight: FontWeight.w400,
                        color: Color(0xff979797),
                        fontSize: 11,
                        fontStyle: FontStyle.normal),
                  ),
                  Text(
                    address!,
                    style: TextStyle(
                        fontFamily: "Nunito",
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                        fontSize: 16,
                        fontStyle: FontStyle.normal),
                  )
                ],
              ),
            ),
            Divider(
              thickness: 1,
              color: Color(0xff979797).withOpacity(0.25),
            ),
            Container(
              padding: EdgeInsets.only(left: 15, right: 15),
              margin: EdgeInsets.only(left: 15, right: 15, top: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12), color: Colors.white),
              child: DropdownButton(
                underline: Container(),
                value: duesYear.toString(),
                isExpanded: true,
                iconSize: 30.0,
                style: TextStyle(color: Colors.black),
                items: listYear.map(
                  (val) {
                    return DropdownMenuItem<String>(
                      value: val.year.toString(),
                      child: Text(val.year.toString()),
                    );
                  },
                ).toList(),
                onChanged: (val) {
                  setState(
                    () {
                      duesYear = int.parse(val.toString());
                      BlocProvider.of<DuesBloc>(context).add(
                          GetMonthYearEvent(idHouse: idHouse, year: duesYear));
                      total = 0;
                    },
                  );
                },
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 15, right: 15, top: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          // maxCrossAxisExtent: 120,
                          crossAxisCount: 2,
                          childAspectRatio: 5 / 3,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10),
                      itemCount: listMonth.length,
                      itemBuilder: (BuildContext ctx, index) {
                        var month = listMonth[index];
                        // double persentase = month.percentage!.toInt() / 100;
                        return InkWell(
                          //status list month
                          onTap: month.status == "Sudah Lunas"
                              ? () {
                                  showModalBottomSheet(
                                      isScrollControlled: true,
                                      context: context,
                                      builder: (context) {
                                        return Container(
                                          height: 340,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 25, vertical: 10),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text('Informasi',
                                                      style: TextStyle(
                                                          fontFamily: "Nunito",
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontSize: 18,
                                                          fontStyle:
                                                              FontStyle.normal,
                                                          color: Colors.black)),
                                                  InkWell(
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: Container(
                                                      height: 28,
                                                      width: 28,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(14),
                                                          color: Colors.white),
                                                      child: Icon(Icons.close),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              SizedBox(height: 20),
                                              Image.asset(
                                                'assets/images/ok.png',
                                                height: 90,
                                              ),
                                              SizedBox(height: 30),
                                              Text(
                                                'Pembayaran Sebesar Rp. 200.000 Sudah dibayarkan pada tanggal 13 Februari 2021',
                                                textAlign: TextAlign.center,
                                                style: TextPalette.txt14
                                                    .copyWith(
                                                        color:
                                                            ColorPalette.black,
                                                        fontWeight:
                                                            FontWeight.w400),
                                              ),
                                              SizedBox(height: 30),
                                              KmpFlatButton(
                                                fullWidth: true,
                                                buttonType: ButtonType.primary,
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                title: 'OK',
                                              ),
                                            ],
                                          ),
                                        );
                                      });
                                }
                              : month.status == "Tidak ada iuran"
                                  ? () async {
                                      await showModalBottomSheet(
                                          isScrollControlled: true,
                                          context: context,
                                          builder: (context) {
                                            return Container(
                                              height: 340,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 25,
                                                      vertical: 10),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text('Informasi',
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  "Nunito",
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              fontSize: 18,
                                                              fontStyle:
                                                                  FontStyle
                                                                      .normal,
                                                              color: Colors
                                                                  .black)),
                                                      InkWell(
                                                        onTap: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Container(
                                                          height: 28,
                                                          width: 28,
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          14),
                                                              color:
                                                                  Colors.white),
                                                          child:
                                                              Icon(Icons.close),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  SizedBox(height: 20),
                                                  Image.asset(
                                                    'assets/images/ok.png',
                                                    height: 90,
                                                  ),
                                                  SizedBox(height: 30),
                                                  Text(
                                                    'Anda Tidak Memiliki Tanggungan Iuran Untuk Bulan Ini',
                                                    textAlign: TextAlign.center,
                                                    style: TextPalette.txt14
                                                        .copyWith(
                                                            color: ColorPalette
                                                                .black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
                                                  ),
                                                  SizedBox(height: 30),
                                                  KmpFlatButton(
                                                    fullWidth: true,
                                                    buttonType:
                                                        ButtonType.primary,
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    title: 'OK',
                                                  ),
                                                ],
                                              ),
                                            );
                                          });
                                    }
                                  : () async {
                                    setState(() {
                                        subscriptions.clear();
                                        month.subscriptionPayments!
                                            .forEach((element) {
                                          if (element.isPaid!) {
                                            element.isPayment = true;
                                          } else {
                                            element.isPayment = false;
                                          }
                                        });
                                      });
                                      var result = await showModalBottomSheet(
                                        isScrollControlled: true,
                                        context: context,
                                        builder: (BuildContext context) {
                                          return StatefulBuilder(
                                            builder: (BuildContext context,
                                                setState) {
                                              return Container(
                                                  color: Color(0xffF8F8F8),
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 25,
                                                    vertical: 30,
                                                  ),
                                                  // height: 360,
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            'Pilih Iuran',
                                                            style: TextPalette
                                                                .txt18
                                                                .copyWith(
                                                                    color: ColorPalette
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700),
                                                          ),
                                                          InkWell(
                                                            onTap: () {
                                                              
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: Container(
                                                              height: 28,
                                                              width: 28,
                                                              decoration: BoxDecoration(
                                                                  boxShadow: [
                                                                    BoxShadow(
                                                                      color: Colors
                                                                          .black
                                                                          .withOpacity(
                                                                              0.05),
                                                                      spreadRadius:
                                                                          1.5,
                                                                      blurRadius:
                                                                          15,
                                                                      offset: Offset(
                                                                          0,
                                                                          1), // changes position of shadow
                                                                    ),
                                                                  ],
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              14),
                                                                  color: Colors
                                                                      .white),
                                                              child: Icon(
                                                                  Icons.close),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      Expanded(
                                                        child:
                                                            SingleChildScrollView(
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: 30),
                                                            child: GridView
                                                                .builder(
                                                                    physics:
                                                                        new NeverScrollableScrollPhysics(),
                                                                    shrinkWrap:
                                                                        true,
                                                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                                        crossAxisCount:
                                                                            1,
                                                                        childAspectRatio:
                                                                            9 /
                                                                                2,
                                                                        crossAxisSpacing:
                                                                            5,
                                                                        mainAxisSpacing:
                                                                            10),
                                                                    itemCount: listMonth[
                                                                            index]
                                                                        .subscriptionPayments!
                                                                        .length,
                                                                    itemBuilder:
                                                                        (BuildContext
                                                                                context,
                                                                            index) {
                                                                      var subs =
                                                                          month.subscriptionPayments![
                                                                              index];
                                                                      return Container(
                                                                        padding:
                                                                            EdgeInsets.only(bottom: 20),
                                                                        height:
                                                                            48,
                                                                        decoration: new BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.circular(16),
                                                                            color: Colors.white),
                                                                        child:
                                                                            CheckboxListTile(
                                                                          controlAffinity:
                                                                              ListTileControlAffinity.leading,
                                                                          activeColor:
                                                                              Color(0xff58C863),
                                                                          contentPadding: EdgeInsets.only(
                                                                              top: 7,
                                                                              left: 5),
                                                                          value: total == 0
                                                                              ? subs.isPaid!
                                                                                  ? true
                                                                                  : false
                                                                              : subs.isPayment,
                                                                          onChanged: subs.isPaid!
                                                                              ? (val) {}
                                                                              : (val) {
                                                                                  setState(() {
                                                                                    subs.isPayment = val!;

                                                                                    if (subs.isPayment!) {
                                                                                      total = total + subs.amount!;
                                                                                      if (subscriptions.contains(subs.id)) {
                                                                                      } else {
                                                                                        subscriptions.add(subs.id!);
                                                                                      }
                                                                                      // print(subscriptions.toString());
                                                                                    } else {
                                                                                      total = total - subs.amount!;
                                                                                      if (subscriptions.contains(subs.id)) {
                                                                                        subscriptions.remove(subs.id!);
                                                                                      }
                                                                                    }
                                                                                    print(subscriptions.toString());
                                                                                  });
                                                                                },
                                                                          title:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Text(
                                                                                subs.name!,
                                                                                style: TextStyle(fontFamily: "Nunito", fontSize: 16, fontWeight: FontWeight.w800, color: Colors.black.withOpacity(0.8)),
                                                                              ),
                                                                              Container(
                                                                                padding: EdgeInsets.only(right: 20),
                                                                                child: Text(
                                                                                  NumberFormat.currency(locale: 'id', symbol: 'Rp. ', decimalDigits: 0).format(subs.amount),
                                                                                  style: TextStyle(fontFamily: "Nunito", fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xff58C863)),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      );
                                                                    }),
                                                          ),
                                                        ),
                                                      ),
                                                      Divider(
                                                        thickness: 2,
                                                      ),
                                                      Container(
                                                        height: 65,
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Container(
                                                                padding:
                                                                    EdgeInsets
                                                                        .only(),
                                                                child: Text(
                                                                  "Jumlah Iuran",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          16,
                                                                      color: Color(
                                                                          0xff000000),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      fontFamily:
                                                                          "Nunito"),
                                                                )),
                                                            Container(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        left:
                                                                            75),
                                                                child: Text(
                                                                  NumberFormat.currency(
                                                                          locale:
                                                                              'id',
                                                                          symbol:
                                                                              'Rp. ',
                                                                          decimalDigits:
                                                                              0)
                                                                      .format(
                                                                          total),
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          24,
                                                                      color: Color(
                                                                          0xff58C863),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w800,
                                                                      fontFamily:
                                                                          "Nunito"),
                                                                )),
                                                          ],
                                                        ),
                                                      ),
                                                      KmpFlatButton(
                                                          onPressed: total == 0
                                                              ? () {
                                                                  _disableBayar();
                                                                }
                                                              : () {
                                                                  itemDues = PostDues(
                                                                      house:
                                                                          idHouse,
                                                                      monthNumber:
                                                                          month
                                                                              .number,
                                                                      year:
                                                                          duesYear,
                                                                      subscriptions:
                                                                          subscriptions);
                                                                  Navigator.pop(
                                                                      context,
                                                                      itemDues);
                                                                },
                                                          fullWidth: true,
                                                          buttonType: total == 0
                                                              ? ButtonType
                                                                  .disable
                                                              : ButtonType
                                                                  .primary,
                                                          title: "Bayar")
                                                    ],
                                                  ));
                                            },
                                          );
                                        },
                                      );
                                      if (result != null) {
                                        BlocProvider.of<DuesBloc>(context).add(
                                            AddDuesEvent(postDues: itemDues!));
                                      }
                                      setState(() {
                                        total = 0;
                                      });
                                    },
                          child: Center(
                            child: ClipRRect(
                              child: Container(
                                height: 89,
                                width: 178,
                                decoration: new BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    color: Color(0xffFFFFFF)),
                                child: Row(
                                  children: [
                                    Container(
                                        child:
                                            // month.isPaidOff!
                                            //     ? Container(
                                            //         padding:
                                            //             EdgeInsets.only(left: 19),
                                            //         child: SvgPicture.asset(
                                            //             "assets/icon/paid-off.svg"),
                                            //         height: 65,
                                            //         width: 65,
                                            //       )
                                            //     :
                                            Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 19),
                                                child: month.progressType ==
                                                        "warning"
                                                    ? CircularPercentIndicator(
                                                        radius: 45,
                                                        lineWidth: 6.0,
                                                        progressColor:
                                                            Color(0xffFFB61D),
                                                        center: Text(
                                                          month
                                                              .percentageString!,
                                                          style: TextStyle(
                                                              fontSize: 10,
                                                              color: Color(
                                                                  0xffFFB61D),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              fontFamily:
                                                                  "Nunito"),
                                                        ),
                                                        percent:
                                                            month.percentage! /
                                                                100,
                                                      )
                                                    : month.progressType ==
                                                            "info"
                                                        ? CircularPercentIndicator(
                                                            radius: 45,
                                                            lineWidth: 6.0,
                                                            percent: 0,
                                                            progressColor:
                                                                Color(
                                                                    0xffC4C4C4),
                                                            center: Text(
                                                              month
                                                                  .percentageString!,
                                                              style: TextStyle(
                                                                  fontSize: 10,
                                                                  color: Colors
                                                                      .grey
                                                                      .shade700,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  fontFamily:
                                                                      "Nunito"),
                                                            ),
                                                          )
                                                        : month.progressType ==
                                                                "sucess"
                                                            ? CircularPercentIndicator(
                                                                radius: 45,
                                                                lineWidth: 6.0,
                                                                percent: 1,
                                                                progressColor:
                                                                    Color(
                                                                        0xff58C863),
                                                                center: SvgPicture
                                                                    .asset(
                                                                        "assets/icon/paid-off.svg"),
                                                              )
                                                            : CircularPercentIndicator(
                                                                radius: 45))),
                                    Container(
                                      padding:
                                          EdgeInsets.only(left: 10, top: 30),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            month.name!,
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w800,
                                                fontFamily: "Nunito"),
                                          ),
                                          Text(
                                            month.status!,
                                            style: TextStyle(
                                                fontSize: 10,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w400,
                                                fontFamily: "Nunito"),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _thankYouPopup() {
    return CoolAlert.show(
        context: context,
        type: CoolAlertType.success,
        text: "Iuran Berhasil",
        confirmBtnText: 'Ok',
        onConfirmBtnTap: () {
          Navigator.pop(context);
        });
  }

  Future<void> _disableBayar() {
    return CoolAlert.show(
        context: context,
        type: CoolAlertType.error,
        text: "Mohon Pilih Iuran Terlebih Dahulu",
        confirmBtnText: 'Ok',
        onConfirmBtnTap: () async {
          Navigator.pop(context);
        });
  }
}
