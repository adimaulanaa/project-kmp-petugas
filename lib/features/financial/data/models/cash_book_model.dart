// To parse this JSON data, do
//
//     final cashBookModel = cashBookModelFromJson(jsonString);

import 'dart:convert';

CashBookModel cashBookModelFromJson(String str) =>
    CashBookModel.fromJson(json.decode(str));

String cashBookModelToJson(CashBookModel data) => json.encode(data.toJson());

class CashBookModel {
  CashBookModel({
    this.result,
    this.timestamp,
    this.reports,
    this.total,
  });

  bool? result;
  int? timestamp;
  List<Report>? reports;
  Total? total;

  factory CashBookModel.fromJson(Map<String, dynamic> json) => CashBookModel(
        result: json["result"] == null ? null : json["result"],
        timestamp: json["timestamp"] == null ? null : json["timestamp"],
        reports: json["reports"] == null
            ? null
            : List<Report>.from(json["reports"].map((x) => Report.fromJson(x))),
        total: json["total"] == null ? null : Total.fromJson(json["total"]),
      );

  Map<String, dynamic> toJson() => {
        "result": result == null ? null : result,
        "timestamp": timestamp == null ? null : timestamp,
        "reports": reports == null
            ? null
            : List<dynamic>.from(reports!.map((x) => x.toJson())),
        "total": total == null ? null : total!.toJson(),
      };
}

class Report {
  Report({
    this.periodNumber,
    this.periodName,
    this.citizenName,
    this.rw,
    this.rwNumber,
    this.rt,
    this.rtNumber,
    this.houseBlock,
    this.houseNumber,
    this.houseAddress,
    this.paidName,
    this.paidTotal,
    this.unpaidName,
    this.unpaidTotal,
    this.houseIsFree,
  });

  int? periodNumber;
  String? periodName;
  String? citizenName;
  String? rw;
  int? rwNumber;
  String? rt;
  int? rtNumber;
  String? houseBlock;
  String? houseNumber;
  String? houseAddress;
  String? paidName;
  int? paidTotal;
  String? unpaidName;
  int? unpaidTotal;
  bool? houseIsFree;

  factory Report.fromJson(Map<String, dynamic> json) => Report(
        periodNumber:
            json["period_number"] == null ? null : json["period_number"],
        periodName: json["period_name"] == null ? null : json["period_name"],
        citizenName: json["citizen_name"] == null ? null : json["citizen_name"],
        rw: json["rw"] == null ? null : json["rw"],
        rwNumber: json["rw_number"] == null ? null : json["rw_number"],
        rt: json["rt"] == null ? null : json["rt"],
        rtNumber: json["rt_number"] == null ? null : json["rt_number"],
        houseBlock: json["house_block"] == null ? null : json["house_block"],
        houseNumber: json["house_number"] == null ? null : json["house_number"],
        houseAddress:
            json["house_address"] == null ? null : json["house_address"],
        paidName: json["paid_name"] == null ? null : json["paid_name"],
        paidTotal: json["paid_total"] == null ? null : json["paid_total"],
        unpaidName: json["unpaid_name"] == null ? null : json["unpaid_name"],
        unpaidTotal: json["unpaid_total"] == null ? null : json["unpaid_total"],
        houseIsFree:
            json["house_is_free"] == null ? null : json["house_is_free"],
      );

  Map<String, dynamic> toJson() => {
        "period_number": periodNumber == null ? null : periodNumber,
        "period_name": periodName == null ? null : periodName,
        "citizen_name": citizenName == null ? null : citizenName,
        "rw": rw == null ? null : rw,
        "rw_number": rwNumber == null ? null : rwNumber,
        "rt": rt == null ? null : rt,
        "rt_number": rtNumber == null ? null : rtNumber,
        "house_block": houseBlock == null ? null : houseBlock,
        "house_number": houseNumber == null ? null : houseNumber,
        "house_address": houseAddress == null ? null : houseAddress,
        "paid_name": paidName == null ? null : paidName,
        "paid_total": paidTotal == null ? null : paidTotal,
        "unpaid_name": unpaidName == null ? null : unpaidName,
        "unpaid_total": unpaidTotal == null ? null : unpaidTotal,
        "house_is_free": houseIsFree == null ? null : houseIsFree,
      };
}

class Total {
  Total({
    this.paid,
    this.unpaid,
  });

  int? paid;
  int? unpaid;

  factory Total.fromJson(Map<String, dynamic> json) => Total(
        paid: json["paid"] == null ? null : json["paid"],
        unpaid: json["unpaid"] == null ? null : json["unpaid"],
      );

  Map<String, dynamic> toJson() => {
        "paid": paid == null ? null : paid,
        "unpaid": unpaid == null ? null : unpaid,
      };
}
