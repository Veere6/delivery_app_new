// To parse this JSON data, do
//
//     final bagDetail = bagDetailFromJson(jsonString);

import 'dart:convert';

List<BagDetail> bagDetailFromJson(String str) => List<BagDetail>.from(json.decode(str).map((x) => BagDetail.fromJson(x)));

String bagDetailToJson(List<BagDetail> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BagDetail {
  int? id;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? name;
  int? the10Rs;
  int? the20Rs;
  int? the50Rs;
  int? the100Rs;
  int? the500Rs;
  int? amount;
  int? order;
  int? deliveryAdmin;
  dynamic bankAdmin;
  dynamic ccAdmin;
  dynamic sortAdmin;
  dynamic acceptedAt;
  dynamic sortAcceptedAt;

  BagDetail({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.name,
    this.the10Rs,
    this.the20Rs,
    this.the50Rs,
    this.the100Rs,
    this.the500Rs,
    this.amount,
    this.order,
    this.deliveryAdmin,
    this.bankAdmin,
    this.ccAdmin,
    this.sortAdmin,
    this.acceptedAt,
    this.sortAcceptedAt,
  });

  factory BagDetail.fromJson(Map<String, dynamic> json) => BagDetail(
    id: json["id"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    name: json["name"],
    the10Rs: json["10rs"],
    the20Rs: json["20rs"],
    the50Rs: json["50rs"],
    the100Rs: json["100rs"],
    the500Rs: json["500rs"],
    amount: json["amount"],
    order: json["order"],
    deliveryAdmin: json["delivery_admin"],
    bankAdmin: json["bank_admin"],
    ccAdmin: json["cc_admin"],
    sortAdmin: json["sort_admin"],
    acceptedAt: json["accepted_at"],
    sortAcceptedAt: json["sort_accepted_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "name": name,
    "10rs": the10Rs,
    "20rs": the20Rs,
    "50rs": the50Rs,
    "100rs": the100Rs,
    "500rs": the500Rs,
    "amount": amount,
    "order": order,
    "delivery_admin": deliveryAdmin,
    "bank_admin": bankAdmin,
    "cc_admin": ccAdmin,
    "sort_admin": sortAdmin,
    "accepted_at": acceptedAt,
    "sort_accepted_at": sortAcceptedAt,
  };
}
