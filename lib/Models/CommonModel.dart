// To parse this JSON data, do
//
//     final CommonModel = CommonModelFromJson(jsonString);

import 'dart:convert';

CommonModel CommonModelFromJson(String str) {
  final jsonData = json.decode(str);
  return CommonModel.fromJson(jsonData);
}

String CommonModelToJson(CommonModel data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class CommonModel {
  bool? status;
  String? msg;
  String? body;

  CommonModel({
    this.status,
    this.msg,
    this.body,
  });

  factory CommonModel.fromJson(Map<String, dynamic> json) => new CommonModel(
    status: json["status"],
    msg: json["msg"],
    body: json["body"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": msg,
    "body": body,
  };
}
