// To parse this JSON data, do
//
//     final guestBookModel = guestBookModelFromJson(jsonString);

import 'dart:convert';

GuestBookTodayModel guestBookTodayModelFromJson(String str) =>
    GuestBookTodayModel.fromJson(json.decode(str));

String guestBookTodayModelToJson(GuestBookTodayModel data) => json.encode(data.toJson());

class GuestBookTodayModel {
  GuestBookTodayModel({
    this.result,
    this.timestamp,
    this.visitors,
  });

  bool? result;
  int? timestamp;
  List<Visitor>? visitors;

  factory GuestBookTodayModel.fromJson(Map<String, dynamic> json) => GuestBookTodayModel(
        result: json["result"] == null ? null : json["result"],
        timestamp: json["timestamp"] == null ? null : json["timestamp"],
        visitors: json["visitors"] == null
            ? null
            : List<Visitor>.from(
                json["visitors"].map((x) => Visitor.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "result": result == null ? null : result,
        "timestamp": timestamp == null ? null : timestamp,
        "visitors": visitors == null
            ? null
            : List<dynamic>.from(visitors!.map((x) => x.toJson())),
      };
}

class Visitor {
  Visitor({
    this.guestCount,
    this.id,
    this.name,
    this.phone,
    this.necessity,
    this.destinationPersonName,
    this.houseAddress,
    this.fullAddress,
    this.rw,
    this.rt,
    this.street,
    this.houseBlock,
    this.houseNumber,
    this.citizenName,
    this.citizenPhone,
    this.village,
    this.villageName,
    this.clientDisplayName,
    this.acceptedAt,
    this.acceptedByName,
    this.acceptedByPhone,
    this.idCardFile,
    this.selfieFile,
    this.open,
  });

  int? guestCount;
  String? id;
  String? name;
  String? phone;
  String? necessity;
  String? destinationPersonName;
  String? houseAddress;
  String? fullAddress;
  String? rw;
  String? rt;
  String? street;
  String? houseBlock;
  String? houseNumber;
  String? citizenName;
  String? citizenPhone;
  Village? village;
  String? villageName;
  String? clientDisplayName;
  DateTime? acceptedAt;
  String? acceptedByName;
  String? acceptedByPhone;
  IdCardFileClass? idCardFile;
  IdCardFileClass? selfieFile;
  bool? open;

  factory Visitor.fromJson(Map<String, dynamic> json) => Visitor(
        guestCount: json["guest_count"] == null ? null : json["guest_count"],
        id: json["_id"] == null ? null : json["_id"],
        name: json["name"] == null ? null : json["name"],
        phone: json["phone"] == null ? null : json["phone"],
        necessity: json["necessity"] == null ? null : json["necessity"],
        destinationPersonName: json["destination_person_name"] == null
            ? null
            : json["destination_person_name"],
        houseAddress:
            json["house_address"] == null ? null : json["house_address"],
        fullAddress: json["full_address"] == null ? null : json["full_address"],
        rw: json["rw"] == null ? null : json["rw"],
        rt: json["rt"] == null ? null : json["rt"],
        street: json["street"] == null ? null : json["street"],
        houseBlock: json["house_block"] == null ? null : json["house_block"],
        houseNumber: json["house_number"] == null ? null : json["house_number"],
        citizenName: json["citizen_name"] == null ? null : json["citizen_name"],
        citizenPhone:
            json["citizen_phone"] == null ? null : json["citizen_phone"],
        village:
            json["village"] == null ? null : Village.fromJson(json["village"]),
        villageName: json["village_name"] == null ? null : json["village_name"],
        clientDisplayName: json["client_display_name"] == null
            ? null
            : json["client_display_name"],
        acceptedAt: json["accepted_at"] == null
            ? null
            : DateTime.parse(json["accepted_at"]),
        acceptedByName:
            json["accepted_by_name"] == null ? null : json["accepted_by_name"],
        acceptedByPhone: json["accepted_by_phone"] == null
            ? null
            : json["accepted_by_phone"],
        idCardFile: json["id_card_file"] == null
            ? null
            : IdCardFileClass.fromJson(json["id_card_file"]),
        selfieFile: json["selfie_file"] == null
            ? null
            : IdCardFileClass.fromJson(json["selfie_file"]),
        open: json["open"] == null ? false : json["open"],
      );

  Map<String, dynamic> toJson() => {
        "guest_count": guestCount == null ? null : guestCount,
        "_id": id == null ? null : id,
        "name": name == null ? null : name,
        "phone": phone == null ? null : phone,
        "necessity": necessity == null ? null : necessity,
        "destination_person_name":
            destinationPersonName == null ? null : destinationPersonName,
        "house_address": houseAddress == null ? null : houseAddress,
        "full_address": fullAddress == null ? null : fullAddress,
        "rw": rw == null ? null : rw,
        "rt": rt == null ? null : rt,
        "street": street == null ? null : street,
        "house_block": houseBlock == null ? null : houseBlock,
        "house_number": houseNumber == null ? null : houseNumber,
        "citizen_name": citizenName == null ? null : citizenName,
        "citizen_phone": citizenPhone == null ? null : citizenPhone,
        "village": village == null ? null : village!.toJson(),
        "village_name": villageName == null ? null : villageName,
        "client_display_name":
            clientDisplayName == null ? null : clientDisplayName,
        "accepted_at": acceptedAt == null ? null : acceptedAt.toString(),
        "accepted_by_name": acceptedByName == null ? null : acceptedByName,
        "accepted_by_phone": acceptedByPhone == null ? null : acceptedByPhone,
        "id_card_file": idCardFile == null ? null : idCardFile!.toJson(),
        "selfie_file": selfieFile == null ? null : selfieFile!.toJson(),
        "open": open == null ? false : open,
      };
}

class IdCardFileClass {
  IdCardFileClass({
    this.size,
    this.id,
    this.type,
    this.mime,
    this.category,
    this.name,
    this.url,
  });

  int? size;
  String? id;
  String? type;
  String? mime;
  String? category;
  String? name;
  String? url;

  factory IdCardFileClass.fromJson(Map<String, dynamic> json) =>
      IdCardFileClass(
        size: json["size"] == null ? null : json["size"],
        id: json["_id"] == null ? null : json["_id"],
        type: json["type"] == null ? null : json["type"],
        mime: json["mime"] == null ? null : json["mime"],
        category: json["category"] == null ? null : json["category"],
        name: json["name"] == null ? null : json["name"],
        url: json["url"] == null ? null : json["url"],
      );

  Map<String, dynamic> toJson() => {
        "size": size == null ? null : size,
        "_id": id == null ? null : id,
        "type": type == null ? null : type,
        "mime": mime == null ? null : mime,
        "category": category == null ? null : category,
        "name": name == null ? null : name,
        "url": url == null ? null : url,
      };
}

class Village {
  Village({
    this.id,
    this.code,
    this.name,
    this.villageId,
  });

  String? id;
  String? code;
  String? name;
  String? villageId;

  factory Village.fromJson(Map<String, dynamic> json) => Village(
        id: json["_id"] == null ? null : json["_id"],
        code: json["code"] == null ? null : json["code"],
        name: json["name"] == null ? null : json["name"],
        villageId: json["id"] == null ? null : json["id"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id == null ? null : id,
        "code": code == null ? null : code,
        "name": name == null ? null : name,
        "id": villageId == null ? null : villageId,
      };
}
