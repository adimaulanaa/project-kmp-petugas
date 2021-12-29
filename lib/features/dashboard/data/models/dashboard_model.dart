// To parse this JSON data, do
//
//     final dashboardModel = dashboardModelFromJson(jsonString? );

import 'dart:convert';

import 'package:kmp_petugas_app/features/dashboard/data/models/region_model.dart';

DashboardModel dashboardModelFromJson(String str) =>
    DashboardModel.fromJson(json.decode(str));

String dashboardModelToJson(DashboardModel data) => json.encode(data.toJson());

class DashboardModel {
  DashboardModel({
    this.result,
    this.timestamp,
    this.regions,
    this.positions,
    this.subscriptionCategories,
    this.subscriptions,
    this.client,
    this.villageRwRts,
    this.dashboard,
  });

  bool? result;
  num? timestamp;
  List<RegionModel>? regions;
  List<Position>? positions;
  List<Base>? subscriptionCategories;
  List<Base>? subscriptions;
  Client? client;
  List<VillageRwRt>? villageRwRts;
  Dashboard? dashboard;

  factory DashboardModel.fromJson(Map<String?, dynamic> json) => DashboardModel(
        result: json["result"] == null ? null : json["result"],
        timestamp: json["timestamp"] == null ? null : json["timestamp"],
        regions: json["regions"] == null
            ? null
            : List<RegionModel>.from(
                json["regions"].map((x) => RegionModel.fromJson(x))),
        positions: json["positions"] == null
            ? null
            : List<Position>.from(
                json["positions"].map((x) => Position.fromJson(x))),
        subscriptionCategories: json["subscription_categories"] == null
            ? null
            : List<Base>.from(
                json["subscription_categories"].map((x) => Base.fromJson(x))),
        subscriptions: json["subscriptions"] == null
            ? null
            : List<Base>.from(
                json["subscriptions"].map((x) => Base.fromJson(x))),
        client: json["client"] == null ? null : Client.fromJson(json["client"]),
        villageRwRts: json["village_rw_rts"] == null
            ? null
            : List<VillageRwRt>.from(
                json["village_rw_rts"].map((x) => VillageRwRt.fromJson(x))),
        dashboard: json["dashboard"] == null
            ? null
            : Dashboard.fromJson(json["dashboard"]),
      );

  Map<String?, dynamic> toJson() => {
        "result": result == null ? null : result,
        "timestamp": timestamp == null ? null : timestamp,
        "regions":
            regions == null ? null : List<dynamic>.from(regions!.map((x) => x)),
        "positions": positions == null
            ? null
            : List<dynamic>.from(positions!.map((x) => x.toJson())),
        "subscription_categories": subscriptionCategories == null
            ? null
            : List<dynamic>.from(
                subscriptionCategories!.map((x) => x.toJson())),
        "subscriptions": subscriptions == null
            ? null
            : List<dynamic>.from(subscriptions!.map((x) => x.toJson())),
        "client": client == null ? null : client!.toJson(),
        "village_rw_rts": villageRwRts == null
            ? null
            : List<dynamic>.from(villageRwRts!.map((x) => x.toJson())),
        "dashboard": dashboard == null ? null : dashboard!.toJson(),
      };
}

class Client {
  Client({
    this.id,
    this.name,
    this.description,
    this.code,
    this.displayName,
    this.villages,
    this.clientId,
  });

  String? id;
  String? name;
  String? description;
  String? code;
  String? displayName;
  List<Village>? villages;
  String? clientId;

  factory Client.fromJson(Map<String?, dynamic> json) => Client(
        id: json["_id"] == null ? null : json["_id"],
        name: json["name"] == null ? null : json["name"],
        description: json["description"] == null ? null : json["description"],
        code: json["code"] == null ? null : json["code"],
        displayName: json["display_name"] == null ? null : json["display_name"],
        villages: json["villages"] == null
            ? null
            : List<Village>.from(
                json["villages"].map((x) => Village.fromJson(x))),
        clientId: json["id"] == null ? null : json["id"],
      );

  Map<String?, dynamic> toJson() => {
        "_id": id == null ? null : id,
        "name": name == null ? null : name,
        "description": description == null ? null : description,
        "code": code == null ? null : code,
        "display_name": displayName == null ? null : displayName,
        "villages": villages == null
            ? null
            : List<dynamic>.from(villages!.map((x) => x.toJson())),
        "id": clientId == null ? null : clientId,
      };
}

