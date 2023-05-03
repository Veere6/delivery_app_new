
import 'dart:convert';

import '../Models/LoginModel.dart';
import 'package:http/http.dart'as http;

import '../Models/OrderListModel.dart';

class Service {

  static String BaseUrl = "https://cws.in.net/delivery_service/api/";

  static String Login = BaseUrl+"Login";
  static String OrderList = BaseUrl+"Order";

  static Future<LoginModel> LoginCredentials(String email, String pass) async {
    final params = {
      "flag": "delivery_boy_login",
      "user_name": email,
      "password": pass
    };
    print("LoginParams"+params.toString());
    http.Response response = await http.post(Uri.parse(Login), body: params);
    print("LoginResponse"+response.body);

    if(response.statusCode == 200) {
      var data = jsonDecode(response.body);
      LoginModel user = LoginModel.fromJson(data);
      return user;
    }else {
      print("LoginResponseError"+response.body);
      throw Exception('Failed');
    }
  }

  static Future<OrderListModel> DeliveryOrderList(String deliveryBoyId) async {
    final params = {
      "flag": "order_list",
      "delivery_boy_id": deliveryBoyId
    };
    print("OrderListParams"+params.toString());
    http.Response response = await http.post(Uri.parse(OrderList), body: params);
    print("OrderListResponse"+response.body);

    if(response.statusCode == 200) {
      var data = jsonDecode(response.body);
      OrderListModel user = OrderListModel.fromJson(data);
      return user;
    }else {
      print("OrderError "+response.body);
      throw Exception('Failed');
    }
  }
}