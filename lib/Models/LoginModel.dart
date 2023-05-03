// To parse this JSON data, do
//
//     final loginModel = loginModelFromJson(jsonString);

import 'dart:convert';

LoginModel loginModelFromJson(String str) {
  final jsonData = json.decode(str);
  return LoginModel.fromJson(jsonData);
}

String loginModelToJson(LoginModel data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class LoginModel {
  bool? status;
  String? msg;
  Body? body;

  LoginModel({
    this.status,
    this.msg,
    this.body,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) => new LoginModel(
    status: json["status"],
    msg: json["msg"],
    body: Body.fromJson(json["body"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": msg,
    "body": body?.toJson(),
  };
}

class Body {
  String? userId;
  String? email;
  String? name;
  String? userRole;
  List<AlotedZone>? alotedZone;

  Body({
    this.userId,
    this.email,
    this.name,
    this.userRole,
    this.alotedZone,
  });

  factory Body.fromJson(Map<String, dynamic> json) => new Body(
    userId: json["user_id"],
    email: json["email"],
    name: json["name"],
    userRole: json["user_role"],
    alotedZone: new List<AlotedZone>.from(json["aloted_zone"].map((x) => AlotedZone.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "email": email,
    "name": name,
    "user_role": userRole,
    "aloted_zone": new List<dynamic>.from(alotedZone!.map((x) => x.toJson())),
  };
}

class AlotedZone {
  String? zoneId;

  AlotedZone({
    this.zoneId,
  });

  factory AlotedZone.fromJson(Map<String, dynamic> json) => new AlotedZone(
    zoneId: json["zone_id"],
  );

  Map<String, dynamic> toJson() => {
    "zone_id": zoneId,
  };
}
