import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kmp_petugas_app/env.dart';
import 'package:kmp_petugas_app/features/authentication/data/models/user_model.dart';
import 'package:kmp_petugas_app/features/dashboard/presentation/bloc/bloc.dart';
import 'package:kmp_petugas_app/features/profile/presentation/bloc/bloc.dart';
import 'package:kmp_petugas_app/features/profile/presentation/pages/edit_password_screen.dart';
import 'package:kmp_petugas_app/features/profile/presentation/pages/edit_profile_screen.dart';
import 'package:kmp_petugas_app/framework/managers/helper.dart';
import 'package:kmp_petugas_app/framework/widgets/loading_indicator.dart';
import 'package:kmp_petugas_app/service_locator.dart';
import 'package:kmp_petugas_app/theme/colors.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool info = true;
  bool infoKampung = false;

  bool isLoading = false;
  String clientName = '';
  UserModel? dataProfile;
  // Client? profile;
  Assignment? alamat;
  String kec = '';
  String kel = '';
  String kab = '';
  String prov = '';
  // SessionModel? session;
  Officer? officers;
  UserModel? profileModel;

  @override
  void initState() {
    BlocProvider.of<ProfileBloc>(context).add(GetProfileEvent());
    super.initState();
  }

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
        } else if (state is ProfileLoaded) {
          setState(() {
            if (state.data != null) {
              dataProfile = state.data;
              officers = state.data!.officer;
              kec = officers!.subDistrictName!;
              kel = officers!.districtName!;
              kab = officers!.cityName!;
              prov = officers!.provinceName!;
              // }
            }
            isLoading = true;
          });
        } else if (state is ProfileFailure) {
          catchAllException(context, state.error, true);
          setState(() {});
        } else if (state is EditProfileSuccess) {
          BlocProvider.of<ProfileBloc>(context).add(GetProfileEvent());
          serviceLocator.get<DashboardBloc>().add(LoadDashboard());
          setState(() {});
        }
      },
      child: isLoading ? _buildBody(context) : LoadingIndicator(),
    );
  }

  Widget _buildBody(BuildContext context) {
    var foto = dataProfile!.avatar;
    return Scaffold(
      backgroundColor: Color(0xffF54748),
      appBar: AppBar(
        toolbarHeight: 80,
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
              Row(children: [
                Text(
                  "Profil",
                  style: TextStyle(
                      fontFamily: "Nunito",
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w800,
                      fontSize: 20,
                      color: Colors.white),
                )
              ]),
              InkWell(
                onTap: () async {
                  await pushNewScreen(
                    context,
                    screen: BlocProvider(
                      create: (context) => serviceLocator.get<ProfileBloc>(),
                      child: ProgressHUD(
                        child: EditProfile(
                          data: officers,
                        ),
                      ),
                    ),
                    withNavBar: false,
                    pageTransitionAnimation: PageTransitionAnimation.cupertino,
                  );
                  BlocProvider.of<ProfileBloc>(context).add(GetProfileEvent());
                },
                child: Container(
                  padding: EdgeInsets.all(5),
                  height: 33,
                  width: 33,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(16)),
                  child: SvgPicture.asset("assets/icon/edit-user.svg"),
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
              Center(
                child: dataProfile!.avatar!.isNotEmpty
                    ? CircleAvatar(
                        radius: 75,
                        backgroundColor: Colors.white,
                        backgroundImage: NetworkImage(
                          '${Env().apiBaseUrl}/${foto!}',
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
                height: 12,
              ),
              Text(
                dataProfile!.name!,
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: "Nunito",
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.normal,
                  fontSize: 18,
                ),
              ),
              Container(
                  margin: EdgeInsets.only(top: 9),
                  height: 36,
                  width: 224,
                  decoration: BoxDecoration(
                    color: Color(0xffDD4041),
                    borderRadius: BorderRadius.circular(39),
                  ),
                  child: Center(
                    child: Text(
                      dataProfile!.officer!.positionName!,
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: "Nunito",
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.normal,
                        fontSize: 13,
                      ),
                    ),
                  ))
            ],
          ),
          //
          // bagian bawah
          SizedBox.expand(
            child: DraggableScrollableSheet(
              initialChildSize: 0.54,
              minChildSize: 0.54,
              maxChildSize: 1,
              builder: (BuildContext c, s) {
                return Container(
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
                                  const EdgeInsets.only(top: 10, bottom: 10),
                              child: SvgPicture.asset("assets/icon/line.svg"),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 20, right: 20),
                              width: MediaQuery.of(context).size.width * 0.9,
                              height: 48,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Color(0xffE5E5E5).withOpacity(0.5)),
                              child: Row(children: [
                                Flexible(
                                  //!Info
                                  child: InkWell(
                                      child: Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.45,
                                    height: 48,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: info == false
                                            ? Colors.transparent
                                            : ColorPalette.primary),
                                    child: TextButton(
                                        onPressed: () {
                                          setState(() {
                                            info = true;
                                            infoKampung = false;
                                          });
                                        },
                                        child: Text(
                                          "Info",
                                          style: TextStyle(
                                              fontFamily: "Nunito",
                                              fontWeight: FontWeight.w700,
                                              fontSize: 14,
                                              color: info == false
                                                  ? Color(0xffC4C4C4)
                                                  : Colors.white),
                                        )),
                                  )),
                                ),
                                Flexible(
                                  //!Info Kampung
                                  child: InkWell(
                                      child: Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.45,
                                    height: 48,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: infoKampung == false
                                            ? Colors.transparent
                                            : ColorPalette.primary),
                                    child: TextButton(
                                        onPressed: () {
                                          setState(() {
                                            info = false;
                                            infoKampung = true;
                                          });
                                        },
                                        child: Text(
                                          "Info Kampung",
                                          style: TextStyle(
                                              fontFamily: "Nunito",
                                              fontWeight: FontWeight.w700,
                                              fontSize: 14,
                                              color: infoKampung == false
                                                  ? Color(0xffC4C4C4)
                                                  : Colors.white),
                                        )),
                                  )),
                                ),
                              ]),
                            ),
                          ],
                        ),
                      ),
                      SliverList(
                          delegate: SliverChildListDelegate([
                        info
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                      margin: EdgeInsets.only(top: 19),
                                      width: MediaQuery.of(context).size.width *
                                          0.9,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Nomor Whatsapp",
                                            style: TextStyle(
                                                fontFamily: "Nunito",
                                                fontWeight: FontWeight.w400,
                                                fontSize: 12,
                                                color: Color(0xffBEC2C9)),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(top: 4),
                                            child: Text(
                                              dataProfile!.phone! == ""
                                                  ? " - "
                                                  : dataProfile!.phone!,
                                              style: TextStyle(
                                                  fontFamily: "Nunito",
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 15,
                                                  color: Colors.black),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 7,
                                          ),
                                          Text(
                                            "Email",
                                            style: TextStyle(
                                                fontFamily: "Nunito",
                                                fontWeight: FontWeight.w400,
                                                fontSize: 12,
                                                color: Color(0xffBEC2C9)),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(top: 4),
                                            child: Text(
                                              dataProfile!.email! == ""
                                                  ? " - "
                                                  : dataProfile!.email!,
                                              style: TextStyle(
                                                  fontFamily: "Nunito",
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 15,
                                                  color: Colors.black),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 17, bottom: 17),
                                            child: Divider(
                                              color: Color(0xff979797)
                                                  .withOpacity(0.25),
                                              thickness: 2,
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () async {
                                              await pushNewScreen(
                                                context,
                                                screen: BlocProvider(
                                                  create: (context) =>
                                                      serviceLocator
                                                          .get<ProfileBloc>(),
                                                  child: ProgressHUD(
                                                      child:
                                                          EditPasswordScreen()),
                                                ),
                                                withNavBar: false,
                                                pageTransitionAnimation:
                                                    PageTransitionAnimation
                                                        .cupertino,
                                              );
                                              BlocProvider.of<ProfileBloc>(
                                                      context)
                                                  .add(GetProfileEvent());
                                            },
                                            child: Container(
                                              padding:
                                                  EdgeInsets.only(right: 17),
                                              decoration: BoxDecoration(
                                                color: Colors.transparent,
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    "Ubah Password",
                                                    style: TextStyle(
                                                        fontFamily: "Nunito",
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontSize: 15,
                                                        color: Colors.black
                                                            .withOpacity(0.8)),
                                                  ),
                                                  SvgPicture.asset(
                                                    "assets/icon/arrow-right.svg",
                                                    color: Colors.black
                                                        .withOpacity(0.8),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              logout(context);
                                            },
                                            child: Container(
                                              margin: EdgeInsets.only(top: 22),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.9,
                                              height: 49,
                                              decoration: BoxDecoration(
                                                color: Color(0xffF54748),
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Container(
                                                    padding: EdgeInsets.only(
                                                        left: 20),
                                                    child: Text(
                                                      'Logout',
                                                      style: TextStyle(
                                                        fontFamily: "Nunito",
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontSize: 15,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    padding: EdgeInsets.only(
                                                        right: 20),
                                                    child: SvgPicture.asset(
                                                        "assets/icon/logout.svg"),
                                                  )
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      )),
                                ],
                              )
                            : SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(top: 21),
                                      width: MediaQuery.of(context).size.width *
                                          0.9,
                                      // height: 90,
                                      decoration: BoxDecoration(
                                        color: Color(0xffF54748),
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(top: 16),
                                            child: Center(
                                              child: Text(
                                                officers!.name!,
                                                style: TextStyle(
                                                    fontFamily: "Nunito",
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 18,
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(
                                                top: 15, bottom: 15),
                                            child: Text(
                                              // "Taman Royal 3 Kota Tangerang, Banten",
                                              kec +
                                                  ", " +
                                                  kel +
                                                  ", " +
                                                  kab +
                                                  ", " +
                                                  prov +
                                                  ", ",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontFamily: "Nunito",
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 14,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Container(
                                    //   margin: EdgeInsets.only(top: 27),
                                    //   width: MediaQuery.of(context).size.width *
                                    //       0.9,
                                    //   child: Text(
                                    //     "RT Cluster Edelweiss",
                                    //     textAlign: TextAlign.left,
                                    //     style: TextStyle(
                                    //         fontFamily: "Nunito",
                                    //         fontWeight: FontWeight.w700,
                                    //         fontSize: 15,
                                    //         color: Colors.black),
                                    //   ),
                                    // ),
                                    // Container(
                                    //   height: 240,
                                    //   width: MediaQuery.of(context).size.width *
                                    //       0.9,
                                    //   child: ListView.builder(
                                    //     // physics:
                                    //     //     const NeverScrollableScrollPhysics(),
                                    //     itemCount: daftar.length,
                                    //     itemBuilder:
                                    //         (BuildContext context, index) {
                                    //       return InkWell(
                                    //         child: Container(
                                    //           height: 52,
                                    //           margin: EdgeInsets.only(top: 12),
                                    //           decoration: BoxDecoration(
                                    //             color: Color(0xffFFFFFF),
                                    //             borderRadius:
                                    //                 BorderRadius.circular(14),
                                    //           ),
                                    //           child: Row(
                                    //             mainAxisAlignment:
                                    //                 MainAxisAlignment
                                    //                     .spaceBetween,
                                    //             children: [
                                    //               Container(
                                    //                 padding: EdgeInsets.only(
                                    //                     left: 20),
                                    //                 child: Text(
                                    //                   daftar[index]['nama'],
                                    //                   style: TextStyle(
                                    //                     fontFamily: "Nunito",
                                    //                     fontWeight:
                                    //                         FontWeight.w700,
                                    //                     fontSize: 15,
                                    //                     color: Colors.black,
                                    //                   ),
                                    //                 ),
                                    //               ),
                                    //               Container(
                                    //                 padding: EdgeInsets.only(
                                    //                     right: 20),
                                    //                 child: Text(
                                    //                   daftar[index]['ketua'],
                                    //                   style: TextStyle(
                                    //                     fontFamily: "Nunito",
                                    //                     fontWeight:
                                    //                         FontWeight.w700,
                                    //                     fontSize: 15,
                                    //                     color:
                                    //                         Color(0xffCCCED3),
                                    //                   ),
                                    //                 ),
                                    //               ),
                                    //             ],
                                    //           ),
                                    //         ),
                                    //       );
                                    //     },
                                    //   ),
                                    // )
                                  ],
                                ),
                              )
                      ]))
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
}
