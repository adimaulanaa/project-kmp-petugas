import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kmp_petugas_app/env.dart';
import 'package:kmp_petugas_app/features/authentication/data/models/user_model.dart';
import 'package:kmp_petugas_app/features/dashboard/presentation/bloc/bloc.dart';
import 'package:kmp_petugas_app/features/dues/presentation/pages/dues_page.dart';
import 'package:kmp_petugas_app/features/guest_book/data/models/guest_book_today_model.dart';
import 'package:kmp_petugas_app/features/guest_book/presentation/pages/guest_book_page.dart';
import 'package:kmp_petugas_app/framework/blocs/messaging/index.dart';
import 'package:kmp_petugas_app/framework/managers/helper.dart';
import 'package:kmp_petugas_app/framework/managers/hive_db_helper.dart';
import 'package:kmp_petugas_app/framework/widgets/loading_indicator.dart';
import 'package:kmp_petugas_app/theme/colors.dart';
import 'package:kmp_petugas_app/theme/size.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class DashboardScreen extends StatefulWidget {
  DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with AfterLayoutMixin<DashboardScreen> {
  //
  String message = '';
  bool isInternetConnected = true;
  UserModel _user = UserModel();
  List<Visitor> listData = [];
  String clientName = '';
  String petugas = '';
  UserModel? dataProfile;
  bool isLoading = false;
  Box<String>? friendsBox;
  String? nol;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<MessagingBloc>(context).add(MessageLoaded());
    BlocProvider.of<DashboardBloc>(context).add(LoadDashboard());
    BlocProvider.of<DashboardBloc>(context).add(LoadGuestBook());
  }

  @override
  void afterFirstLayout(BuildContext context) {
    setState(() {
      isInternetConnected =
          BlocProvider.of<MessagingBloc>(context).getConnection();
    });
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
    return MultiBlocListener(
      listeners: [
        BlocListener<DashboardBloc, DashboardState>(
            listener: (context, state) async {
          if (state is DashboardLoading) {
            isLoading = false;
            setState(() {});
          } else if (state is DashboardLoaded) {
            if (state.data != null) {
              clientName =
                  state.data!.client != null ? state.data!.client!.name! : "";
              dataProfile = state.profile;
              setState(() {});
            } else {
              clientName = '';
            }
            isLoading = true;
            setState(() {});
          } else if (state is GuestBookLoaded) {
            if (state.data != null) {
              if (state.data!.visitors! != null) {
                if (state.data!.visitors!.length > 0) {
                  listData = state.data!.visitors!;
                  nol = "ada";
                  // isLoading = true;
                  setState(() {});
                } else {
                  // isLoading = true;
                  setState(() {});
                }
              }
            }
          } else if (state is DashboardFailure) {
            catchAllException(context, state.error, true);
            setState(() {});
          }
        }),
        BlocListener<MessagingBloc, MessagingState>(
            listener: (context, state) async {
          if (state is InMessagingState) {
            setState(() {
              isInternetConnected = state.isConnected;
              message = state.message;
            });
          } else if (state is InternetConnectionState) {
            setState(() {
              isInternetConnected = state.isConnected;
            });
          }
        }),
      ],
      child: isLoading ? _buildBody(context) : LoadingIndicator(),
    );
  }

  Widget _buildBody(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var foto = dataProfile!.avatar;
    return SafeArea(
      child: Scaffold(
          backgroundColor: Color(0xffF54748),
          appBar: AppBar(
            backgroundColor: Color(0xffF54748),
            bottomOpacity: 0.0,
            elevation: 0.0,
            title: Text(
              clientName,
              style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontFamily: "Nunito"),
            ),
          ),
          body: SizedBox(
              child: Stack(
            children: <Widget>[
              SizedBox(
                height: 30,
              ),
              ValueListenableBuilder<Box<dynamic>>(
                valueListenable:
                    Hive.box<dynamic>(HiveDbServices.boxLoggedInUser)
                        .listenable(),
                builder: (context, boxy, widget) {
                  var userString = boxy.get('user');
                  var user = userModelFromJson(userString!);
                  return Column(
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      Center(
                        child: user.avatar!.isNotEmpty
                            ? CircleAvatar(
                                radius: 75,
                                backgroundColor: Colors.white,
                                backgroundImage: NetworkImage(
                                  '${Env().apiBaseUrl}/${user.avatar!}',
                                ))
                            : CircleAvatar(
                                radius: 75,
                                backgroundColor: Colors.white,
                                child: Image.asset(
                                  "assets/images/profile.png",
                                  height: 136,
                                ),
                              ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        user.name!,
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: "Nunito",
                          fontWeight: FontWeight.w700,
                          fontStyle: FontStyle.normal,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        // margin: EdgeInsets.only(top: 9),
                        height: 36,
                        width: 214,
                        decoration: BoxDecoration(
                          color: Color(0xffDD4041),
                          borderRadius: BorderRadius.circular(39),
                        ),
                        child: Center(
                          child: Text(
                            user.officer!.positionName!,
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: "Nunito",
                              fontWeight: FontWeight.w600,
                              fontStyle: FontStyle.normal,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                    ],
                  );
                },
              ),
              //

              SizedBox.expand(
                child: DraggableScrollableSheet(
                  initialChildSize: 0.5,
                  minChildSize: 0.5,
                  maxChildSize: 1,
                  builder: (BuildContext c, s) {
                    s.addListener(() {
                      print(s.offset.toString());
                    });
                    return Container(
                      margin: EdgeInsets.only(bottom: 53),
                      color: Color(0xffF8F8F8),
                      child: CustomScrollView(
                        controller: s,
                        slivers: <Widget>[
                          SliverAppBar(
                              bottom: PreferredSize(
                                preferredSize: Size.fromHeight(124.0),
                                child: Container(),
                              ),
                              backgroundColor: Color(0xffF8F8F8),
                              elevation: 0,
                              pinned: true,
                              automaticallyImplyLeading: false,
                              flexibleSpace: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 15, bottom: 23),
                                    child: SvgPicture.asset(
                                        "assets/icon/line.svg"),
                                  ),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            pushNewScreen(
                                              context,
                                              screen: DuesPage(),
                                              withNavBar: false,
                                              pageTransitionAnimation:
                                                  PageTransitionAnimation
                                                      .cupertino,
                                            );
                                          },
                                          child: Column(
                                            children: [
                                              Container(
                                                padding: EdgeInsets.all(10),
                                                child: SvgPicture.asset(
                                                    "assets/icon/empty_wallet.svg"),
                                                height: 57,
                                                width: 57,
                                                decoration: BoxDecoration(
                                                    color: Color(0xff58C863)
                                                        .withOpacity(0.1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            36)),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text("Iuran Warga",
                                                  style: TextPalette
                                                      .dashboardTextStyle)
                                            ],
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            pushNewScreen(
                                              context,
                                              screen: GustBookPage(),
                                              withNavBar: false,
                                              pageTransitionAnimation:
                                                  PageTransitionAnimation
                                                      .cupertino,
                                            );
                                          },
                                          child: Column(
                                            children: [
                                              Container(
                                                padding: EdgeInsets.all(10),
                                                child: SvgPicture.asset(
                                                    "assets/icon/guest_book.svg"),
                                                height: 57,
                                                width: 57,
                                                decoration: BoxDecoration(
                                                    color: Color(0xffF54748)
                                                        .withOpacity(0.1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            36)),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text("Buku Tamu",
                                                  style: TextPalette
                                                      .dashboardTextStyle)
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                        top: 25,
                                        left: 14,
                                        right: 14,
                                        bottom: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                            margin: EdgeInsets.only(left: 15),
                                            child: Text(
                                              "Daftar Tamu",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w700,
                                                  fontFamily: "Nunito"),
                                            )),
                                        InkWell(
                                          onTap: () {
                                            pushNewScreen(
                                              context,
                                              screen: GustBookPage(),
                                              withNavBar: false,
                                              pageTransitionAnimation:
                                                  PageTransitionAnimation
                                                      .cupertino,
                                            );
                                          },
                                          child: Container(
                                              margin:
                                                  EdgeInsets.only(right: 15),
                                              child: Text(
                                                "Lihat Semua",
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    color: Color(0xffF54748),
                                                    fontWeight: FontWeight.w700,
                                                    fontFamily: "Nunito"),
                                              )),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              )),
                          SliverList(
                            delegate: SliverChildBuilderDelegate(
                                (BuildContext context, index) {
                              var outputFormat = DateFormat('hh:mm a');
                              var formattedTime = outputFormat.format(
                                  listData[index].acceptedAt!.toLocal());

                              DateFormat date = DateFormat.yMMMMd();
                              DateTime satDate = DateTime.parse(
                                  listData[index].acceptedAt.toString());
                              String tgl = date.format(satDate.toLocal());

                              var ktp = listData[index].idCardFile;
                              var selfi = listData[index].selfieFile;
                              if (listData.length < 0) {
                                var data = 0;
                              }
                              // var selfi = listData[index]
                              return Container(
                                  padding: EdgeInsets.only(
                                      top: 5, bottom: 10, left: 10, right: 10),
                                  child: Container(
                                      decoration: BoxDecoration(
                                        color: Color(0xffFFFFFF),
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      child: Column(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.only(
                                                left: 15, right: 15, top: 10),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(tgl,
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color:
                                                            Color(0xff979797),
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontFamily: "Nunito")),
                                                Text(formattedTime,
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color:
                                                            Color(0xff979797),
                                                        fontWeight:
                                                            FontWeight.w800,
                                                        fontFamily: "Nunito"))
                                              ],
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.only(
                                                left: 15, right: 15, top: 10),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text("Nama Tamu",
                                                    style: TextStyle(
                                                        fontSize: 11,
                                                        color:
                                                            Color(0xff979797),
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontFamily: "Nunito")),
                                                Text("Rumah Tujuan",
                                                    style: TextStyle(
                                                        fontSize: 11,
                                                        color:
                                                            Color(0xff979797),
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontFamily: "Nunito"))
                                              ],
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.only(
                                                left: 15, right: 15, top: 7),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(listData[index].name!,
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w800,
                                                        fontFamily: "Nunito")),
                                                Text(
                                                    listData[index]
                                                        .citizenName!,
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w800,
                                                        fontFamily: "Nunito"))
                                              ],
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.only(
                                                left: 15, right: 15, top: 7),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  children: [
                                                    Text("Jumlah Tamu",
                                                        style: TextStyle(
                                                            fontSize: 11,
                                                            color: Color(
                                                                0xff979797),
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontFamily:
                                                                "Nunito")),
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          top: 5),
                                                      child: Text(
                                                          listData[index]
                                                              .guestCount
                                                              .toString(),
                                                          textAlign:
                                                              TextAlign.left,
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w800,
                                                              fontFamily:
                                                                  "Nunito")),
                                                    ),
                                                  ],
                                                ),
                                                Text(
                                                    listData[index]
                                                            .houseBlock! +
                                                        '-' +
                                                        listData[index]
                                                            .houseNumber!,
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w800,
                                                        fontFamily: "Nunito"))
                                              ],
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                listData[index].open =
                                                    !listData[index].open!;
                                              });
                                            },
                                            child: Align(
                                              alignment: Alignment.bottomLeft,
                                              child: Container(
                                                padding: EdgeInsets.only(
                                                    right: 189,
                                                    left: 15,
                                                    top: 19),
                                                child: !listData[index].open!
                                                    ? Text(
                                                        "Klik untuk melihat detail",
                                                        style: TextStyle(
                                                            fontSize: 10,
                                                            color: Color(
                                                                0xffF54748),
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontFamily:
                                                                "Nunito"))
                                                    : Container(
                                                        margin: EdgeInsets.only(
                                                            right: 88),
                                                        child: Text("Tutup",
                                                            style: TextStyle(
                                                                fontSize: 10,
                                                                color: Color(
                                                                    0xffF54748),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontFamily:
                                                                    "Nunito")),
                                                      ),
                                              ),
                                            ),
                                          ),
                                          listData[index].open!
                                              ? Container(
                                                  padding: EdgeInsets.only(
                                                    right: 15,
                                                    left: 15,
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text("Keperluan",
                                                              style: TextStyle(
                                                                  fontSize: 11,
                                                                  color: Color(
                                                                      0xff979797),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  fontFamily:
                                                                      "Nunito")),
                                                          Container(
                                                            width: Screen(size)
                                                                .wp(60),
                                                            child: Text(
                                                                listData[index]
                                                                    .necessity!,
                                                                maxLines: 5,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        13,
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                    fontFamily:
                                                                        "Nunito")),
                                                          ),
                                                        ],
                                                      ),
                                                      Column(
                                                        children: [
                                                          Text("Foto KTP",
                                                              style: TextStyle(
                                                                  fontSize: 11,
                                                                  color: Color(
                                                                      0xff979797),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  fontFamily:
                                                                      "Nunito")),
                                                          InkWell(
                                                            onTap: () {
                                                              showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (context) {
                                                                    return Dialog(
                                                                      shape:
                                                                          RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(10),
                                                                      ),
                                                                      elevation:
                                                                          0.0,
                                                                      child:
                                                                          SingleChildScrollView(
                                                                        child: Container(
                                                                            decoration: BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(15),
                                                                            ),
                                                                            // height: 552,
                                                                            width: 300,
                                                                            child: Column(
                                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                                              children: [
                                                                                Container(
                                                                                  child: Container(
                                                                                    margin: EdgeInsets.only(top: 10, bottom: 10, right: 170),
                                                                                    child: Text("Foto KTP", style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w800, fontFamily: "Nunito")),
                                                                                  ),
                                                                                ),
                                                                                // Divider(),
                                                                                Container(
                                                                                  child: ktp != null
                                                                                      ? Image.network(
                                                                                          '${Env().apiBaseUrl}/${ktp.url}',
                                                                                          height: 230,
                                                                                          width: 230,
                                                                                        )
                                                                                      : Container(
                                                                                          height: 180,
                                                                                          width: 180,
                                                                                          child: Image.asset(
                                                                                            "assets/images/no_ktp.png",
                                                                                          ),
                                                                                        ),
                                                                                ),
                                                                                Divider(),
                                                                                Container(
                                                                                  child: Container(
                                                                                    margin: EdgeInsets.only(top: 10, bottom: 10, right: 170),
                                                                                    child: Text("Foto Selfi", style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w800, fontFamily: "Nunito")),
                                                                                  ),
                                                                                ),

                                                                                Container(
                                                                                  child: selfi != null
                                                                                      ? Image.network(
                                                                                          '${Env().apiBaseUrl}/${selfi.url}',
                                                                                          height: 230,
                                                                                          width: 230,
                                                                                        )
                                                                                      : Container(
                                                                                          height: 180,
                                                                                          width: 180,
                                                                                          child: Image.asset(
                                                                                            "assets/images/no_ktp.png",
                                                                                          ),
                                                                                        ),
                                                                                ),
                                                                                Divider(),
                                                                                Container(
                                                                                  child: Container(
                                                                                    margin: EdgeInsets.only(top: 10, bottom: 10, right: 170),
                                                                                    child: Text("Keperluan", style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w800, fontFamily: "Nunito")),
                                                                                  ),
                                                                                ),

                                                                                Container(
                                                                                  width: Screen(size).wp(60),
                                                                                  child: Text(listData[index].necessity!, maxLines: 5, style: TextStyle(fontSize: 13, color: Colors.black, fontWeight: FontWeight.w700, fontFamily: "Nunito")),
                                                                                ),
                                                                                Divider(),
                                                                                InkWell(
                                                                                  onTap: () {
                                                                                    Navigator.pop(context);
                                                                                  },
                                                                                  child: Container(
                                                                                    margin: EdgeInsets.only(top: 10, bottom: 10, left: 180),
                                                                                    child: Text("Close", textAlign: TextAlign.end, style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w800, fontFamily: "Nunito")),
                                                                                  ),
                                                                                )
                                                                              ],
                                                                            )),
                                                                      ),
                                                                    );
                                                                  });
                                                            },
                                                            child: Container(
                                                              height: 100,
                                                              width: 70,
                                                              child: ktp != null
                                                                  ? Image
                                                                      .network(
                                                                      '${Env().apiBaseUrl}/${ktp.url}',
                                                                      height:
                                                                          30,
                                                                    )
                                                                  : Container(
                                                                      height:
                                                                          50,
                                                                      width: 50,
                                                                      child: Image
                                                                          .asset(
                                                                        "assets/images/no_ktp.png",
                                                                      ),
                                                                    ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ],
                                                  ))
                                              : Container(),
                                          SizedBox(
                                            height: 20,
                                          )
                                        ],
                                      )));
                            }, childCount: listData.length),
                          )
                        ],
                      ),
                    );
                  },
                ),
              )
            ],
          ))),
    );
  }
}