class Village {
  Village({
    this.id,
    this.subDistrict,
    this.province,
    this.provinceName,
    this.city,
    this.cityName,
    this.district,
    this.districtName,
    this.subDistrictName,
    this.region,
    this.regionName,
    this.address,
    this.code,
    this.name,
    this.client,
    this.clientDisplayName,
    this.rwPlaces,
    this.villageId,
  });

  String? id;
  String? subDistrict;
  String? province;
  String? provinceName;
  String? city;
  String? cityName;
  String? district;
  String? districtName;
  String? subDistrictName;
  String? region;
  String? regionName;
  String? address;
  String? code;
  String? name;
  String? client;
  String? clientDisplayName;
  List<Place>? rwPlaces;
  String? villageId;

  factory Village.fromJson(Map<String?, dynamic> json) => Village(
        id: json["_id"] == null ? null : json["_id"],
        subDistrict: json["sub_district"] == null ? null : json["sub_district"],
        province: json["province"] == null ? null : json["province"],
        provinceName:
            json["province_name"] == null ? null : json["province_name"],
        city: json["city"] == null ? null : json["city"],
        cityName: json["city_name"] == null ? null : json["city_name"],
        district: json["district"] == null ? null : json["district"],
        districtName:
            json["district_name"] == null ? null : json["district_name"],
        subDistrictName: json["sub_district_name"] == null
            ? null
            : json["sub_district_name"],
        region: json["region"] == null ? null : json["region"],
        regionName: json["region_name"] == null ? null : json["region_name"],
        address: json["address"] == null ? null : json["address"],
        code: json["code"] == null ? null : json["code"],
        name: json["name"] == null ? null : json["name"],
        client: json["client"] == null ? null : json["client"],
        clientDisplayName: json["client_display_name"] == null
            ? null
            : json["client_display_name"],
        rwPlaces: json["rw_places"] == null
            ? null
            : List<Place>.from(json["rw_places"].map((x) => Place.fromJson(x))),
        villageId: json["id"] == null ? null : json["id"],
      );

  Map<String?, dynamic> toJson() => {
        "_id": id == null ? null : id,
        "sub_district": subDistrict == null ? null : subDistrict,
        "province": province == null ? null : province,
        "province_name": provinceName == null ? null : provinceName,
        "city": city == null ? null : city,
        "city_name": cityName == null ? null : cityName,
        "district": district == null ? null : district,
        "district_name": districtName == null ? null : districtName,
        "sub_district_name": subDistrictName == null ? null : subDistrictName,
        "region": region == null ? null : region,
        "region_name": regionName == null ? null : regionName,
        "address": address == null ? null : address,
        "code": code == null ? null : code,
        "name": name == null ? null : name,
        "client": client == null ? null : client,
        "client_display_name":
            clientDisplayName == null ? null : clientDisplayName,
        "rw_places": rwPlaces == null
            ? null
            : List<dynamic>.from(rwPlaces!.map((x) => x.toJson())),
        "id": villageId == null ? null : villageId,
      };
}

class Place {
  Place({
    this.rwNumber,
    this.id,
    this.rw,
    this.village,
    this.villageCode,
    this.client,
    this.clientDisplayName,
    this.villageName,
    this.rtPlaces,
    this.placeId,
    this.rtNumber,
    this.rwPlace,
    this.rt,
  });

  num? rwNumber;
  String? id;
  String? rw;
  String? village;
  String? villageCode;
  String? client;
  String? clientDisplayName;
  String? villageName;
  List<Place>? rtPlaces;
  String? placeId;
  num? rtNumber;
  String? rwPlace;
  String? rt;

  factory Place.fromJson(Map<String?, dynamic> json) => Place(
        rwNumber: json["rw_number"] == null ? null : json["rw_number"],
        id: json["_id"] == null ? null : json["_id"],
        rw: json["rw"] == null ? null : json["rw"],
        village: json["village"] == null ? null : json["village"],
        villageCode: json["village_code"] == null ? null : json["village_code"],
        client: json["client"] == null ? null : json["client"],
        clientDisplayName: json["client_display_name"] == null
            ? null
            : json["client_display_name"],
        villageName: json["village_name"] == null ? null : json["village_name"],
        rtPlaces: json["rt_places"] == null
            ? null
            : List<Place>.from(json["rt_places"].map((x) => Place.fromJson(x))),
        placeId: json["id"] == null ? null : json["id"],
        rtNumber: json["rt_number"] == null ? null : json["rt_number"],
        rwPlace: json["rw_place"] == null ? null : json["rw_place"],
        rt: json["rt"] == null ? null : json["rt"],
      );

