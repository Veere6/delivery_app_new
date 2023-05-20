// To parse this JSON data, do
//
//     final orderListModel = orderListModelFromJson(jsonString);

import 'dart:convert';

OrderListModel orderListModelFromJson(String str) {
  final jsonData = json.decode(str);
  return OrderListModel.fromJson(jsonData);
}

String orderListModelToJson(OrderListModel data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class OrderListModel {
  bool? status;
  String? msg;
  List<Body>? body;

  OrderListModel({
    this.status,
    this.msg,
    this.body,
  });

  factory OrderListModel.fromJson(Map<String, dynamic> json) => new OrderListModel(
    status: json["status"],
    msg: json["msg"],
    body: json["body"]=="" ? null : new List<Body>.from(json["body"].map((x) => Body.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": msg,
    "body": new List<dynamic>.from(body!.map((x) => x.toJson())),
  };
}

class Body {
  String? orderId;
  String? amount;
  String? amountWord;
  String? mapLink;
  String? status;
  String? dateTime;
  String? amountType;
  String? branchName;
  String? zoneName;

  Body({
    this.orderId,
    this.amount,
    this.amountWord,
    this.mapLink,
    this.status,
    this.dateTime,
    this.amountType,
    this.branchName,
    this.zoneName,
  });

  factory Body.fromJson(Map<String, dynamic> json) => new Body(
    orderId: json["order_id"],
    amount: json["amount"],
    amountWord: json["amount_word"],
    mapLink: json["map_link"],
    status: json["status"],
    dateTime: json["date_time"],
    amountType: json["amount_type"],
    branchName: json["branch_name"],
    zoneName: json["zone_name"],
  );

  Map<String, dynamic> toJson() => {
    "order_id": orderId,
    "amount": amount,
    "amount_word": amountWord,
    "map_link": mapLink,
    "status": status,
    "date_time": dateTime,
    "amount_type": amountType,
    "branch_name": branchName,
    "zone_name": zoneName,
  };
}
