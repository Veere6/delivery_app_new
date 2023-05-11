// To parse this JSON data, do
//
//     final bagsmodel = bagsmodelFromJson(jsonString);

import 'dart:convert';

Bagsmodel bagsmodelFromJson(String str) => Bagsmodel.fromJson(json.decode(str));

String bagsmodelToJson(Bagsmodel data) => json.encode(data.toJson());

class Bagsmodel {
  List<Bag>? bags;

  Bagsmodel({
    this.bags,
  });

  factory Bagsmodel.fromJson(Map<String, dynamic> json) => Bagsmodel(
    bags: json["bags"] == null ? [] : List<Bag>.from(json["bags"]!.map((x) => Bag.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "bags": bags == null ? [] : List<dynamic>.from(bags!.map((x) => x.toJson())),
  };
}

class Bag {
  String? name;
  List<Datum>? data;

  Bag({
    this.name,
    this.data,
  });

  factory Bag.fromJson(Map<String, dynamic> json) => Bag(
    name: json["name"],
    data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Datum {
  String? denomination;
  String? count;
  String? amount;

  Datum({
    this.denomination,
    this.count,
    this.amount,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    denomination: json["denomination"],
    count: json["count"],
    amount: json["amount"],
  );

  Map<String, dynamic> toJson() => {
    "denomination": denomination,
    "count": count,
    "amount": amount,
  };
}
