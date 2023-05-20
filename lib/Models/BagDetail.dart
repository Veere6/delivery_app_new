// To parse this JSON data, do
//
//     final bagDetail = bagDetailFromJson(jsonString);

import 'dart:convert';

BagDetail bagDetailFromJson(String str) => BagDetail.fromJson(json.decode(str));

String bagDetailToJson(BagDetail data) => json.encode(data.toJson());

class BagDetail {
  final bool? status;
  final String? msg;
  final List<Body>? body;

  BagDetail({
    this.status,
    this.msg,
    this.body,
  });

  factory BagDetail.fromJson(Map<String, dynamic> json) => BagDetail(
    status: json["status"],
    msg: json["msg"],
    body: json["body"] == null ? [] : List<Body>.from(json["body"]!.map((x) => Body.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": msg,
    "body": body == null ? [] : List<dynamic>.from(body!.map((x) => x.toJson())),
  };
}

class Body {
  final String? bagId;
  final String? bagName;
  final String? bageCode;
  final String? deliveryBoyId;
  final String? qrImage;

  Body({
    this.bagId,
    this.bagName,
    this.bageCode,
    this.deliveryBoyId,
    this.qrImage,
  });

  factory Body.fromJson(Map<String, dynamic> json) => Body(
    bagId: json["bag_id"],
    bagName: json["bag_name"],
    bageCode: json["bage_code"],
    deliveryBoyId: json["delivery_boy_id"],
    qrImage: json["qr_image"],
  );

  Map<String, dynamic> toJson() => {
    "bag_id": bagId,
    "bag_name": bagName,
    "bage_code": bageCode,
    "delivery_boy_id": deliveryBoyId,
    "qr_image": qrImage,
  };
}
