// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  UserModel({
    this.id,
    this.token,
    this.refreshToken,
    this.username,
    this.roleName,
    this.name,
    this.gender,
    this.email,
    this.phone,
    this.avatar,
    this.officer,
    this.timestamp,
  });

  String? id;
  String? token;
  String? refreshToken;
  String? username;
  String? roleName;
  String? name;
  String? gender;
  String? email;
  String? phone;
  String? avatar;
  Officer? officer;
  int? timestamp;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["_id"] == null ? null : json["_id"],
        token: json["token"] == null ? null : json["token"],
        refreshToken:
            json["refresh_token"] == null ? null : json["refresh_token"],
        username: json["username"] == null ? null : json["username"],
        roleName: json["role_name"] == null ? null : json["role_name"],
        name: json["name"] == null ? null : json["name"],
        gender: json["gender"] == null ? null : json["gender"],
        email: json["email"] == null ? null : json["email"],
        phone: json["phone"] == null ? null : json["phone"],
        avatar: json["avatar"] == null ? null : json["avatar"],
        officer:
            json["officer"] == null ? null : Officer.fromJson(json["officer"]),
        timestamp: json["timestamp"] == null ? null : json["timestamp"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id == null ? null : id,
        "token": token == null ? null : token,
        "refresh_token": refreshToken == null ? null : refreshToken,
        "username": username == null ? null : username,
        "role_name": roleName == null ? null : roleName,
        "name": name == null ? null : name,
        "gender": gender == null ? null : gender,
        "email": email == null ? null : email,
        "phone": phone == null ? null : phone,
        "avatar": avatar == null ? null : avatar,
        "officer": officer == null ? null : officer!.toJson(),
        "timestamp": timestamp == null ? null : timestamp,
      };
}

class Officer {
  Officer({
    this.rtNumber,
    this.rwNumber,
    this.id,
    this.idCard,
    this.name,
    this.gender,
    this.subDistrict,
    this.street,
    this.rt,
    this.rw,
    this.phone,
    this.phone2,
    this.email,
    this.position,
    this.createdBy,
    this.genderName,
    this.assignmentNames,
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
    this.positionName,
    this.user,
    this.userUsername,
    this.userName,
    this.createdAt,
    this.updatedAt,
    this.assignments,
    this.officerId,
  });

  int? rtNumber;
  int? rwNumber;
  String? id;
  String? idCard;
  String? name;
  String? gender;
  String? subDistrict;
  String? street;
  String? rt;
  String? rw;
  String? phone;
  String? phone2;
  String? email;
  Position? position;
  String? createdBy;
  String? genderName;
  String? assignmentNames;
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
  String? positionName;
  String? user;
  String? userUsername;
  String? userName;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<Assignment>? assignments;
  String? officerId;

