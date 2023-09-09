import 'dart:convert';
import 'dart:io';

import 'package:delivery_app/Models/AddBagAmountModel.dart';
import 'package:delivery_app/Models/BagDetail.dart';
import 'package:delivery_app/Models/CommonModel.dart';
import 'package:delivery_app/Models/GetBagAmountModel.dart';
import 'package:delivery_app/Models/GetBagModel.dart';
import '../Models/LoginModel.dart';
import 'package:http/http.dart' as http;
import '../Models/OrderDeliverModel.dart';
import '../Models/OrderListModel.dart';

class Service {
  static String BaseUrl = "http://netra.161cloud.in/api/";
  // static String BaseUrl = "https://cws.in.net/delivery_service/api/";
  static String Login = BaseUrl + "user";
  static String OrderList = BaseUrl + "orders";
  static String GetBag = BaseUrl + "bags?order=";
  static String deleteBag = BaseUrl + "bag/";
  static String AddAmount = BaseUrl + "bag/add_to_order";
  static String OrderSubmit = BaseUrl + "order/";

  static Future<LoginModel> LoginCredentials(String email, String pass) async {
    // final params = {
    //   "flag": "delivery_boy_login",
    //   "user_name": email,
    //   "password": pass
    // };
    // print("LoginParams" + params.toString());

    Map<String, String> requestHeaders = {
      'Authorization': "Bearer ${pass}",
      'Content-Type': 'application/json'
    };
    http.Response response = await http.get(Uri.parse(Login), headers: requestHeaders);
    print("LoginResponse" + response.body);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      LoginModel user = LoginModel.fromJson(data);
      return user;
    } else {
      print("LoginResponseError" + response.body);
      throw Exception('Failed');
    }
  }

  static Future<List<OrderListModel>> DeliveryOrderList(String deliveryBoyId) async {
    // final params = {"flag": "order_list", "delivery_boy_id": deliveryBoyId};
    // print("OrderListParams" + params.toString());
    Map<String, String> requestHeaders = {
      'Authorization': "Bearer testdd",
      'Content-Type': 'application/json'
    };
    http.Response response = await http.get(Uri.parse(OrderList),headers: requestHeaders);
    print("OrderListResponse" + response.body);
    print("OrderListResponse" + deliveryBoyId);
    List<OrderListModel> orderlis = [];
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      orderlis = data.map((json) => OrderListModel.fromJson(json)).toList();
      // OrderListModel user = OrderListModel.fromJson(data);
      return orderlis;
    } else {
      print("OrderError " + response.body);
      throw Exception('Failed');
    }
  }

  static Future<GetBagModel> BagList(
    String deliveryBoyId,
    String order_id,) async {
    final params = {
      "flag": "get_bags_by_order_id",
      "delivery_boy_id": deliveryBoyId,
      "order_id": order_id
    };
    print("GetBagParams" + params.toString());
    http.Response response = await http.post(Uri.parse(GetBag), body: params);
    print("GetBagResponse" + response.body);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      GetBagModel user = GetBagModel.fromJson(data);
      return user;
    } else {
      print("GetBagError " + response.body);
      throw Exception('Failed');
    }
  }
  static Future<List<BagDetailList>> BagDetailAPi(String bag_id) async {
    print("GetBagParamsdetail" + GetBag+bag_id.toString());
    Map<String, String> requestHeaders = {
      'Authorization': "Bearer testdd",
      'Content-Type': 'application/json'
    };
    http.Response response = await http.get(Uri.parse(GetBag+bag_id),headers: requestHeaders);
    print("GetBagParamsdetail" + response.body);
    List<BagDetailList> orderlis = [];
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      orderlis = data.map((json) => BagDetailList.fromJson(json)).toList();

      // BagDetail user = BagDetail.fromJson(data);
      return orderlis;
    } else {
      print("GetBagError " + response.body);
      throw Exception('Failed');
    }
  }
  static Future<List<BagDetailList>> order_amount_by_bag(String order_id) async {
    // final params = {
    //   "flag": "order_amount_by_bag",
    //   "delivery_boy_id": deliveryBoyId,
    //   "order_id": order_id
    // };
    print("GetBagParams"+GetBag + order_id.toString());
    http.Response response = await http.post(Uri.parse(GetBag+order_id));
    print("GetBagResponseAmount" + response.body);
    List<BagDetailList> orderlis = [];
    if (response.statusCode == 200) {
      // var data = jsonDecode(response.body);
      // BagDetailList user = BagDetailList.fromJson(data);
      List<dynamic> data = jsonDecode(response.body);
      orderlis = data.map((json) => BagDetailList.fromJson(json)).toList();

      return orderlis;
    } else {
      print("GetBagError " + response.body);
      throw Exception('Failed');
    }
  }
  static Future<CommonModel> delete_bag_amount(String bag_id) async {
    // final params = {
    //   "flag": "delete_bag_amount",
    //   "bag_log_id": bag_log_id,
    //   "bag_id": bag_id
    // };
    Map<String, String> requestHeaders = {
      'Authorization': "Bearer testdd",
      'Content-Type': 'application/json'
    };
    print("GetBagParams" + "$deleteBag$bag_id/remove_from_order");
    http.Response response = await http.post(Uri.parse("$deleteBag$bag_id/remove_from_order"),headers: requestHeaders);
    print("GetBagResponseDELETE" + response.body);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      CommonModel user = CommonModel.fromJson(data);
      return user;
    } else {
      print("GetBagError " + response.body);
      throw Exception('Failed');
    }
  }
  static Future<bool> AddBagAmount(List object)async{
    final params = object;
    Map<String, String> requestHeaders = {
      'Authorization': "Bearer testdd",
      'Content-Type': 'application/json'
    };
    for(int i=0;i<params.length;i++){
      if(params[i].order==11111110){
        params.removeAt(i);
      }
    }
    String jsonString = jsonEncode(params);
    print("AddAmountParams" + jsonString.toString());
    // print("AddAmountParams" + params.toString());
    http.Response response = await http.post(Uri.parse(AddAmount),body: jsonString, headers: requestHeaders,);
    print("AddAmountResponse" + response.body);

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  static Future<OrderDeliverModel> OrderDeliver(
      String deliveryBoyId, String order_id, File image) async {
    var request = new http.MultipartRequest("POST", Uri.parse("$OrderSubmit$order_id/bagcomplete"));
    // request.fields['flag'] = "order_delivered";
    request.fields['delivery_boy_id'] = deliveryBoyId;
    // request.fields['order_id'] = order_id;
    // request.fields['status'] = "4";
    // print("objectasdasds ${request.fields}");
    print(">>>>>>>>>>$OrderSubmit$order_id/bagcomplete");
    Map<String, String> requestHeaders = {
      'Authorization': "Bearer testdd",
      'Content-Type': 'application/json'
    };
    print(">>>>>>>>>>$requestHeaders");
    var custImage = await http.MultipartFile.fromPath('image', image.path);
    request.files.add(custImage);
    request.headers.addAll(requestHeaders);
    var response = await request.send();
    var response2 = await http.Response.fromStream(response);

    print(response.toString());
    // print("OrderDeliver " + response2.body);

    if (response2.statusCode == 200) {
      var data = json.decode(response2.body.replaceAll("'", '"'));
      print("registraioneUploadersss " + data.toString());
      print(response);
      OrderDeliverModel user = OrderDeliverModel.fromJson(data);
      return user;
    } else {
      print("registraion ${response2.body}");
      throw Error();
    }
  }

}
