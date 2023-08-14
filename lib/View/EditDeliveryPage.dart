import 'dart:convert';
import 'package:delivery_app/Models/AddBagAmountModel.dart';
import 'package:delivery_app/Models/BagDetail.dart';
import 'package:delivery_app/Models/CommonModel.dart';
import 'package:delivery_app/Models/GetBagAmountModel.dart';
import 'package:delivery_app/Models/QrCodeDetail.dart';
import 'package:delivery_app/View/DeliveryViewPage.dart';
import 'package:flutter/material.dart';
import 'package:delivery_app/Services/Services.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditDeliveryPage extends StatefulWidget {
  String order_id = "";
  String amount = "";
  String status = "";

  EditDeliveryPage(this.order_id, this.amount,this.status);

  @override
  _EditDeliveryPageState createState() => _EditDeliveryPageState();
}

class _EditDeliveryPageState extends State<EditDeliveryPage> {
  // late GetBagAmountModel _getBagModel;
  late AddtBagAmountModel _addtBagAmountModel;
  List<String> denominationList = [
    'Select Denomination',
    '500',
    '100',
    '50',
    '20',
    '10'
  ];
  String? selectedDenomination = 'Select Denomination';
  TextEditingController count = TextEditingController();
  List<String> noOfBags = [];
  List<BagDetailList> _bag = [];
  List<TextEditingController> _controllers = [];
  List<TextEditingController> _controllers2 = [];
  List<TextEditingController> _controllersamount = [];
  List<TextEditingController> _controllersamount2 = [];
  String barcodeScanRes = "";
  late SharedPreferences preferences;


  List<BagDetailList> checklist=[];

  Future<void> BagList(String order_id) async {
    _bag.clear();
    checklist.clear();
    if (barcodeScanRes.isNotEmpty) {
      _bag = await Service.order_amount_by_bag(order_id);

      for (BagDetailList person in _bag) {
        // Check if the name is the same
        if (checklist.any((p) => p.name == person.name)) {
          // Name already exists in the filtered list, skip this person
          continue;
        }
        // Add the person to the filtered list

        checklist.add(person);
      }


      print("???????  $checklist");

      // if (_getBagModel.status == true) {
        setState((){
      //     for (int i = 0; i < _getBagModel.body!.length; i++) {
      //       _bag = _getBagModel.body ?? <BagDetail>[];
      //     }
        });
      // }
    }
  }


  void AddAmount(final object)async{
    await Service.AddBagAmount(object);
  }

  Future<bool> AddBagAmount(String name,String firstrs,String secondrs,String thirdrs,String fourrs,String fivers,
      String amount, String orderID) async {
    // bool iswork = await Service.AddBagAmount(name, firstrs, secondrs, thirdrs, fourrs, fivers, amount, orderID);

    _bag.add(
        BagDetailList.fromJson({
          "name": name,
          "10rs": int.tryParse(firstrs),
          "20rs": int.tryParse(secondrs),
          "50rs": int.tryParse(thirdrs),
          "100rs": int.tryParse(fourrs),
          "500rs": int.tryParse(fivers),
          "amount": int.tryParse(amount),
          "order": int.tryParse(orderID),
        }));
    for (BagDetailList person in _bag) {
      // Check if the name is the same
      if (checklist.any((p) => p.name == person.name)) {
        // Name already exists in the filtered list, skip this person
        continue;
      }
      // Add the person to the filtered list
      checklist.add(person);
    }
    setState(() {

    });
    return true;
    // if (iswork) {
    //   Fluttertoast.showToast(
    //       msg: "Amount added",
    //       toastLength: Toast.LENGTH_SHORT);
    //   // _addCashDetail(
    //   //     count, selectedDenomination.toString(), amount, name, position);
    //   // _addCashDetail(count);
    //   // print(_cashDetails);
    //   // print(_addtBagAmountModel.msg);
    //   _addList(bage_id);
    //   return true;
    // } else {
    //   Fluttertoast.showToast(
    //       msg: "Error found",
    //       toastLength: Toast.LENGTH_SHORT);
    //
    //   // print(_addtBagAmountModel.msg);
    //   return false;
    // }
  }

