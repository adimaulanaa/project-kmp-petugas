import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:kmp_petugas_app/env.dart';
import 'package:kmp_petugas_app/features/guest_book/data/models/guest_book_model.dart';
import 'package:kmp_petugas_app/features/guest_book/presentation/bloc/bloc.dart';
import 'package:kmp_petugas_app/features/guest_book/presentation/pages/add_guest_book.dart';
import 'package:kmp_petugas_app/features/home/presentation/pages/home_page.dart';
import 'package:kmp_petugas_app/framework/managers/helper.dart';
import 'package:kmp_petugas_app/framework/widgets/loading_indicator.dart';
import 'package:kmp_petugas_app/service_locator.dart';
import 'package:intl/intl.dart';
import 'package:kmp_petugas_app/theme/size.dart';

class GustBookScreen extends StatefulWidget {
  GustBookScreen({Key? key}) : super(key: key);

  @override
  _GustBookScreenState createState() => _GustBookScreenState();
}

class _GustBookScreenState extends State<GustBookScreen> {
  //
  String message = '';
  bool isInternetConnected = true;
  List<Doc> listData = [];
  bool isLoading = false;
  bool detail = false;
  String? tgl;

  TextEditingController editingController = TextEditingController();
  bool isSearch = false;
  List<Doc> dummySearchList = [];
  List<Doc> searchList = [];

