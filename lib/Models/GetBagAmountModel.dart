// To parse this JSON data, do
//
//     final getBagAmountModel = getBagAmountModelFromJson(jsonString);

import 'dart:convert';

GetBagAmountModel getBagAmountModelFromJson(String str) => GetBagAmountModel.fromJson(json.decode(str));

String getBagAmountModelToJson(GetBagAmountModel data) => json.encode(data.toJson());

class GetBagAmountModel {
  final bool? status;
  final String? msg;
  final List<BagsBody>? body;

  GetBagAmountModel({
    this.status,
    this.msg,
    this.body,
  });

  factory GetBagAmountModel.fromJson(Map<String, dynamic> json) => GetBagAmountModel(
    status: json["status"],
    msg: json["msg"],
    body: json["body"] == "" ? [] : List<BagsBody>.from(json["body"]!.map((x) => BagsBody.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": msg,
    "body": body == "" ? [] : List<dynamic>.from(body!.map((x) => x.toJson())),
  };
}

class BagsBody {
  final String? bagId;
  final String? bagName;
  final String? bageCode;
  final String? qrImage;
  final List<BagAmount>? data;

  BagsBody({
    this.bagId,
    this.bagName,
    this.bageCode,
    this.qrImage,
    this.data,
  });

  factory BagsBody.fromJson(Map<String, dynamic> json) => BagsBody(
    bagId: json["bag_id"],
    bagName: json["bag_name"],
    bageCode: json["bage_code"],
    qrImage: json["qr_image"],
    data: json["data"] == null ? [] : List<BagAmount>.from(json["data"]!.map((x) => BagAmount.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "bag_id": bagId,
    "bag_name": bagName,
    "bage_code": bageCode,
    "qr_image": qrImage,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class BagAmount {
  final String? bagLogId;
  final String? denomination;
  final String? count;
  final String? amount;
  final DateTime? date;
  final String? time;

  BagAmount({
    this.bagLogId,
    this.denomination,
    this.count,
    this.amount,
    this.date,
    this.time,
  });

  factory BagAmount.fromJson(Map<String, dynamic> json) => BagAmount(
    bagLogId: json["bag_log_id"],
    denomination: json["denomination"],
    count: json["count"],
    amount: json["amount"],
    date: json["date"] == null ? null : DateTime.parse(json["date"]),
    time: json["time"],
  );

  Map<String, dynamic> toJson() => {
    "bag_log_id": bagLogId,
    "denomination": denomination,
    "count": count,
    "amount": amount,
    "date": "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
    "time": time,
  };
}
