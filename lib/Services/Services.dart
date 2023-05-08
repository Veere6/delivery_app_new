
import 'dart:convert';
import 'dart:io';

import 'package:delivery_app/Models/AddBagAmountModel.dart';
import 'package:delivery_app/Models/GetBagModel.dart';

import '../Models/LoginModel.dart';
import 'package:http/http.dart'as http;

import '../Models/OrderDeliverModel.dart';
import '../Models/OrderListModel.dart';

class Service {

  static String BaseUrl = "https://cws.in.net/delivery_service/api/";

  static String Login = BaseUrl+"Login";
  static String OrderList = BaseUrl+"Order";
  static String GetBag = BaseUrl+"Order";
  static String AddAmount = BaseUrl+"Order";
  static String OrderSubmit = BaseUrl+"Order";

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

  static Future<GetBagModel> BagList(String deliveryBoyId, String order_id,) async {
    final params = {
      "flag": "get_bags_by_order_id",
      "delivery_boy_id": deliveryBoyId,
      "order_id": order_id
    };
    print("GetBagParams"+params.toString());
    http.Response response = await http.post(Uri.parse(GetBag), body: params);
    print("GetBagResponse"+response.body);

    if(response.statusCode == 200) {
      var data = jsonDecode(response.body);
      GetBagModel user = GetBagModel.fromJson(data);
      return user;
    }else {
      print("GetBagError "+response.body);
      throw Exception('Failed');
    }
  }

  static Future<AddtBagAmountModel> AddBagAmount(String deliveryBoyId, String bag_id, String denomination, String note_count, String order_id) async {
    final params = {
      "flag": "add_bag_amount",
      "delivery_boy_id": deliveryBoyId,
      "bag_id": bag_id,
      "note_denomination": denomination,
      "note_count": note_count,
      "order_id": order_id
    };
    print("AddAmountParams"+params.toString());
    http.Response response = await http.post(Uri.parse(AddAmount), body: params);
    print("AddAmountResponse"+response.body);

    if(response.statusCode == 200) {
      var data = jsonDecode(response.body);
      AddtBagAmountModel user = AddtBagAmountModel.fromJson(data);
      return user;
    }else {
      print("AddAmountError "+response.body);
      throw Exception('Failed');
    }
  }

  static Future<OrderDeliverModel> OrderDeliver(String deliveryBoyId, String order_id, File image) async {

    var request = new http.MultipartRequest("POST", Uri.parse(OrderSubmit));

    request.fields['flag'] = "order_delivered";
    request.fields['delivery_boy_id'] = deliveryBoyId;
    request.fields['order_id'] = order_id;

    print("objectasdasds ${request.fields}");

    var custImage = await http.MultipartFile.fromPath('image', image.path);
    request.files.add(custImage);


    var response = await request.send();
    var response2 = await http.Response.fromStream(response);

    print(response.toString());
    print("OrderDeliver "+response2.body);

    if (response2.statusCode == 200){
      var data = json.decode(response2.body);
      print("registraioneUploadersss "+data.toString());
      print(response);
      OrderDeliverModel user = OrderDeliverModel.fromJson(data);
      return user;

    }else{
  print("registraion ${response2.body}");
  throw Error();
  }

}
}