  Map<String?, dynamic> toJson() => {
        "rw_number": rwNumber == null ? null : rwNumber,
        "_id": id == null ? null : id,
        "rw": rw == null ? null : rw,
        "village": village == null ? null : village,
        "village_code": villageCode == null ? null : villageCode,
        "client": client == null ? null : client,
        "client_display_name":
            clientDisplayName == null ? null : clientDisplayName,
        "village_name": villageName == null ? null : villageName,
        "rt_places": rtPlaces == null
            ? null
            : List<dynamic>.from(rtPlaces!.map((x) => x.toJson())),
        "id": placeId == null ? null : placeId,
        "rt_number": rtNumber == null ? null : rtNumber,
        "rw_place": rwPlace == null ? null : rwPlace,
        "rt": rt == null ? null : rt,
      };
}

class Dashboard {
  Dashboard({
    this.period,
    this.paid,
    this.unpaid,
  });

  Period? period;
  Paid? paid;
  Paid? unpaid;

  factory Dashboard.fromJson(Map<String?, dynamic> json) => Dashboard(
        period: json["period"] == null ? null : Period.fromJson(json["period"]),
        paid: json["paid"] == null ? null : Paid.fromJson(json["paid"]),
        unpaid: json["unpaid"] == null ? null : Paid.fromJson(json["unpaid"]),
      );

  Map<String?, dynamic> toJson() => {
        "period": period == null ? null : period!.toJson(),
        "paid": paid == null ? null : paid!.toJson(),
        "unpaid": unpaid == null ? null : unpaid!.toJson(),
      };
}

class Paid {
  Paid({
    this.housePercentage,
    this.houseCount,
  });

  num? housePercentage;
  num? houseCount;

  factory Paid.fromJson(Map<String?, dynamic> json) => Paid(
        housePercentage:
            json["house_percentage"] == null ? null : json["house_percentage"],
        houseCount: json["house_count"] == null ? null : json["house_count"],
      );

  Map<String?, dynamic> toJson() => {
        "house_percentage": housePercentage == null ? null : housePercentage,
        "house_count": houseCount == null ? null : houseCount,
      };
}

class Period {
  Period({
    this.yearMount,
    this.mountName,
    this.mountNumber,
    this.yearNumber,
  });

  String? yearMount;
  String? mountName;
  num? mountNumber;
  num? yearNumber;

  factory Period.fromJson(Map<String?, dynamic> json) => Period(
        yearMount: json["year_mount"] == null ? null : json["year_mount"],
        mountName: json["mount_name"] == null ? null : json["mount_name"],
        mountNumber: json["mount_number"] == null ? null : json["mount_number"],
        yearNumber: json["year_number"] == null ? null : json["year_number"],
      );

  Map<String?, dynamic> toJson() => {
        "year_mount": yearMount == null ? null : yearMount,
        "mount_name": mountName == null ? null : mountName,
        "mount_number": mountNumber == null ? null : mountNumber,
        "year_number": yearNumber == null ? null : yearNumber,
      };
}

class Position {
  Position({
    this.id,
    this.name,
  });

  String? id;
  String? name;

  factory Position.fromJson(Map<String?, dynamic> json) => Position(
        id: json["_id"] == null ? null : json["_id"],
        name: json["name"] == null ? null : json["name"],
      );

  Map<String?, dynamic> toJson() => {
        "_id": id == null ? null : id,
        "name": name == null ? null : name,
      };
}

class Base {
  Base({this.id, this.name, this.description, this.amount, this.check});

  String? id;
  String? name;
  String? description;
  num? amount;
  bool? check;

  factory Base.fromJson(Map<String?, dynamic> json) => Base(
        id: json["_id"] == null ? null : json["_id"],
        name: json["name"] == null ? null : json["name"],
        description: json["description"] == null ? null : json["description"],
        amount: json["amount"] == null ? null : json["amount"],
      );

  Map<String?, dynamic> toJson() => {
        "_id": id == null ? null : id,
        "name": name == null ? null : name,
        "description": description == null ? null : description,
        "amount": amount == null ? null : amount,
      };
}

