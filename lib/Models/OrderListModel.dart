// To parse this JSON data, do
//
//     final orderListModel = orderListModelFromJson(jsonString);

import 'dart:convert';

List<OrderListModel> orderListModelFromJson(String str) => List<OrderListModel>.from(json.decode(str).map((x) => OrderListModel.fromJson(x)));

String orderListModelToJson(List<OrderListModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class OrderListModel {
  int? id;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? branch;
  String? email;
  String? manager;
  int? amount;
  String? type;
  int? status;
  int? chest;
  String? processedby;
  int? deliveryAdmin;

  OrderListModel({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.branch,
    this.email,
    this.manager,
    this.amount,
    this.type,
    this.status,
    this.chest,
    this.processedby,
    this.deliveryAdmin,
  });

  factory OrderListModel.fromJson(Map<String, dynamic> json) => OrderListModel(
    id: json["id"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    branch: json["branch"],
    email: json["email"],
    manager: json["manager"],
    amount: json["amount"],
    type: json["type"],
    status: json["status"],
    chest: json["chest"],
    processedby: json["processedby"],
    deliveryAdmin: json["delivery_admin"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "branch": branch,
    "email": email,
    "manager": manager,
    "amount": amount,
    "type": type,
    "status": status,
    "chest": chest,
    "processedby": processedby,
    "delivery_admin": deliveryAdmin,
  };
}
