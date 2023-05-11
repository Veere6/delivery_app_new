// To parse this JSON data, do
//
//     final getBagModel = getBagModelFromJson(jsonString);

import 'dart:convert';

GetBagModel getBagModelFromJson(String str) {
  final jsonData = json.decode(str);
  return GetBagModel.fromJson(jsonData);
}

String getBagModelToJson(GetBagModel data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class GetBagModel {
  bool? status;
  String? msg;
  List<BagBody>? body;

  GetBagModel({
    this.status,
    this.msg,
    this.body,
  });

  factory GetBagModel.fromJson(Map<String, dynamic> json) => new GetBagModel(
    status: json["status"],
    msg: json["msg"],
    body: json["body"].toString()=="" ? null : new List<BagBody>.from(json["body"].map((x) => BagBody.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": msg,
    "body": new List<dynamic>.from(body!.map((x) => x.toJson())),
  };
}

class BagBody {
  String? bagLogId;
  String? orderId;
  String? bagId;
  String? denomination;
  String? count;
  String? amount;
  String? date;
  String? time;
  String? bagName;
  String? bageCode;

  BagBody({
    this.bagLogId,
    this.orderId,
    this.bagId,
    this.denomination,
    this.count,
    this.amount,
    this.date,
    this.time,
    this.bagName,
    this.bageCode,
  });

  factory BagBody.fromJson(Map<String, dynamic> json) => new BagBody(
    bagLogId: json["bag_log_id"],
    orderId: json["order_id"],
    bagId: json["bag_id"],
    denomination: json["denomination"],
    count: json["count"],
    amount: json["amount"],
    date: json["date"],
    time: json["time"],
    bagName: json["bag_name"],
    bageCode: json["bage_code"],
  );

  Map<String, dynamic> toJson() => {
    "bag_log_id": bagLogId,
    "order_id": orderId,
    "bag_id": bagId,
    "denomination": denomination,
    "count": count,
    "amount": amount,
    "date": date,
    "time": time,
    "bag_name": bagName,
    "bage_code": bageCode,
  };
}
