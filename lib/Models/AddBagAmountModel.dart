// To parse this JSON data, do
//
//     final addtBagAmountModel = addtBagAmountModelFromJson(jsonString);

import 'dart:convert';

AddtBagAmountModel addtBagAmountModelFromJson(String str) {
  final jsonData = json.decode(str);
  return AddtBagAmountModel.fromJson(jsonData);
}

String addtBagAmountModelToJson(AddtBagAmountModel data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class AddtBagAmountModel {
  bool? status;
  String? msg;
  int? body;

  AddtBagAmountModel({
    this.status,
    this.msg,
    this.body,
  });

  factory AddtBagAmountModel.fromJson(Map<String, dynamic> json) => new AddtBagAmountModel(
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
