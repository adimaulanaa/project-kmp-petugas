import 'dart:convert';

RegionModel regionModelFromJson(String str) =>
    RegionModel.fromJson(json.decode(str));
String regionModelToJson(RegionModel data) => json.encode(data.toJson());
List<RegionModel> regionsModelFromJson(String str) => List<RegionModel>.from(
    json.decode(str).map((x) => RegionModel.fromJson(x)));

String regionsModelToJson(List<RegionModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RegionModel {
  RegionModel({
    this.id,
    this.name,
    this.type,
    this.level,
    this.parent,
  });

  String? id;
  String? name;
  String? type;
  int? level;
  String? parent;

  factory RegionModel.fromJson(Map<String, dynamic> json) => RegionModel(
        id: json["_id"] == null ? null : json["_id"],
        name: json["name"] == null ? null : json["name"],
        type: json["type"] == null ? null : json["type"],
        level: json["level"] == null ? null : json["level"],
        parent: json["parent"] == null ? null : json["parent"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id == null ? null : id,
        "name": name == null ? null : name,
        "type": type == null ? null : type,
        "level": level == null ? null : level,
        "parent": parent == null ? null : parent,
      };
}