class VillageRwRt {
  VillageRwRt({
    this.id,
    this.villageCode,
    this.villageName,
    this.villageAddress,
    this.villageRegion,
    this.villageRegionName,
    this.villageProvince,
    this.villageProvinceName,
    this.villageCity,
    this.villageCityName,
    this.villageDistrict,
    this.villageDistrictName,
    this.villageSubDistrict,
    this.villageSubDistrictName,
    this.rw,
    this.rwNumber,
    this.rt,
    this.rtNumber,
    this.displayText,
    this.villageId,
    this.rwPlaceId,
    this.rtPlaceId,
  });

  String? id;
  String? villageCode;
  String? villageName;
  String? villageAddress;
  String? villageRegion;
  String? villageRegionName;
  String? villageProvince;
  String? villageProvinceName;
  String? villageCity;
  String? villageCityName;
  String? villageDistrict;
  String? villageDistrictName;
  String? villageSubDistrict;
  String? villageSubDistrictName;
  String? rw;
  num? rwNumber;
  String? rt;
  num? rtNumber;
  String? displayText;
  String? villageId;
  String? rwPlaceId;
  String? rtPlaceId;

  factory VillageRwRt.fromJson(Map<String?, dynamic> json) => VillageRwRt(
        id: json["_id"] == null ? null : json["_id"],
        villageCode: json["village_code"] == null ? null : json["village_code"],
        villageName: json["village_name"] == null ? null : json["village_name"],
        villageAddress:
            json["village_address"] == null ? null : json["village_address"],
        villageRegion:
            json["village_region"] == null ? null : json["village_region"],
        villageRegionName: json["village_region_name"] == null
            ? null
            : json["village_region_name"],
        villageProvince:
            json["village_province"] == null ? null : json["village_province"],
        villageProvinceName: json["village_province_name"] == null
            ? null
            : json["village_province_name"],
        villageCity: json["village_city"] == null ? null : json["village_city"],
        villageCityName: json["village_city_name"] == null
            ? null
            : json["village_city_name"],
        villageDistrict:
            json["village_district"] == null ? null : json["village_district"],
        villageDistrictName: json["village_district_name"] == null
            ? null
            : json["village_district_name"],
        villageSubDistrict: json["village_sub_district"] == null
            ? null
            : json["village_sub_district"],
        villageSubDistrictName: json["village_sub_district_name"] == null
            ? null
            : json["village_sub_district_name"],
        rw: json["rw"] == null ? null : json["rw"],
        rwNumber: json["rw_number"] == null ? null : json["rw_number"],
        rt: json["rt"] == null ? null : json["rt"],
        rtNumber: json["rt_number"] == null ? null : json["rt_number"],
        displayText: json["display_text"] == null ? null : json["display_text"],
        villageId: json["village_id"] == null ? null : json["village_id"],
        rwPlaceId: json["rw_place_id"] == null ? null : json["rw_place_id"],
        rtPlaceId: json["rt_place_id"] == null ? null : json["rt_place_id"],
      );

  Map<String?, dynamic> toJson() => {
        "_id": id == null ? null : id,
        "village_code": villageCode == null ? null : villageCode,
        "village_name": villageName == null ? null : villageName,
        "village_address": villageAddress == null ? null : villageAddress,
        "village_region": villageRegion == null ? null : villageRegion,
        "village_region_name":
            villageRegionName == null ? null : villageRegionName,
        "village_province": villageProvince == null ? null : villageProvince,
        "village_province_name":
            villageProvinceName == null ? null : villageProvinceName,
        "village_city": villageCity == null ? null : villageCity,
        "village_city_name": villageCityName == null ? null : villageCityName,
        "village_district": villageDistrict == null ? null : villageDistrict,
        "village_district_name":
            villageDistrictName == null ? null : villageDistrictName,
        "village_sub_district":
            villageSubDistrict == null ? null : villageSubDistrict,
        "village_sub_district_name":
            villageSubDistrictName == null ? null : villageSubDistrictName,
        "rw": rw == null ? null : rw,
        "rw_number": rwNumber == null ? null : rwNumber,
        "rt": rt == null ? null : rt,
        "rt_number": rtNumber == null ? null : rtNumber,
        "display_text": displayText == null ? null : displayText,
        "village_id": villageId == null ? null : villageId,
        "rw_place_id": rwPlaceId == null ? null : rwPlaceId,
        "rt_place_id": rtPlaceId == null ? null : rtPlaceId,
      };
}