  void searchResults(String value) {
    dummySearchList.clear();
    dummySearchList.addAll(listData);
    isSearch = true;
    if (value.isNotEmpty) {
      searchList.clear();
      dummySearchList.forEach((item) {
        print("------------- $value");

        if (item.name!.toString().toUpperCase().contains(value.toUpperCase())) {
          print("-------------2 $value");
          searchList.add(item);
        }
      });

      setState(() {});
      return;
    } else {
      setState(() {
        searchList.clear();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    //
    BlocProvider.of<GuestBookBloc>(context).add(LoadGuestBook());
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
    return BlocListener<GuestBookBloc, GuestBookState>(
      listener: (context, state) async {
        if (state is GuestBookLoading) {
          isLoading = false;
          setState(() {});
        } else if (state is GuestBookLoaded) {
          if (state.data != null) {
            if (state.data!.paginate!.docs!.length > 0) {
              listData = state.data!.paginate!.docs!;
              isLoading = true;
              setState(() {});
            } else {
              isLoading = true;
              setState(() {});
            }
          }
        } else if (state is GuestBookFailure) {
          catchAllException(context, state.error, true);
          setState(() {});
        }
      },
      child: isLoading
          ? isSearch
              ? _buildBodySearch(context)
              : _buildBody(context)
          : LoadingIndicator(),
    );
  }

  Widget _buildBody(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        context.push(HomePage());
        return true;
      },
      child: Scaffold(
        backgroundColor: Color(0xffF8F8F8),
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              elevation: 0,
              leading: Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => HomePage()));
                    },
                    child: Container(
                      margin: EdgeInsets.only(left: 20),
                      padding: EdgeInsets.all(10),
                      height: 33,
                      width: 33,
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              spreadRadius: 1.5,
                              blurRadius: 15,
                              offset: Offset(0, 1),
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
              actions: [
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          isSearch = true;
                        });
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
                                offset: Offset(0, 1),
                              ),
                            ],
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.white),
                        child: SvgPicture.asset(
                          "assets/icon/search.svg",
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 25,
                    ),
                  ],
                )
              ],
              automaticallyImplyLeading: false,
              pinned: true,
              expandedHeight: 110,
              backgroundColor: Color(0xffF8F8F8),
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: false,
                title: Text('Buku Tamu',
                    style: TextStyle(
                        fontFamily: "Nunito",
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Colors.black.withOpacity(0.8),
                        fontStyle: FontStyle.normal)),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 30,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 25),
                        child: Text(
                          "Lihat Riwayat Daftar Tamu",
                          style: TextStyle(
                              fontFamily: "Nunito",
                              fontWeight: FontWeight.w400,
                              color: Color(0xff979797),
                              fontSize: 12,
                              fontStyle: FontStyle.normal),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      )
                    ]),
              ),
            ),
            SliverList(
              delegate:
                  SliverChildBuilderDelegate((BuildContext context, int index) {
                return Column(
                  children: [
                    Container(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: customListGuestBook(context, index),
                        )),
                  ],
                );
              }, childCount: listData.length),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color(0xffF54748),
          onPressed: () async {
            await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => BlocProvider(
                          create: (context) =>
                              serviceLocator.get<GuestBookBloc>(),
                          child: ProgressHUD(child: AddGuestBookScreen()),
                        )));
            BlocProvider.of<GuestBookBloc>(context).add(LoadGuestBook());
          },
          child: SvgPicture.asset(
            "assets/icon/arrow-add.svg",
            color: Color(0xffFFFFFF),
          ),
        ),
      ),
    );
  }

  Widget _buildBodySearch(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF8F8F8),
      body: CustomScrollView(slivers: [
        SliverAppBar(
          elevation: 0,
          leading: Row(
            children: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  margin: EdgeInsets.only(left: 20),
                  padding: EdgeInsets.all(10),
                  height: 33,
                  width: 33,
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          spreadRadius: 1.5,
                          blurRadius: 15,
                          offset: Offset(0, 1),
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
          actions: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.only(top: 10),
                  height: 50,
                  width: 200,
                  child: TextField(
                      style: TextStyle(
                          fontFamily: "Nunito",
                          fontWeight: FontWeight.w700,
                          color: Color(0XFF121212).withOpacity(0.8),
                          fontSize: 16,
                          fontStyle: FontStyle.normal),
                      onChanged: (value) {
                        searchResults(value);
                      },
                      controller: editingController,
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: "Cari...",
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                            fontFamily: "Nunito",
                            fontWeight: FontWeight.w700,
                            color: Color(0XFF121212).withOpacity(0.38),
                            fontSize: 16,
                            fontStyle: FontStyle.normal),
                      )),
                ),
                SizedBox(
                  width: 25,
                ),
                Container(
                  margin: EdgeInsets.only(right: 20, top: 6),
                  padding: EdgeInsets.all(10),
                  height: 33,
                  width: 33,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        isSearch = false;
                        editingController.text = '';
                        searchList.clear();
                      });
                    },
                    child: SvgPicture.asset(
                      "assets/icon/close.svg",
                      color: Colors.black,
                    ),
                  ),
                )
              ],
            )
          ],
          automaticallyImplyLeading: false,
          pinned: true,
          expandedHeight: 110,
          backgroundColor: Color(0xffF8F8F8),
        ),
        SliverList(
          delegate:
              SliverChildBuilderDelegate((BuildContext context, int index) {
            return Column(
              children: [
                Container(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: customListGuestBookSearch(context, index),
                    )),
              ],
            );
          }, childCount: searchList.length),
        )
      ]),
    );
  }

  Widget customListGuestBook(BuildContext context, int index) {
    Size size = MediaQuery.of(context).size;
    var outputFormat = DateFormat('hh:mm a');
    var formattedTime =
        outputFormat.format(listData[index].acceptedAt!.toLocal());

    DateFormat date = DateFormat.yMMMMd();
    DateTime satDate = DateTime.parse(listData[index].acceptedAt.toString());
    String tgl = date.format(satDate.toLocal());

    var ktp = listData[index].idCardFile;
    var selfi = listData[index].selfieFile;
    return Container(
        padding: EdgeInsets.only(top: 5, bottom: 10),
        child: Container(
            decoration: BoxDecoration(
              color: Color(0xffFFFFFF),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.only(left: 15, right: 15, top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(tgl,
                          style: TextStyle(
                              fontSize: 12,
                              color: Color(0xff979797),
                              fontWeight: FontWeight.w400,
                              fontFamily: "Nunito")),
                      Text(formattedTime,
                          style: TextStyle(
                              fontSize: 12,
                              color: Color(0xff979797),
                              fontWeight: FontWeight.w800,
                              fontFamily: "Nunito"))
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 15, right: 15, top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Nama Tamu",
                          style: TextStyle(
                              fontSize: 11,
                              color: Color(0xff979797),
                              fontWeight: FontWeight.w400,
                              fontFamily: "Nunito")),
                      Text("Rumah Tujuan",
                          style: TextStyle(
                              fontSize: 11,
                              color: Color(0xff979797),
                              fontWeight: FontWeight.w400,
                              fontFamily: "Nunito"))
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 15, right: 15, top: 7),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(listData[index].name!,
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                              fontWeight: FontWeight.w800,
                              fontFamily: "Nunito")),
                      Text(listData[index].citizenName!,
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                              fontWeight: FontWeight.w800,
                              fontFamily: "Nunito"))
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 15, right: 15, top: 7),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text("Jumlah Tamu",
                              style: TextStyle(
                                  fontSize: 11,
                                  color: Color(0xff979797),
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "Nunito")),
                          Container(
                            margin: EdgeInsets.only(top: 5),
                            child: Text(listData[index].guestCount.toString(),
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w800,
                                    fontFamily: "Nunito")),
                          ),
                        ],
                      ),
                      Text(
                          listData[index].houseBlock! +
                              '-' +
                              listData[index].houseNumber!,
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                              fontWeight: FontWeight.w800,
                              fontFamily: "Nunito"))
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      listData[index].open = !listData[index].open!;
                    });
                  },
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      padding: EdgeInsets.only(
                          right: 189, left: 15, top: 19, bottom: 10),
                      child: !listData[index].open!
                          ? Text("Klik untuk melihat detail",
                              style: TextStyle(
                                  fontSize: 10,
                                  color: Color(0xffF54748),
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "Nunito"))
                          : Container(
                              child: Text("Tutup",
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: Color(0xffF54748),
                                      fontWeight: FontWeight.w400,
                                      fontFamily: "Nunito")),
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Keperluan",
                                    style: TextStyle(
                                        fontSize: 11,
                                        color: Color(0xff979797),
                                        fontWeight: FontWeight.w400,
                                        fontFamily: "Nunito")),
                                Container(
                                  width: Screen(size).wp(60),
                                  child: Text(listData[index].necessity!,
                                      maxLines: 5,
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700,
                                          fontFamily: "Nunito")),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text("Foto KTP",
                                    style: TextStyle(
                                        fontSize: 11,
                                        color: Color(0xff979797),
                                        fontWeight: FontWeight.w400,
                                        fontFamily: "Nunito")),
                                InkWell(
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return Dialog(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            elevation: 0.0,
                                            child: SingleChildScrollView(
                                              child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                  ),
                                                  // height: 552,
                                                  width: 300,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                        child: Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  top: 10,
                                                                  bottom: 10,
                                                                  right: 170),
                                                          child: Text(
                                                              "Foto KTP",
                                                              style: TextStyle(
                                                                  fontSize: 15,
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w800,
                                                                  fontFamily:
                                                                      "Nunito")),
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
                                                                child:
                                                                    Image.asset(
                                                                  "assets/images/no_ktp.png",
                                                                ),
                                                              ),
                                                      ),
                                                      Divider(),
                                                      Container(
                                                        child: Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  top: 10,
                                                                  bottom: 10,
                                                                  right: 170),
                                                          child: Text(
                                                              "Foto Selfi",
                                                              style: TextStyle(
                                                                  fontSize: 15,
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w800,
                                                                  fontFamily:
                                                                      "Nunito")),
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
                                                                child:
                                                                    Image.asset(
                                                                  "assets/images/no_ktp.png",
                                                                ),
                                                              ),
                                                      ),
                                                      Divider(),
                                                      Container(
                                                        child: Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  top: 10,
                                                                  bottom: 10,
                                                                  right: 170),
                                                          child: Text(
                                                              "Keperluan",
                                                              style: TextStyle(
                                                                  fontSize: 15,
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w800,
                                                                  fontFamily:
                                                                      "Nunito")),
                                                        ),
                                                      ),

                                                      Container(
                                                        width:
                                                            Screen(size).wp(60),
                                                        child: Text(
                                                            listData[index]
                                                                .necessity!,
                                                            maxLines: 5,
                                                            style: TextStyle(
                                                                fontSize: 13,
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                fontFamily:
                                                                    "Nunito")),
                                                      ),
                                                      Divider(),
                                                      InkWell(
                                                        onTap: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  top: 10,
                                                                  bottom: 10,
                                                                  left: 180),
                                                          child: Text("Close",
                                                              textAlign:
                                                                  TextAlign.end,
                                                              style: TextStyle(
                                                                  fontSize: 15,
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w800,
                                                                  fontFamily:
                                                                      "Nunito")),
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
                                        ? Image.network(
                                            '${Env().apiBaseUrl}/${ktp.url}',
                                            height: 30,
                                          )
                                        : Container(
                                            height: 50,
                                            width: 50,
                                            child: Image.asset(
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
              ],
            )));
  }

  Widget customListGuestBookSearch(BuildContext context, int index) {
    Size size = MediaQuery.of(context).size;
    var outputFormat = DateFormat('hh:mm a');
    var formattedTime =
        outputFormat.format(searchList[index].acceptedAt!.toLocal());

    DateFormat date = DateFormat.yMMMMd();
    DateTime satDate = DateTime.parse(searchList[index].acceptedAt.toString());
    String tgl = date.format(satDate.toLocal());

    var ktp = searchList[index].idCardFile;
    var selfi = searchList[index].selfieFile;
    return Container(
        padding: EdgeInsets.only(top: 5, bottom: 10),
        decoration: BoxDecoration(
          color: Color(0xffFFFFFF),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(left: 15, right: 15, top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(tgl,
                      style: TextStyle(
                          fontSize: 12,
                          color: Color(0xff979797),
                          fontWeight: FontWeight.w400,
                          fontFamily: "Nunito")),
                  Text(formattedTime,
                      style: TextStyle(
                          fontSize: 12,
                          color: Color(0xff979797),
                          fontWeight: FontWeight.w800,
                          fontFamily: "Nunito"))
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 15, right: 15, top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Nama Tamu",
                      style: TextStyle(
                          fontSize: 11,
                          color: Color(0xff979797),
                          fontWeight: FontWeight.w400,
                          fontFamily: "Nunito")),
                  Text("Rumah Tujuan",
                      style: TextStyle(
                          fontSize: 11,
                          color: Color(0xff979797),
                          fontWeight: FontWeight.w400,
                          fontFamily: "Nunito"))
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 15, right: 15, top: 7),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(searchList[index].name!,
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.w800,
                          fontFamily: "Nunito")),
                  Text(searchList[index].acceptedByName!,
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.w800,
                          fontFamily: "Nunito"))
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 15, right: 15, top: 7),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Jumlah Tamu",
                          style: TextStyle(
                              fontSize: 11,
                              color: Color(0xff979797),
                              fontWeight: FontWeight.w400,
                              fontFamily: "Nunito")),
                      Container(
                        margin: EdgeInsets.only(top: 5),
                        child: Text(searchList[index].guestCount.toString(),
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                                fontWeight: FontWeight.w800,
                                fontFamily: "Nunito")),
                      ),
                    ],
                  ),
                  Text(
                      searchList[index].houseBlock! +
                          '-' +
                          searchList[index].houseNumber!,
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.w800,
                          fontFamily: "Nunito"))
                ],
              ),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  searchList[index].open = !searchList[index].open!;
                });
              },
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  padding: EdgeInsets.only(
                      right: 220, left: 15, top: 19, bottom: 10),
                  child: !searchList[index].open!
                      ? Text("Klik untuk melihat detail",
                          style: TextStyle(
                              fontSize: 10,
                              color: Color(0xffF54748),
                              fontWeight: FontWeight.w400,
                              fontFamily: "Nunito"))
                      : Container(
                          child: Text("Tutup",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontSize: 10,
                                  color: Color(0xffF54748),
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "Nunito")),
                        ),
                ),
              ),
            ),
            searchList[index].open!
                ? Container(
                    padding: EdgeInsets.only(
                      right: 15,
                      left: 15,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Keperluan",
                                style: TextStyle(
                                    fontSize: 11,
                                    color: Color(0xff979797),
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "Nunito")),
                            Container(
                              width: Screen(size).wp(60),
                              child: Text(searchList[index].necessity!,
                                  maxLines: 5,
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: "Nunito")),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text("Foto KTP",
                                style: TextStyle(
                                    fontSize: 11,
                                    color: Color(0xff979797),
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "Nunito")),
                            InkWell(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return Dialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        elevation: 0.0,
                                        child: SingleChildScrollView(
                                          child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                              // height: 552,
                                              width: 300,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    child: Container(
                                                      margin: EdgeInsets.only(
                                                          top: 10,
                                                          bottom: 10,
                                                          right: 170),
                                                      child: Text("Foto KTP",
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
                                                      margin: EdgeInsets.only(
                                                          top: 10,
                                                          bottom: 10,
                                                          right: 170),
                                                      child: Text("Foto Selfi",
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
                                                      margin: EdgeInsets.only(
                                                          top: 10,
                                                          bottom: 10,
                                                          right: 170),
                                                      child: Text("Keperluan",
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
                                                  ),

                                                  Container(
                                                    width: Screen(size).wp(60),
                                                    child: Text(
                                                        searchList[index]
                                                            .necessity!,
                                                        maxLines: 5,
                                                        style: TextStyle(
                                                            fontSize: 13,
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            fontFamily:
                                                                "Nunito")),
                                                  ),
                                                  Divider(),
                                                  InkWell(
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: Container(
                                                      margin: EdgeInsets.only(
                                                          top: 10,
                                                          bottom: 10,
                                                          left: 180),
                                                      child: Text("Close",
                                                          textAlign:
                                                              TextAlign.end,
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
                                    ? Image.network(
                                        '${Env().apiBaseUrl}/${ktp.url}',
                                        height: 30,
                                      )
                                    : Container(
                                        height: 50,
                                        width: 50,
                                        child: Image.asset(
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
          ],
        ));
  }

  //
}
