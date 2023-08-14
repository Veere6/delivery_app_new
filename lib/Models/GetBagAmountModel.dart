// To parse this JSON data, do
//
//     final bagDetailList = bagDetailListFromJson(jsonString);

import 'dart:convert';

List<BagDetailList> bagDetailListFromJson(String str) => List<BagDetailList>.from(json.decode(str).map((x) => BagDetailList.fromJson(x)));

String bagDetailListToJson(List<BagDetailList> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BagDetailList {
  String? name;
  int? the10Rs;
  int? the20Rs;
  int? the50Rs;
  int? the100Rs;
  int? the500Rs;
  int? amount;
  int? order;

  BagDetailList({
    this.name,
    this.the10Rs,
    this.the20Rs,
    this.the50Rs,
    this.the100Rs,
    this.the500Rs,
    this.amount,
    this.order
  });

  factory BagDetailList.fromJson(Map<String, dynamic> json) => BagDetailList(
    name: json["name"],
    the10Rs: json["10rs"],
    the20Rs: json["20rs"],
    the50Rs: json["50rs"],
    the100Rs: json["100rs"],
    the500Rs: json["500rs"],
    amount: json["amount"],
    order: json["order"]
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "10rs": the10Rs,
    "20rs": the20Rs,
    "50rs": the50Rs,
    "100rs": the100Rs,
    "500rs": the500Rs,
    "amount": amount,
    "order": order
  };
}
