// To parse this JSON data, do
//
//     final housesModel = housesModelFromJson(jsonString);

import 'dart:convert';

HousesModel housesModelFromJson(String str) =>
    HousesModel.fromJson(json.decode(str));

String housesModelToJson(HousesModel data) => json.encode(data.toJson());

class HousesModel {
  HousesModel({
    this.result,
    this.timestamp,
    this.paginate,
  });

  bool? result;
  int? timestamp;
  Paginate? paginate;

  factory HousesModel.fromJson(Map<String, dynamic> json) => HousesModel(
        result: json["result"] == null ? null : json["result"],
        timestamp: json["timestamp"] == null ? null : json["timestamp"],
        paginate: json["paginate"] == null
            ? null
            : Paginate.fromJson(json["paginate"]),
      );

  Map<String, dynamic> toJson() => {
        "result": result == null ? null : result,
        "timestamp": timestamp == null ? null : timestamp,
        "paginate": paginate == null ? null : paginate!.toJson(),
      };
}

class Paginate {
  Paginate({
    this.docs,
    this.totalDocs,
    this.offset,
    this.limit,
    this.totalPages,
    this.page,
    this.pagingCounter,
    this.hasPrevPage,
    this.hasNextPage,
    this.prevPage,
    this.nextPage,
  });

  List<Houses>? docs;
  int? totalDocs;
  int? offset;
  int? limit;
  int? totalPages;
  int? page;
  int? pagingCounter;
  bool? hasPrevPage;
  bool? hasNextPage;
  dynamic prevPage;
  dynamic nextPage;

  factory Paginate.fromJson(Map<String, dynamic> json) => Paginate(
        docs: json["docs"] == null
            ? null
            : List<Houses>.from(json["docs"].map((x) => Houses.fromJson(x))),
        totalDocs: json["totalDocs"] == null ? null : json["totalDocs"],
        offset: json["offset"] == null ? null : json["offset"],
        limit: json["limit"] == null ? null : json["limit"],
        totalPages: json["totalPages"] == null ? null : json["totalPages"],
        page: json["page"] == null ? null : json["page"],
        pagingCounter:
            json["pagingCounter"] == null ? null : json["pagingCounter"],
        hasPrevPage: json["hasPrevPage"] == null ? null : json["hasPrevPage"],
        hasNextPage: json["hasNextPage"] == null ? null : json["hasNextPage"],
        prevPage: json["prevPage"],
        nextPage: json["nextPage"],
      );

  Map<String, dynamic> toJson() => {
        "docs": docs == null
            ? null
            : List<dynamic>.from(docs!.map((x) => x.toJson())),
        "totalDocs": totalDocs == null ? null : totalDocs,
        "offset": offset == null ? null : offset,
        "limit": limit == null ? null : limit,
        "totalPages": totalPages == null ? null : totalPages,
        "page": page == null ? null : page,
        "pagingCounter": pagingCounter == null ? null : pagingCounter,
        "hasPrevPage": hasPrevPage == null ? null : hasPrevPage,
        "hasNextPage": hasNextPage == null ? null : hasNextPage,
        "prevPage": prevPage,
        "nextPage": nextPage,
      };
}

class Houses {
  Houses({
    this.id,
    this.isVacant,
    this.isActive,
    this.rtPlace,
    this.street,
    this.houseBlock,
    this.houseNumber,
    this.citizenIdCard,
    this.citizenName,
    this.citizenGender,
    this.citizenPhone,
    this.rwPlace,
    this.address,
    this.rw,
    this.rt,
    this.village,
    this.villageName,
    this.clientDisplayName,
    this.houseAddress,
    this.fullAddress,
    this.subscriptionNames,
    this.subscriptions,
    this.docId,
    this.isChecked = false,
  });

  String? id;
  bool? isVacant;
  bool? isActive;
  RtPlace? rtPlace;
  String? street;
  String? houseBlock;
  String? houseNumber;
  String? citizenIdCard;
  String? citizenName;
  String? citizenGender;
  String? citizenPhone;
  RwPlace? rwPlace;
  String? address;
  String? rw;
  String? rt;
  Villages? village;
  String? villageName;
  String? clientDisplayName;
  String? houseAddress;
  String? fullAddress;
  String? subscriptionNames;
  List<SubscriptionElement>? subscriptions;
  String? docId;
  bool? isChecked;

