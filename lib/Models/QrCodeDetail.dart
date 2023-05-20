// To parse this JSON data, do
//
//     final qrCodeDetail = qrCodeDetailFromJson(jsonString);

import 'dart:convert';

QrCodeDetail qrCodeDetailFromJson(String str) => QrCodeDetail.fromJson(json.decode(str));

String qrCodeDetailToJson(QrCodeDetail data) => json.encode(data.toJson());

class QrCodeDetail {
  final String? bage_id;
  final String? bagName;
  final String? bageCode;
  final String? deliveryBoyId;

  QrCodeDetail({
    this.bage_id,
    this.bagName,
    this.bageCode,
    this.deliveryBoyId,
  });

  factory QrCodeDetail.fromJson(Map<String, dynamic> json) => QrCodeDetail(
    bage_id: json["bage_id"].toString(),
    bagName: json["bag_name"],
    bageCode: json["bage_code"],
    deliveryBoyId: json["delivery_boy_id"],
  );

  Map<String, dynamic> toJson() => {
    "bage_id": bage_id,
    "bag_name": bagName,
    "bage_code": bageCode,
    "delivery_boy_id": deliveryBoyId,
  };
}
