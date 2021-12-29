import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class ChartDashboard extends StatefulWidget {
  ChartDashboard({Key? key}) : super(key: key);

  @override
  _ChartDashboardState createState() => _ChartDashboardState();
}

class _ChartDashboardState extends State<ChartDashboard> {
  final List<Map> list = [
    {
      "nama": "RT 01",
      "rt": 50,
      "rw": 50,
      "warna1": Colors.indigo,
      "warna2": Colors.indigo,
    },
    {
      "nama": "RT 02",
      "rt": 40,
      "rw": 80,
      "warna1": Colors.indigo,
      "warna2": Colors.indigo,
    },
    {
      "nama": "RT 03",
      "rt": 80,
      "rw": 70,
      "warna1": Colors.indigo,
      "warna2": Colors.indigo,
    },
    {
      "nama": "RT 04",
      "rt": 50,
      "rw": 50,
      "warna1": Colors.indigo,
      "warna2": Colors.indigo,
    },
    {
      "nama": "RT 05",
      "rt": 40,
      "rw": 80,
      "warna1": Colors.indigo,
      "warna2": Colors.indigo,
    },
    {
      "nama": "RT 06",
      "rt": 80,
      "rw": 70,
      "warna1": Colors.indigo,
      "warna2": Colors.indigo,
    },
    {
      "nama": "RT 07",
      "rt": 40,
      "rw": 80,
      "warna1": Colors.indigo,
      "warna2": Colors.indigo,
    },
    {
      "nama": "RT 08",
      "rt": 80,
      "rw": 70,
      "warna1": Colors.indigo,
      "warna2": Colors.indigo,
    },
    {
      "nama": "RT 09",
      "rt": 80,
      "rw": 70,
      "warna1": Colors.indigo,
      "warna2": Colors.indigo,
    },
    {
      "nama": "RT 10",
      "rt": 80,
      "rw": 70,
      "warna1": Colors.indigo,
      "warna2": Colors.indigo,
    },
  ];

  var bulan = ['jun', 'jul', 'ags'];
  String dropValue = '';

  List<DropdownMenuItem<String>> listDrop = [];
  void loadData() {
    listDrop.add(DropdownMenuItem(
      child: Text("jan"),
      value: 'jan',
    ));
    listDrop.add(DropdownMenuItem(
      child: Text("feb"),
      value: 'feb',
    ));
    listDrop.add(DropdownMenuItem(
      child: Text("mar"),
      value: 'mar',
    ));
  }

  @override
  Widget build(BuildContext context) {
    loadData();
    return Container(
        // height: 370,
        // width: 400,
        padding: EdgeInsets.only(top: 10),
        decoration: BoxDecoration(color: Color(0xffF54748)
            // borderRadius: BorderRadius.circular(16),
            ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(left: 25, right: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {},
                    child: Container(
                      padding: EdgeInsets.only(right: 10),
                      child: Text(
                        "Bulan :",
                        style: TextStyle(
                            fontSize: 13,
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontFamily: "Nunito"),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    child: Container(
                      height: 27,
                      width: 106,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(21),
                          color: Colors.black.withOpacity(0.1)),
                      child: Container(
                        padding: EdgeInsets.only(left: 10),
                        child: Row(
                          children: [
                            // InkWell(
                            //   onTap: () {
                            //     print("test");
                            //   },
                            //   child: Container(
                            //       child: SvgPicture.asset(
                            //     "assets/icon/arrow-down.svg",
                            //     color: Colors.white,
                            //   )),
                            // ),
                            // DropdownButton(
                            //   items: listDrop,
                            //   value: dropValue,
                            //   hint: Text(
                            //     'September',
                            //     style: TextStyle(
                            //         fontSize: 13,
                            //         color: Colors.white,
                            //         fontWeight: FontWeight.w800,
                            //         fontFamily: "Nunito"),
                            //   ),
                            //   onChanged: (value) {
                            //     dropValue = value.toString();
                            //     setState(() {});
                            //     print(value);
                            //   },
                            // )
                            // DropdownButton(
                            //   items: bulan.map((itemname) {
                            //     return DropdownMenuItem(
                            //         value: itemname, child: Text(itemname));
                            //   }).toList(),
                            //   onChanged: (newValue) {
                            //     print(newValue);
                            //   },
                            //   value: dropValue,
                            // )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
                height: 200,
                padding: EdgeInsets.only(top: 40, left: 26),
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: list.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      list[index]['rw'].toString(),
                                      style: TextStyle(
                                          fontSize: 7,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: "Nunito"),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Container(
                                      // margin:
                                      //     EdgeInsets.only(left: 5, right: 2),
                                      // padding: EdgeInsets.only(left: 15),
                                      alignment: Alignment.center,
                                      width: 15,
                                      height: list[index]['rw'].toDouble(),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          color: Color(0xff2FA9ED)),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text(
                                      list[index]['rt'].toString(),
                                      style: TextStyle(
                                          fontSize: 7,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: "Nunito"),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Container(
                                      // padding: EdgeInsets.only(left: 15),
                                      alignment: Alignment.center,
                                      width: 15,
                                      height: list[index]['rt'].toDouble(),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          color: Color(0xffFFB61D)),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              // padding: EdgeInsets.only(left: 7),
                              // color: Colors.blueAccent,
                              child: Text(
                                list[index]['nama'],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 9,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                    fontFamily: "Nunito"),
                              ),
                            ),
                            SizedBox(
                              height: 23,
                            ),
                          ],
                        ),
                      );
                    })),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    child: Container(
                        height: 71,
                        width: 157,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Color(0xffFFFFFF).withOpacity(0.2),
                            width: 3,
                          ),
                          // color: Colors.amberAccent,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Row(
                            children: [
                              Container(
                                child: CircularPercentIndicator(
                                  radius: 50,
                                  lineWidth: 7.0,
                                  progressColor: Color(0xff2FA9ED),
                                  percent: .7,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(
                                    left: 10, bottom: 12, top: 11),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          "315",
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w800,
                                              fontFamily: "Nunito"),
                                        ),
                                        Text(
                                          "Rumah",
                                          style: TextStyle(
                                              fontSize: 9,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                              fontFamily: "Nunito"),
                                        )
                                      ],
                                    ),
                                    Text(
                                      "Sudah Bayar",
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w800,
                                          fontFamily: "Nunito"),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        )),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  ClipRRect(
                    child: Container(
                        height: 71,
                        width: 157,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Color(0xffFFFFFF).withOpacity(0.2),
                            width: 3,
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Row(
                            children: [
                              Container(
                                child: CircularPercentIndicator(
                                  radius: 50,
                                  lineWidth: 7.0,
                                  progressColor: Color(0xffFFB61D),
                                  percent: .4,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(
                                    left: 10, bottom: 12, top: 11),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          "185",
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w800,
                                              fontFamily: "Nunito"),
                                        ),
                                        Text(
                                          "Rumah",
                                          style: TextStyle(
                                              fontSize: 9,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                              fontFamily: "Nunito"),
                                        )
                                      ],
                                    ),
                                    Text(
                                      "Sudah Bayar",
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w800,
                                          fontFamily: "Nunito"),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        )),
                  ),
                ],
              ),
            )
          ],
        ));
  }
}