  factory Officer.fromJson(Map<String, dynamic> json) => Officer(
        rtNumber: json["rt_number"] == null ? null : json["rt_number"],
        rwNumber: json["rw_number"] == null ? null : json["rw_number"],
        id: json["_id"] == null ? null : json["_id"],
        idCard: json["id_card"] == null ? null : json["id_card"],
        name: json["name"] == null ? null : json["name"],
        gender: json["gender"] == null ? null : json["gender"],
        subDistrict: json["sub_district"] == null ? null : json["sub_district"],
        street: json["street"] == null ? null : json["street"],
        rt: json["rt"] == null ? null : json["rt"],
        rw: json["rw"] == null ? null : json["rw"],
        phone: json["phone"] == null ? null : json["phone"],
        phone2: json["phone_2"] == null ? null : json["phone_2"],
        email: json["email"] == null ? null : json["email"],
        position: json["position"] == null
            ? null
            : Position.fromJson(json["position"]),
        createdBy: json["created_by"] == null ? null : json["created_by"],
        genderName: json["gender_name"] == null ? null : json["gender_name"],
        assignmentNames:
            json["assignment_names"] == null ? null : json["assignment_names"],
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
        positionName:
            json["position_name"] == null ? null : json["position_name"],
        user: json["user"] == null ? null : json["user"],
        userUsername:
            json["user_username"] == null ? null : json["user_username"],
        userName: json["user_name"] == null ? null : json["user_name"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        assignments: json["assignments"] == null
            ? null
            : List<Assignment>.from(
                json["assignments"].map((x) => Assignment.fromJson(x))),
        officerId: json["id"] == null ? null : json["id"],
      );

  Map<String, dynamic> toJson() => {
        "rt_number": rtNumber == null ? null : rtNumber,
        "rw_number": rwNumber == null ? null : rwNumber,
        "_id": id == null ? null : id,
        "id_card": idCard == null ? null : idCard,
        "name": name == null ? null : name,
        "gender": gender == null ? null : gender,
        "sub_district": subDistrict == null ? null : subDistrict,
        "street": street == null ? null : street,
        "rt": rt == null ? null : rt,
        "rw": rw == null ? null : rw,
        "phone": phone == null ? null : phone,
        "phone_2": phone2 == null ? null : phone2,
        "email": email == null ? null : email,
        "position": position == null ? null : position!.toJson(),
        "created_by": createdBy == null ? null : createdBy,
        "gender_name": genderName == null ? null : genderName,
        "assignment_names": assignmentNames == null ? null : assignmentNames,
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
        "position_name": positionName == null ? null : positionName,
        "user": user == null ? null : user,
        "user_username": userUsername == null ? null : userUsername,
        "user_name": userName == null ? null : userName,
        "created_at": createdAt == null ? null : createdAt.toString(),
        "updated_at": updatedAt == null ? null : updatedAt.toString(),
        "assignments": assignments == null
            ? null
            : List<dynamic>.from(assignments!.map((x) => x.toJson())),
        "id": officerId == null ? null : officerId,
      };
}

class Assignment {
  Assignment(
      {this.rwNumber,
      this.rtNumber,
      this.id,
      this.officer,
      this.rtPlace,
      this.rw,
      this.rt,
      this.villageCode,
      this.villageName,
      this.clientDisplayName,
      this.isChecked = false});

  int? rwNumber;
  int? rtNumber;
  String? id;
  String? officer;
  String? rtPlace;
  String? rw;
  String? rt;
  String? villageCode;
  String? villageName;
  String? clientDisplayName;
  bool isChecked;

  factory Assignment.fromJson(Map<String, dynamic> json) => Assignment(
        rwNumber: json["rw_number"] == null ? null : json["rw_number"],
        rtNumber: json["rt_number"] == null ? null : json["rt_number"],
        id: json["_id"] == null ? null : json["_id"],
        officer: json["officer"] == null ? null : json["officer"],
        rtPlace: json["rt_place"] == null ? null : json["rt_place"],
        rw: json["rw"] == null ? null : json["rw"],
        rt: json["rt"] == null ? null : json["rt"],
        villageCode: json["village_code"] == null ? null : json["village_code"],
        villageName: json["village_name"] == null ? null : json["village_name"],
        clientDisplayName: json["client_display_name"] == null
            ? null
            : json["client_display_name"],
        isChecked: json["is_checked"] == null ? false : json["is_checked"],
      );

  Map<String, dynamic> toJson() => {
        "rw_number": rwNumber == null ? null : rwNumber,
        "rt_number": rtNumber == null ? null : rtNumber,
        "_id": id == null ? null : id,
        "officer": officer == null ? null : officer,
        "rt_place": rtPlace == null ? null : rtPlace,
        "rw": rw == null ? null : rw,
        "rt": rt == null ? null : rt,
        "village_code": villageCode == null ? null : villageCode,
        "village_name": villageName == null ? null : villageName,
        "client_display_name":
            clientDisplayName == null ? null : clientDisplayName,
        "is_checked": isChecked == null ? false : isChecked,
      };
}

class Position {
  Position({
    this.id,
    this.name,
    this.positionId,
  });

  String? id;
  String? name;
  String? positionId;

  factory Position.fromJson(Map<String, dynamic> json) => Position(
        id: json["_id"] == null ? null : json["_id"],
        name: json["name"] == null ? null : json["name"],
        positionId: json["id"] == null ? null : json["id"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id == null ? null : id,
        "name": name == null ? null : name,
        "id": positionId == null ? null : positionId,
      };
}