  final List<String> _list = [];


  void _addList(String bag_id) async{
    // checklist.clear();
    // _bag.clear();
      // bag_list.add(Bag(name: bagname, data: []));
     // _bag = await Service.BagDetailAPi("$bag_id");
     // if(_bag.isEmpty){
      _bag.add(
          BagDetailList.fromJson({
        "name": bag_id,
        "10rs": 0,
        "20rs": 0,
        "50rs": 0,
        "100rs": 0,
        "500rs": 0,
        "amount": 0,
        "order": 11111110,
      }));
    // }
     for (BagDetailList person in _bag) {
       // Check if the name is the same
       if (checklist.any((p) => p.name == person.name)) {
         // Name already exists in the filtered list, skip this person
         continue;
       }
       // Add the person to the filtered list
       checklist.add(person);
     }
      selectedDenomination= 'Select Denomination';
     print("???????? $checklist");
     setState(() {
    });
  }

  // final List<Map<String, dynamic>> _cashDetails = [];

  // List<Datum> data=[];
  // List<Bag> bag_list = [];

  // void _addCashDetail(String count, String denomination, String amount,
  //     String name, int position) {
  //   // void _addCashDetail(String count) {
  //   setState(() {
  //     // print("Position ${position}");
  //     bag_list[position].data?.add(
  //         Datum(denomination: denomination, count: count, amount: amount));
  //     selectedDenomination = 'Select Denomination';
  //   });
  // }

  void _removeCashDetail(int index) async {
    // void _addCashDetail(String count) {
    // CommonModel commonModel = await Service.delete_bag_amount(bag_id);
    // if(commonModel.status == true){
    //   BagList(widget.order_id);
    _bag.removeAt(index);
    setState(() {

    });
    // _addList(bage_id);
    // }
    // setState(() {
    //   print("Position ${position}");
    //   bag_list[position].data?.removeAt(removeposition);
    //   Fluttertoast.showToast(msg: "Amount deleted",gravity: ToastGravity.BOTTOM);
    // });
  }

  double calculateTotalAmount(List<BagDetailList> cashDetails) {
    return cashDetails.fold(0,
            (previousValue, map) => previousValue + int.parse(map.amount.toString() ?? "0"));
  }

  double finaltotolAmount(List<BagDetailList> _cashdetails) {
    return _cashdetails.fold(0,
            (previousValue, map) => previousValue + int.parse(map.amount.toString() ?? "0"));
  }

  String _scanBarcode = 'Unknown';

  var total;

