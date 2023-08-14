// To parse this JSON data, do
//
//     final orderDeliverModel = orderDeliverModelFromJson(jsonString);

import 'dart:convert';

OrderDeliverModel orderDeliverModelFromJson(String str) => OrderDeliverModel.fromJson(json.decode(str));

String orderDeliverModelToJson(OrderDeliverModel data) => json.encode(data.toJson());

class OrderDeliverModel {
  bool? status;
  String? message;
  String? error;

  OrderDeliverModel({
    this.status,
    this.message,
    this.error,
  });

  factory OrderDeliverModel.fromJson(Map<String, dynamic> json) => OrderDeliverModel(
    status: json["status"]==null ? null:json["status"],
    message: json["message"]==null ? null:json["message"],
    error: json["error"]==null ? null:json["error"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "error": error,
  };
}
