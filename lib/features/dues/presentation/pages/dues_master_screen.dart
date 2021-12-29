import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kmp_petugas_app/features/dues/data/models/house_model.dart';
import 'package:kmp_petugas_app/features/dues/presentation/bloc/bloc.dart';
import 'package:kmp_petugas_app/features/dues/presentation/pages/detail_dues_screen.dart';
import 'package:kmp_petugas_app/framework/managers/helper.dart';
import 'package:kmp_petugas_app/framework/widgets/loading_indicator.dart';
import 'package:kmp_petugas_app/service_locator.dart';

class DuesMasterScreen extends StatefulWidget {
  const DuesMasterScreen({Key? key}) : super(key: key);

  @override
  _DuesMasterScreenState createState() => _DuesMasterScreenState();
}

class _DuesMasterScreenState extends State<DuesMasterScreen> {
  String message = '';
  bool isInternetConnected = true;
  List<Houses> listData = [];
  bool isLoading = false;
  bool isSearch = false;
  List<Houses> dummySearchList = [];
  List<Houses> searchList = [];
  TextEditingController editingController = TextEditingController();
  void searchResults(String value) {
    print(1);
    dummySearchList.clear();
    dummySearchList.addAll(listData);
    isSearch = true;
    if (value.isNotEmpty) {
      searchList.clear();
      dummySearchList.forEach((item) {
        setState(() {
          if (item.citizenName
              .toString()
              .toUpperCase()
              .contains(value.toUpperCase())) {
            searchList.add(item);
          }
        });
      });
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

    BlocProvider.of<DuesBloc>(context).add(LoadHouseEvent());
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
    return BlocListener<DuesBloc, DuesState>(
      listener: (context, state) async {
        if (state is HouseListLoading) {
          isLoading = false;
        } else if (state is HouseListLoaded) {
          if (state.houseData != null &&
              state.houseData!.paginate!.docs!.length > 0) {
            listData = state.houseData!.paginate!.docs!;
          }
          isLoading = true;
          setState(() {});
        } else if (state is DuesFailure) {
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
    return Scaffold(
      backgroundColor: Color(0xffF8F8F8),
      body: CustomScrollView(
        slivers: [
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
                              offset:
                                  Offset(0, 1), // changes position of shadow
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
                  // Container(
                  //   margin: EdgeInsets.only(right: 20),
                  //   padding: EdgeInsets.all(10),
                  //   height: 33,
                  //   width: 33,
                  //   decoration: BoxDecoration(
                  //       boxShadow: [
                  //         BoxShadow(
                  //           color: Colors.black.withOpacity(0.05),
                  //           spreadRadius: 1.5,
                  //           blurRadius: 15,
                  //           offset: Offset(0, 1), // changes position of shadow
                  //         ),
                  //       ],
                  //       borderRadius: BorderRadius.circular(16),
                  //       color: Colors.white),
                  //   child: SvgPicture.asset(
                  //     "assets/icon/setting.svg",
                  //     color: Colors.black,
                  //   ),
                  // ),
                ],
              )
            ],
            automaticallyImplyLeading: false,
            pinned: true,
            expandedHeight: 110,
            backgroundColor: Color(0xffF8F8F8),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                "Iuran Warga",
                style: TextStyle(
                    fontFamily: "Nunito",
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                    fontSize: 22,
                    fontStyle: FontStyle.normal),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 30,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 25),
                      child: Text(
                        "kelola Iuran Warga",
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
                        child: customListIuran(context, index),
                      )),
                ],
              );
            }, childCount: listData.length),
          ),
        ],
      ),
    );
  }

  Widget _buildBodySearch(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF8F8F8),
      body: CustomScrollView(
        slivers: [
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
                          print(value);
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
                        child: customListIuran(context, index),
                      )),
                ],
              );
            }, childCount: searchList.length),
          ),
        ],
      ),
    );
  }

  Widget customListIuran(BuildContext context, int index) {
    return InkWell(
      onTap: () async {
        await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => BlocProvider(
                      create: (context) => serviceLocator.get<DuesBloc>(),
                      child: ProgressHUD(
                          child: DetailDuesScreen(
                        idHouse: listData[index].id,
                        duesYear: DateTime.now().year,
                        name: listData[index].citizenName,
                        address: listData[index].houseAddress,
                        phone: listData[index].citizenPhone,
                        bloc: listData[index].houseBlock,
                        number: listData[index].houseNumber,
                      )),
                    )));
        BlocProvider.of<DuesBloc>(context).add(LoadHouseEvent());
      },
      child: Container(
        width: double.infinity,
        height: 96,
        child: Row(
          children: [
            Container(
              alignment: Alignment.center,
              width: 5,
              height: 90,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: listData[index].isActive == true
                      ? Color(0xffF54748)
                      : Color(0xffC4C4C4)),
            ),
            SizedBox(
              width: 2,
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                height: 96,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(5),
                        topLeft: Radius.circular(6),
                        topRight: Radius.circular(16),
                        bottomRight: Radius.circular(16))),
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 17,
                    right: 20,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              padding: EdgeInsets.only(top: 18),
                              child: Text(
                                listData[index].houseBlock != null
                                    ? listData[index].houseBlock! +
                                        " - " +
                                        listData[index].houseNumber!
                                    : "",
                                style: TextStyle(
                                    fontFamily: "Nunito",
                                    fontWeight: FontWeight.w800,
                                    color: Colors.black.withOpacity(0.8),
                                    fontSize: 18,
                                    fontStyle: FontStyle.normal),
                              )),
                          Container(
                              child: Text(
                            "Penghuni",
                            style: TextStyle(
                                fontFamily: "Nunito",
                                fontWeight: FontWeight.w400,
                                color: Color(0xffC4C4C4),
                                fontSize: 10,
                                fontStyle: FontStyle.normal),
                          )),
                          Container(
                              child: Text(
                            listData[index].citizenName != null
                                ? listData[index].citizenName!
                                : "",
                            style: TextStyle(
                                fontFamily: "Nunito",
                                fontWeight: FontWeight.w700,
                                color: Color(0XFF121212),
                                fontSize: 12,
                                fontStyle: FontStyle.normal),
                          )),
                        ],
                      ),
                      Icon(Icons.chevron_right)
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget customListIuranSearch(BuildContext context, int index) {
    return InkWell(
      onTap: () async {
        await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => BlocProvider(
                      create: (context) => serviceLocator.get<DuesBloc>(),
                      child: ProgressHUD(
                          child: DetailDuesScreen(
                        idHouse: listData[index].id,
                        duesYear: DateTime.now().year,
                        name: listData[index].citizenName,
                        address: listData[index].houseAddress,
                        phone: listData[index].citizenPhone,
                        bloc: listData[index].houseBlock,
                        number: listData[index].houseNumber,
                      )),
                    )));
        BlocProvider.of<DuesBloc>(context).add(LoadHouseEvent());
      },
      child: Container(
        width: double.infinity,
        height: 96,
        child: Row(
          children: [
            Container(
              alignment: Alignment.center,
              width: 5,
              height: 90,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: listData[index].isActive == true
                      ? Color(0xffF54748)
                      : Color(0xffC4C4C4)),
            ),
            SizedBox(
              width: 2,
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                height: 96,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(5),
                        topLeft: Radius.circular(6),
                        topRight: Radius.circular(16),
                        bottomRight: Radius.circular(16))),
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 17,
                    right: 20,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              padding: EdgeInsets.only(top: 18),
                              child: Text(
                                listData[index].houseBlock != null
                                    ? listData[index].houseBlock! +
                                        " - " +
                                        listData[index].houseNumber!
                                    : "",
                                style: TextStyle(
                                    fontFamily: "Nunito",
                                    fontWeight: FontWeight.w800,
                                    color: Colors.black.withOpacity(0.8),
                                    fontSize: 18,
                                    fontStyle: FontStyle.normal),
                              )),
                          Container(
                              child: Text(
                            "Penghuni",
                            style: TextStyle(
                                fontFamily: "Nunito",
                                fontWeight: FontWeight.w400,
                                color: Color(0xffC4C4C4),
                                fontSize: 10,
                                fontStyle: FontStyle.normal),
                          )),
                          Container(
                              child: Text(
                            listData[index].citizenName != null
                                ? listData[index].citizenName!
                                : "",
                            style: TextStyle(
                                fontFamily: "Nunito",
                                fontWeight: FontWeight.w700,
                                color: Color(0XFF121212),
                                fontSize: 12,
                                fontStyle: FontStyle.normal),
                          )),
                        ],
                      ),
                      Icon(Icons.chevron_right)
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