  Future<void> scanQR() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);

      print("sdhghfsdbf" + barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
//barcode scanner flutter ant
    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }



  @override
  void initState() {
    getPrefs();

    super.initState();
  }
  String user_id="";
  void getPrefs()async{
    preferences = await SharedPreferences.getInstance();
    user_id = preferences.getString("user_id") ?? "";
    // BagList();
  }
  String bage_id="";
  Future<void> scanBarcodeNormal() async {
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      // if (barcodeScanRes.matchAsPrefix("-1") == null) {
      //   // _bagPreferences?.setStringList("_bagList", bag_list);
      //   // _addList("A-${bag_list.length + 1} bag");
      print("ahdgfhdhf ${barcodeScanRes}");
      // var data = jsonDecode(barcodeScanRes);
      // // GetBagAmountModel user = GetBagAmountModel.fromJson(data);
      // QrCodeDetail qrCodeDetail = QrCodeDetail.fromJson(data);
      // bage_id=qrCodeDetail.bage_id.toString();
      // bage_id="2";
      String extractedString = barcodeScanRes.substring(barcodeScanRes.lastIndexOf('/') + 1);
      print(extractedString);
      _addList(extractedString);
        // BagList("",barcodeScanRes);
      // }
      // print("ahdgfhdhf ${barcodeScanRes}");
      // print("njdsdhfshjdkfl "+barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    if (!mounted) return;
    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: null,
      body: Container(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              child: ConstrainedBox(
                constraints: BoxConstraints(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  verticalDirection: VerticalDirection.down,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                        // height: 50,
                        // color: CommonColors.buttonColor,
                        decoration: const BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                            color: Color(0xff25476a)),
                        margin:
                            EdgeInsets.only(left: 15.0, top: 20.0, right: 15.0),
                        padding: EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: Image.asset(
                                "images/back_icon.png",
                                height: 20.0,
                              ),
                            ),
                            Spacer(),
                            Container(
                              child: Image.asset(
                                "images/delivery_image.png",
                                height: 40.0,
                              ),
                            ),
                            Spacer(),
                            Image.asset(
                              "images/manu.png",
                              height: 20.0,
                            ),
                          ],
                        )
                        // Image.asset('assets/logo.png'),
                        ),
                    SizedBox(height: 16.0),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Card(
                        elevation: 5,
                        child: Container(
                          padding: EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                      margin: EdgeInsets.only(left: 10.0, top: 10.0, right: 10.0),
                                      child: Icon(Icons.bookmark_border)
                                  ),
                                  SizedBox(width: 6.0),
                                  Text(
                                    "Order Id",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                  Spacer(),
                                  Text(widget.order_id,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400))
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  Container(
                                      margin: EdgeInsets.only(left: 10.0, top: 10.0, right: 10.0),
                                      child: Icon(Icons.monetization_on_outlined)
                                  ),
                                  SizedBox(width: 6.0),
                                  Text(
                                    "Amount",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                  Spacer(),
                                  Text(
                                    widget.amount,
                                    style:
                                        TextStyle(fontWeight: FontWeight.w400),
                                  )
                                ],
                              ),

                              Row(
                                children: [
                                  Container(
                                      margin: EdgeInsets.only(left: 10.0, top: 10.0, right: 10.0),
                                      child: Icon(Icons.menu)
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 10.0,),
                                    child: Text( "Status: ",
                                      style: TextStyle(fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  Spacer(),
                                  Container(
                                    margin: EdgeInsets.only(top: 10.0,),
                                    child: Text("${widget.status=="1" ? "Pending":
                                    widget.status=="2" ? "Accepted":
                                    widget.status=="3" ? "Processing":
                                    widget.status=="4" ? "Picked-Up":
                                    widget.status=="5" ? "Complete": "Zone Delivery Complete"
                                    }",
                                      style: TextStyle(fontWeight: FontWeight.w400),
                                    ),
                                  )
                                ],
                              ),
                              // Row(
                              //   children: [
                              //     Image.asset(
                              //       "images/bag.png",
                              //       height: 15.0,
                              //     ),
                              //     SizedBox(width: 6.0),
                              //     Text(
                              //       "Amount",
                              //       style:
                              //           TextStyle(fontWeight: FontWeight.w600),
                              //     ),
                              //     Spacer(),
                              //     Text(
                              //       widget.amount,
                              //       style:
                              //           TextStyle(fontWeight: FontWeight.w400),
                              //     )
                              //   ],
                              // ),
                              SizedBox(
                                height: 10,
                              ),
                             if(widget.status!="5" && widget.status!="6") Container(
                                alignment: Alignment.bottomCenter,
                                decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5.0)),
                                    color: Color(0xff25476a)),
                                // child: _isPageLoading ? Center(
                                //   child: CircularProgressIndicator(),
                                // ):
                                child: ButtonTheme(
                                  minWidth: MediaQuery.of(context).size.width,
                                  height: 40,
                                  child: MaterialButton(
                                    highlightColor: Colors.transparent,
                                    splashColor: Colors.transparent,
                                    onPressed: () {
                                      // Navigator.of(context).push(MaterialPageRoute(
                                      //     builder: (context) => scanQR();
                                      // ));
                                      scanBarcodeNormal();
                                    },
                                    textColor: Colors.white,
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Text(
                                        'Add Bag',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    if (_bag.isNotEmpty)
                      Container(
                        child: Column(
                          children: [
                            ListView.builder(
                                itemCount: checklist.length,
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  _controllers.add(TextEditingController());
                                  _controllersamount.add(TextEditingController());
                                  BagDetailList _cashDetails = checklist[index];
                                  // bool isSkip=true;
                                  // if (_bag.any((p) => p.name == _cashDetails.name)) {
                                  //   // Name already exists in the filtered list, skip this person
                                  //   isSkip = false;
                                  // }
                                  int amount =0;
                                  for(var item in _bag){
                                    if(_cashDetails.name==item.name){
                                      amount=amount+item.amount!;
                                    }
                                  }


                                  return Container(
                                    child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.start,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 16.0),
                                        Container(
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 10.0),
                                            child: Card(
                                              elevation: 5,
                                              child: Column(
                                                mainAxisAlignment:
                                                MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    margin:
                                                    EdgeInsets.all(10.0),
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: Color(
                                                                0xffABAAB0),
                                                            width: 1.0),
                                                        borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                10.0))),
                                                    padding:
                                                    EdgeInsets.all(10.0),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .start,
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .start,
                                                      children: [
                                                        // SizedBox(height: 10,),
                                                        Row(
                                                          children: [
                                                            Image.asset(
                                                              "images/bag.png",
                                                              height: 15.0,
                                                            ),
                                                            SizedBox(
                                                                width: 6.0),
                                                            Text(
                                                              "Bag",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                            ),
                                                            Spacer(),
                                                            Text(
                                                              "${checklist[index].name}",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .w400),
                                                            ),
                                                            InkWell(
                                                              onTap: (){
                                                                setState(() {
                                                                  _bag.removeWhere((item) => item.name == checklist[index].name);
                                                                  checklist.removeAt(index);
                                                                });
                                                                // print(checklist);
                                                                // _removeCashDetail(_bag[index].id.toString());
                                                              },
                                                              child: Icon(Icons.delete_outline),
                                                            )
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        Container(
                                                          height: 1,
                                                          color: Colors.grey,
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                              flex:1,
                                                                child: Container(
                                                                  child: Text("Denomination",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w600),),
                                                                )
                                                            ),
                                                            SizedBox(height: 20,width: 20,),
                                                            Expanded(
                                                                flex:1,
                                                                child: Container(
                                                                  child: Text("Count",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w600)),
                                                                )
                                                            ),
                                                            SizedBox(height: 20,width: 20,)
                                                          ],
                                                        ),
                                                        SizedBox(height: 5,width: 20,),

                                                        Container(
                                            child: Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .start,
                                              crossAxisAlignment:
                                              CrossAxisAlignment
                                                  .start,
                                              children: [
                                                ListView.builder(
                                                    shrinkWrap: true,
                                                    scrollDirection:
                                                    Axis.vertical,
                                                    physics:
                                                    NeverScrollableScrollPhysics(),
                                                    itemCount:
                                                    _bag.length,
                                                    itemBuilder:
                                                        (context, i) {
                                                      int denomination=0;
                                                      int count=0;
                                                      if(_bag[i].the10Rs!=0){
                                                        denomination = 10;
                                                        count = _bag[i].the10Rs ?? 0;
                                                      }else if(_bag[i].the20Rs!=0){
                                                        denomination = 20;
                                                        count = _bag[i].the20Rs ?? 0;
                                                      }else if(_bag[i].the50Rs!=0){
                                                        denomination = 50;
                                                        count = _bag[i].the50Rs ?? 0;
                                                      }else if(_bag[i].the100Rs!=0){
                                                        denomination = 100;
                                                        count = _bag[i].the100Rs ?? 0;
                                                      }else if(_bag[i].the500Rs!=0){
                                                        denomination = 500;
                                                        count = _bag[i].the500Rs ?? 0;
                                                      }

                                                      return _cashDetails.name==_bag[i].name ?
                                                      _bag[i].order == 11111110 ? Container():
                                                      Container(
                                                        margin: EdgeInsets.only(top: 5),
                                                        child: Row(
                                                          children: [
                                                            Expanded(
                                                              flex:1,
                                                              child: Container(
                                                                  width: MediaQuery.of(context).size.width,
                                                                  height: 30,
                                                                  alignment: Alignment.centerLeft,
                                                                  padding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 2),
                                                                  decoration: BoxDecoration(
                                                                      color: Color(0xffF1F0F6),
                                                                      borderRadius: BorderRadius.all(Radius.circular(8.0))
                                                                  ),
                                                                  child: Text("${denomination}",style: TextStyle(fontSize: 10),)
                                                              ),
                                                            ),

                                                            SizedBox(height: 20,width: 20,),
                                                            Expanded(
                                                              flex:1,
                                                              child: Container(
                                                                  width: MediaQuery.of(context).size.width,
                                                                  height: 30,
                                                                  alignment: Alignment.centerLeft,
                                                                  padding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 2),
                                                                  decoration: BoxDecoration(
                                                                      color: Color(0xffF1F0F6),
                                                                      borderRadius: BorderRadius.all(Radius.circular(8.0))
                                                                  ),
                                                                  child: Text("${count}",style: TextStyle(fontSize: 10),)
                                                              ),
                                                            ),
                                                            SizedBox(height: 20,width: 10,),
                                                            SizedBox(height: 20,width: 20,
                                                                child: InkWell(
                                                                  child: Container(
                                                                    decoration: BoxDecoration(
                                                                      shape: BoxShape.circle,
                                                                      color: Colors.red,
                                                                    ),
                                                                    alignment: Alignment.center,
                                                                    child: Icon(Icons.remove,color:Colors.white,size: 15,),
                                                                  ),
                                                                  onTap: (){
                                                                    _removeCashDetail(i);
                                                                  },
                                                                )
                                                            )
                                                          ],
                                                        ),
                                                      ):Container();
                                                    }),
                                              ],
                                            ),
                                          ),
                                                        SizedBox(height: 5,width: 20,),

                                                        Row(
                                                          children: [
                                                            Expanded(
                                                              flex:1,
                                                                child: Container(
                                                                    width: MediaQuery.of(context).size.width,
                                                                    height: 30,
                                                                    alignment: Alignment.centerLeft,
                                                                    padding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 2),
                                                                    decoration: BoxDecoration(
                                                                        color: Color(0xffF1F0F6),
                                                                        borderRadius: BorderRadius.all(Radius.circular(8.0))
                                                                    ),
                                                                    child:

                                                                                                    DropdownButton(
                                                                                                      value:
                                                                                                          selectedDenomination,
                                                                                                      isExpanded: true,
                                                                                                      icon: Icon(Icons
                                                                                                          .keyboard_arrow_down_sharp),
                                                                                                      iconSize: 20,
                                                                                                      elevation: 16,
                                                                                                      style: TextStyle(
                                                                                                          color: Colors
                                                                                                              .black,fontSize: 10),
                                                                                                      underline:
                                                                                                          Container(
                                                                                                        height: 0,
                                                                                                        color: Colors
                                                                                                            .deepPurpleAccent,
                                                                                                      ),
                                                                                                      onChanged:
                                                                                                          (String? data) {
                                                                                                        setState(() {
                                                                                                          selectedDenomination = data!;
                                                                                                          if(selectedDenomination=="Select Denomination" && _controllers[index].text.isNotEmpty){
                                                                                                            _controllersamount[index]
                                                                                                                .text =
                                                                                                                (int
                                                                                                                    .parse(
                                                                                                                    _controllers[index].text) *
                                                                                                                    int
                                                                                                                        .parse("0"))
                                                                                                                    .toString();
                                                                                                          }else if(_controllers[index].text.isNotEmpty){
                                                                                                            _controllersamount[index].text =
                                                                                                                (int.parse(_controllers[index].text) *
                                                                                                                    int.parse(selectedDenomination.toString())).toString();
                                                                                                          }
                                                                                                        });
                                                                                                      },
                                                                                                      items: denominationList.map<
                                                                                                          DropdownMenuItem<
                                                                                                              String>>((String
                                                                                                          value) {
                                                                                                        return DropdownMenuItem<
                                                                                                            String>(
                                                                                                          value: value,
                                                                                                          child:
                                                                                                              Text(value),
                                                                                                        );
                                                                                                      }).toList(),
                                                                                                    ),

                                                                    // TextFormField(
                                                                    //   controller: _controllers[index],
                                                                    //   keyboardType: TextInputType.number,
                                                                    //   decoration: InputDecoration(
                                                                    //       hintText: 'Denomination',
                                                                    //       labelStyle: TextStyle(color: Colors.black,
                                                                    //           fontWeight: FontWeight.w400,fontSize: 10),
                                                                    //       hintStyle: TextStyle(
                                                                    //           color: Colors.black,
                                                                    //           fontWeight: FontWeight.w400,fontSize: 10),
                                                                    //       border: InputBorder.none),
                                                                    //   onChanged: (text) {
                                                                    //     // setState(() {
                                                                    //                                         //   if (selectedDenomination != "Select Denomination") {
                                                                    //                                         //     if(text.isEmpty){
                                                                    //                                         //       _controllersamount[index]
                                                                    //                                         //           .text =
                                                                    //                                         //           (int
                                                                    //                                         //               .parse(
                                                                    //                                         //               "0") *
                                                                    //                                         //               int
                                                                    //                                         //                   .parse(
                                                                    //                                         //                   selectedDenomination
                                                                    //                                         //                       .toString()))
                                                                    //                                         //               .toString();
                                                                    //                                         //     }else {
                                                                    //                                         //       _controllersamount[index]
                                                                    //                                         //           .text =
                                                                    //                                         //           (int
                                                                    //                                         //               .parse(
                                                                    //                                         //               text) *
                                                                    //                                         //               int
                                                                    //                                         //                   .parse(
                                                                    //                                         //                   selectedDenomination
                                                                    //                                         //                       .toString()))
                                                                    //                                         //               .toString();
                                                                    //                                         //     }
                                                                    //                                         //     }
                                                                    //                                         // });
                                                                    //   },
                                                                    //   // style: TextStyle(fontSize: 18.0),
                                                                    // )
                                                                ),
                                                            ),

                                                            SizedBox(height: 20,width: 20,),
                                                            Expanded(
                                                              flex:1,
                                                              child: Container(
                                                                  width: MediaQuery.of(context).size.width,
                                                                  height: 30,
                                                                  alignment: Alignment.centerLeft,
                                                                  padding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 2),
                                                                  decoration: BoxDecoration(
                                                                      color: Color(0xffF1F0F6),
                                                                      borderRadius: BorderRadius.all(Radius.circular(8.0))
                                                                  ),
                                                                  child: TextFormField(
                                                                    controller: _controllers[index],
                                                                    keyboardType: TextInputType.number,
                                                                    decoration: InputDecoration(
                                                                        hintText: 'Count',
                                                                        labelStyle: TextStyle(color: Colors.black,
                                                                            fontWeight: FontWeight.w400,fontSize: 10),
                                                                        hintStyle: TextStyle(
                                                                            color: Colors.black,
                                                                            fontWeight: FontWeight.w400,fontSize: 10),
                                                                        border: InputBorder.none),
                                                                    onChanged: (text) {
                                                                      // setState(() {
                                                                      //   if (selectedDenomination != "Select Denomination") {
                                                                      //     if(text.isEmpty){
                                                                      //       _controllersamount[index]
                                                                      //           .text =
                                                                      //           (int
                                                                      //               .parse(
                                                                      //               "0") *
                                                                      //               int
                                                                      //                   .parse(
                                                                      //                   selectedDenomination
                                                                      //                       .toString()))
                                                                      //               .toString();
                                                                      //     }else {
                                                                      //       _controllersamount[index]
                                                                      //           .text =
                                                                      //           (int
                                                                      //               .parse(
                                                                      //               text) *
                                                                      //               int
                                                                      //                   .parse(
                                                                      //                   selectedDenomination
                                                                      //                       .toString()))
                                                                      //               .toString();
                                                                      //     }
                                                                      //     }
                                                                      // });
                                                                    },
                                                                    style: TextStyle(fontSize: 10.0),
                                                                  )
                                                              ),
                                                            ),
                                                            SizedBox(height: 20,width: 10,),
                                                            SizedBox(height: 20,width: 20,
                                                              child: InkWell(
                                                                child: Container(
                                                                  decoration: BoxDecoration(
                                                                    shape: BoxShape.circle,
                                                                    color: Colors.green,
                                                                  ),
                                                                  alignment: Alignment.center,
                                                                  child: Icon(Icons.add,color:Colors.white,size: 15,),
                                                                ),
                                                                onTap: (){
                                                                  String firstrs="0";
                                                                  String secondrs="0";
                                                                  String thirdrs="0";
                                                                  String fourrs="0";
                                                                  String fivers="0";
                                                                  if(selectedDenomination=="10"){
                                                                    firstrs=_controllers[index].text.toString();
                                                                  }else if(selectedDenomination=="20"){
                                                                    secondrs=_controllers[index].text.toString();
                                                                  }else if(selectedDenomination=="50"){
                                                                    thirdrs=_controllers[index].text.toString();
                                                                  }else if(selectedDenomination=="100"){
                                                                    fourrs=_controllers[index].text.toString();
                                                                  }else if(selectedDenomination=="500"){
                                                                    fivers=_controllers[index].text.toString();
                                                                  }
                                                                  AddBagAmount("${checklist[index].name}", firstrs, secondrs, thirdrs, fourrs, fivers,  (int.tryParse(selectedDenomination.toString())! *
                                                                      int.tryParse(_controllers[index].text.toString())!)
                                                                      .toString(), "${widget.order_id}");

                                                                  setState(() {
                                                                    _controllers[index].text = "";
                                                                    _controllersamount[index].text = "";

                                                                  });
                                                                },
                                                              )
                                                            )
                                                          ],
                                                        ),

                                                      ],
                                                    ),
                                                  ),
                                                  if (_bag.isNotEmpty )
                                                    Container(
                                                      width: MediaQuery.of(context).size.width,
                                                      height: 40,
                                                      margin: EdgeInsets.all(10.0),
                                                      alignment: Alignment.centerLeft,
                                                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                                                      decoration: BoxDecoration(
                                                          color: Color(0xffF1F0F6),
                                                          borderRadius: BorderRadius.all(
                                                              Radius.circular(8.0))),
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                            "${amount}", // "",
                                                            style: TextStyle(
                                                                fontWeight: FontWeight.w400),),
                                                          Spacer(),
                                                          Text(
                                                            "Total",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            )),
                                      ],
                                    ),
                                  );
                                }),
                            SizedBox(
                              height: 10,
                            ),
                            if (finaltotolAmount(_bag ?? []).toInt()!=0)
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: 40,
                                margin: EdgeInsets.all(10.0),
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.symmetric(horizontal: 10.0),
                                decoration: BoxDecoration(
                                    color: Color(0xffF1F0F6),
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(8.0))),
                                child: Row(
                                  children: [
                                    Text(
                                      "${finaltotolAmount(_bag ?? []).toInt()}",
                                      // "",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400),
                                    ),
                                    Spacer(),
                                    Text(
                                      "Final Total",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ),
                            Container(
                              margin: EdgeInsets.only(
                                  left: 10.0, right: 10.0, bottom: 20.0),
                              alignment: Alignment.bottomCenter,
                              decoration: const BoxDecoration(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                                  color: Color(0xff25476a)),
                              // child: _isPageLoading ? Center(
                              //   child: CircularProgressIndicator(),
                              // ):
                              child: ButtonTheme(
                                minWidth: MediaQuery.of(context).size.width,
                                height: 40,
                                child: MaterialButton(
                                  highlightColor: Colors.transparent,
                                  splashColor: Colors.transparent,
                                  onPressed: () {
                                    if (finaltotolAmount(_bag ?? []).toInt() ==
                                        int.parse(widget.amount)) {
                                      AddAmount(_bag);
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  DeliveryViewPage(
                                                    bagValue: "${_bag.fold("",(previousValue, element) =>  previousValue+","+element.name.toString())}",
                                                    totalValue: "${finaltotolAmount(_bag ?? []).toInt()}",
                                                    orderId: widget.order_id,
                                                    user_id: user_id,
                                                  )));
                                    } else {
                                      Fluttertoast.showToast(
                                          msg: "total amount is not same",
                                          gravity: ToastGravity.BOTTOM);
                                    }
                                  },
                                  textColor: Colors.white,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                      'Next',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )

                    else
                      Container(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
