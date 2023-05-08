// To parse this JSON data, do
//
//     final orderDeliverModel = orderDeliverModelFromJson(jsonString);

import 'dart:convert';

OrderDeliverModel orderDeliverModelFromJson(String str) {
  final jsonData = json.decode(str);
  return OrderDeliverModel.fromJson(jsonData);
}

String orderDeliverModelToJson(OrderDeliverModel data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class OrderDeliverModel {
  bool? status;
  String? msg;
  String? body;

  OrderDeliverModel({
    this.status,
    this.msg,
    this.body,
  });

  factory OrderDeliverModel.fromJson(Map<String, dynamic> json) => new OrderDeliverModel(
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