  factory Houses.fromJson(Map<String, dynamic> json) => Houses(
        id: json["_id"] == null ? null : json["_id"],
        isVacant: json["is_vacant"] == null ? null : json["is_vacant"],
        isActive: json["is_active"] == null ? null : json["is_active"],
        rtPlace: json["rt_place"] == null
            ? null
            : RtPlace.fromJson(json["rt_place"]),
        street: json["street"] == null ? null : json["street"],
        houseBlock: json["house_block"] == null ? null : json["house_block"],
        houseNumber: json["house_number"] == null ? null : json["house_number"],
        citizenIdCard:
            json["citizen_id_card"] == null ? null : json["citizen_id_card"],
        citizenName: json["citizen_name"] == null ? null : json["citizen_name"],
        citizenGender:
            json["citizen_gender"] == null ? null : json["citizen_gender"],
        citizenPhone:
            json["citizen_phone"] == null ? null : json["citizen_phone"],
        rwPlace: json["rw_place"] == null
            ? null
            : RwPlace.fromJson(json["rw_place"]),
        address: json["address"] == null ? null : json["address"],
        rw: json["rw"] == null ? null : json["rw"],
        rt: json["rt"] == null ? null : json["rt"],
        village:
            json["village"] == null ? null : Villages.fromJson(json["village"]),
        villageName: json["village_name"] == null ? null : json["village_name"],
        clientDisplayName: json["client_display_name"] == null
            ? null
            : json["client_display_name"],
        houseAddress:
            json["house_address"] == null ? null : json["house_address"],
        fullAddress: json["full_address"] == null ? null : json["full_address"],
        subscriptionNames: json["subscription_names"] == null
            ? null
            : json["subscription_names"],
        subscriptions: json["subscriptions"] == null
            ? null
            : List<SubscriptionElement>.from(json["subscriptions"]
                .map((x) => SubscriptionElement.fromJson(x))),
        docId: json["id"] == null ? null : json["id"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id == null ? null : id,
        "is_vacant": isVacant == null ? null : isVacant,
        "is_active": isActive == null ? null : isActive,
        "rt_place": rtPlace == null ? null : rtPlace!.toJson(),
        "street": street == null ? null : street,
        "house_block": houseBlock == null ? null : houseBlock,
        "house_number": houseNumber == null ? null : houseNumber,
        "citizen_id_card": citizenIdCard == null ? null : citizenIdCard,
        "citizen_name": citizenName == null ? null : citizenName,
        "citizen_gender": citizenGender == null ? null : citizenGender,
        "citizen_phone": citizenPhone == null ? null : citizenPhone,
        "rw_place": rwPlace == null ? null : rwPlace!.toJson(),
        "address": address == null ? null : address,
        "rw": rw == null ? null : rw,
        "rt": rt == null ? null : rt,
        "village": village == null ? null : village!.toJson(),
        "village_name": villageName == null ? null : villageName,
        "client_display_name":
            clientDisplayName == null ? null : clientDisplayName,
        "house_address": houseAddress == null ? null : houseAddress,
        "full_address": fullAddress == null ? null : fullAddress,
        "subscription_names":
            subscriptionNames == null ? null : subscriptionNames,
        "subscriptions": subscriptions == null
            ? null
            : List<dynamic>.from(subscriptions!.map((x) => x.toJson())),
        "id": docId == null ? null : docId,
      };
  bool isEqual(Houses? model) {
    return this.id == model?.id;
  }
}

class RtPlace {
  RtPlace({
    this.id,
    this.rwNumber,
    this.rtNumber,
    this.rw,
    this.rt,
  });

  String? id;
  int? rwNumber;
  int? rtNumber;
  String? rw;
  String? rt;

  factory RtPlace.fromJson(Map<String, dynamic> json) => RtPlace(
        id: json["_id"] == null ? null : json["_id"],
        rwNumber: json["rw_number"] == null ? null : json["rw_number"],
        rtNumber: json["rt_number"] == null ? null : json["rt_number"],
        rw: json["rw"] == null ? null : json["rw"],
        rt: json["rt"] == null ? null : json["rt"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id == null ? null : id,
        "rw_number": rwNumber == null ? null : rwNumber,
        "rt_number": rtNumber == null ? null : rtNumber,
        "rw": rw == null ? null : rw,
        "rt": rt == null ? null : rt,
      };
}

class RwPlace {
  RwPlace({
    this.id,
    this.rwNumber,
    this.rw,
  });

  String? id;
  int? rwNumber;
  String? rw;

  factory RwPlace.fromJson(Map<String, dynamic> json) => RwPlace(
        id: json["_id"] == null ? null : json["_id"],
        rwNumber: json["rw_number"] == null ? null : json["rw_number"],
        rw: json["rw"] == null ? null : json["rw"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id == null ? null : id,
        "rw_number": rwNumber == null ? null : rwNumber,
        "rw": rw == null ? null : rw,
      };
}

class SubscriptionElement {
  SubscriptionElement({
    this.id,
    this.isHouseActive,
    this.isSubscriptionActive,
    this.house,
    this.subscription,
    this.v,
  });

  String? id;
  bool? isHouseActive;
  bool? isSubscriptionActive;
  String? house;
  SubscriptionSubscription? subscription;
  int? v;

  factory SubscriptionElement.fromJson(Map<String, dynamic> json) =>
      SubscriptionElement(
        id: json["_id"] == null ? null : json["_id"],
        isHouseActive:
            json["is_house_active"] == null ? null : json["is_house_active"],
        isSubscriptionActive: json["is_subscription_active"] == null
            ? null
            : json["is_subscription_active"],
        house: json["house"] == null ? null : json["house"],
        subscription: json["subscription"] == null
            ? null
            : SubscriptionSubscription.fromJson(json["subscription"]),
        v: json["__v"] == null ? null : json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id == null ? null : id,
        "is_house_active": isHouseActive == null ? null : isHouseActive,
        "is_subscription_active":
            isSubscriptionActive == null ? null : isSubscriptionActive,
        "house": house == null ? null : house,
        "subscription": subscription == null ? null : subscription!.toJson(),
        "__v": v == null ? null : v,
      };
}

class SubscriptionSubscription {
  SubscriptionSubscription({
    this.id,
    this.amount,
    this.name,
  });

  String? id;
  int? amount;
  String? name;

  factory SubscriptionSubscription.fromJson(Map<String, dynamic> json) =>
      SubscriptionSubscription(
        id: json["_id"] == null ? null : json["_id"],
        amount: json["amount"] == null ? null : json["amount"],
        name: json["name"] == null ? null : json["name"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id == null ? null : id,
        "amount": amount == null ? null : amount,
        "name": name == null ? null : name,
      };
}

class Villages {
  Villages({
    this.id,
    this.code,
    this.name,
  });

  String? id;
  String? code;
  String? name;

  factory Villages.fromJson(Map<String, dynamic> json) => Villages(
        id: json["_id"] == null ? null : json["_id"],
        code: json["code"] == null ? null : json["code"],
        name: json["name"] == null ? null : json["name"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id == null ? null : id,
        "code": code == null ? null : code,
        "name": name == null ? null : name,
      };
}
