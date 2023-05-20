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
  late GetBagAmountModel _getBagModel;
  late AddtBagAmountModel _addtBagAmountModel;
  List<String> denominationList = [
    'Select Denomination',
    '2000',
    '500',
    '200',
    '100',
    '50'
  ];
  String? selectedDenomination = 'Select Denomination';
  TextEditingController count = TextEditingController();
  List<String> noOfBags = [];
  List<BagsBody> _bag = [];
  List<TextEditingController> _controllers = [];
  List<TextEditingController> _controllersamount = [];
  String barcodeScanRes = "";
  late SharedPreferences preferences;
  Future<void> BagList() async {
    _bag.clear();
    if (barcodeScanRes.isNotEmpty) {
      _getBagModel = await Service.order_amount_by_bag("$user_id", widget.order_id);
      if (_getBagModel.status == true) {
        setState(() {
          for (int i = 0; i < _getBagModel.body!.length; i++) {
            _bag = _getBagModel.body ?? <BagsBody>[];
          }
        });
      }
    }
  }


  Future<bool> AddBagAmount(
      String count, String name, int position, String amount,String bag_id) async {
    _addtBagAmountModel = await Service.AddBagAmount(
        "$user_id", bag_id, selectedDenomination.toString(), count, widget.order_id);

    if (_addtBagAmountModel.status == true) {
      Fluttertoast.showToast(
          msg: _addtBagAmountModel.msg.toString(),
          toastLength: Toast.LENGTH_SHORT);
      // _addCashDetail(
      //     count, selectedDenomination.toString(), amount, name, position);
      // _addCashDetail(count);
      // print(_cashDetails);
      // print(_addtBagAmountModel.msg);
      BagList();
      return true;
    } else {
      Fluttertoast.showToast(
          msg: _addtBagAmountModel.msg.toString(),
          toastLength: Toast.LENGTH_SHORT);

      print(_addtBagAmountModel.msg);
      return false;
    }
  }

  final List<String> _list = [];

  void _addList(String bag_id) async{


      // bag_list.add(Bag(name: bagname, data: []));
     BagDetail _bagdetails = await Service.BagDetailAPi("$bag_id");

     if(_bagdetails.status==true){
     if(_bagdetails.body!=null) {
       _bag.add(BagsBody(bagId: "${_bagdetails.body?[0].bagId}",
           bagName: "${_bagdetails.body?[0].bagName}",
           bageCode: "${_bagdetails.body?[0].bageCode}",
           qrImage: "${_bagdetails.body?[0].qrImage}",
           data: []));
       // _list.add(barcodeScanRes);
     }
     }else{
       Fluttertoast.showToast(msg: "${_bagdetails.msg}",gravity: ToastGravity.BOTTOM);
     }
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

  void _removeCashDetail(String bag_log_id,String bag_id) async {
    // void _addCashDetail(String count) {
    CommonModel commonModel = await Service.delete_bag_amount(bag_log_id, bag_id);
    if(commonModel.status == true){
      BagList();
    }
    // setState(() {
    //   print("Position ${position}");
    //   bag_list[position].data?.removeAt(removeposition);
    //   Fluttertoast.showToast(msg: "Amount deleted",gravity: ToastGravity.BOTTOM);
    // });
  }

  double calculateTotalAmount(List<BagAmount> cashDetails) {
    return cashDetails.fold(0,
        (previousValue, map) => previousValue + int.parse(map.amount ?? "0"));
  }

  double finaltotolAmount(List<BagsBody> _cashdetails) {
    return _cashdetails.fold(
        0,
        (previousValue, element) =>
            previousValue +
            (element.data!.fold(
                0,
                (previousValue2, element2) =>
                    previousValue2 + int.parse(element2.amount ?? "0"))));
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

  Future<void> scanBarcodeNormal() async {
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      // if (barcodeScanRes.matchAsPrefix("-1") == null) {
      //   // _bagPreferences?.setStringList("_bagList", bag_list);
      //   // _addList("A-${bag_list.length + 1} bag");
      var data = jsonDecode(barcodeScanRes);
      // GetBagAmountModel user = GetBagAmountModel.fromJson(data);
      QrCodeDetail qrCodeDetail = QrCodeDetail.fromJson(data);
      _addList(qrCodeDetail.bage_id.toString());
        // BagList("",barcodeScanRes);
      // }
      print("ahdgfhdhf ${barcodeScanRes}");
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
                                itemCount: _bag.length,
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  _controllers.add(TextEditingController());
                                  _controllersamount
                                      .add(TextEditingController());
                                  List<BagAmount> _cashDetails = _bag[index].data ?? [];
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
                                                              "${_bag[index].bagName}",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400),
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
                                                        Container(
                                                          child: Text(
                                                            "Denomination",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        Container(
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                          height: 50,
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      10.0),
                                                          decoration: BoxDecoration(
                                                              color: Color(
                                                                  0xffF1F0F6),
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          8.0))),
                                                          child: DropdownButton(
                                                            value:
                                                                selectedDenomination,
                                                            isExpanded: true,
                                                            icon: Icon(Icons
                                                                .keyboard_arrow_down_sharp),
                                                            iconSize: 20,
                                                            elevation: 16,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black),
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
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        Container(
                                                          child: Text(
                                                            "Count",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        Container(
                                                            width: MediaQuery
                                                                    .of(context)
                                                                .size
                                                                .width,
                                                            height: 50,
                                                            alignment:
                                                                Alignment
                                                                    .centerLeft,
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        10.0),
                                                            decoration: BoxDecoration(
                                                                color: Color(
                                                                    0xffF1F0F6),
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            8.0))),
                                                            child:
                                                                TextFormField(
                                                              controller:
                                                                  _controllers[
                                                                      index],
                                                              keyboardType:
                                                                  TextInputType
                                                                      .number,
                                                              decoration: InputDecoration(
                                                                  hintText:
                                                                      'Count',
                                                                  labelStyle: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400),
                                                                  hintStyle: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400),
                                                                  border:
                                                                      InputBorder
                                                                          .none),
                                                              onChanged:
                                                                  (text) {
                                                                setState(() {
                                                                  if (selectedDenomination != "Select Denomination") {
                                                                    if(text.isEmpty){
                                                                      _controllersamount[index]
                                                                          .text =
                                                                          (int
                                                                              .parse(
                                                                              "0") *
                                                                              int
                                                                                  .parse(
                                                                                  selectedDenomination
                                                                                      .toString()))
                                                                              .toString();
                                                                    }else {
                                                                      _controllersamount[index]
                                                                          .text =
                                                                          (int
                                                                              .parse(
                                                                              text) *
                                                                              int
                                                                                  .parse(
                                                                                  selectedDenomination
                                                                                      .toString()))
                                                                              .toString();
                                                                    }
                                                                    }
                                                                });
                                                              },
                                                              // style: TextStyle(fontSize: 18.0),
                                                            )),
                                                        if (_controllers[index]
                                                            .text
                                                            .isNotEmpty)
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                        if (_controllers[index]
                                                            .text
                                                            .isNotEmpty)
                                                          Container(
                                                            child: Text(
                                                              "Amount",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                            ),
                                                          ),
                                                        if (_controllers[index]
                                                            .text
                                                            .isNotEmpty)
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                        if (_controllers[index]
                                                            .text
                                                            .isNotEmpty)
                                                          Container(
                                                              width: MediaQuery
                                                                      .of(
                                                                          context)
                                                                  .size
                                                                  .width,
                                                              height: 50,
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          10.0),
                                                              decoration: BoxDecoration(
                                                                  color: Color(
                                                                      0xffF1F0F6),
                                                                  borderRadius:
                                                                      BorderRadius.all(Radius
                                                                          .circular(
                                                                              8.0))),
                                                              child:
                                                                  TextFormField(
                                                                controller:
                                                                    _controllersamount[
                                                                        index],
                                                                enabled: false,
                                                                keyboardType:
                                                                    TextInputType
                                                                        .number,
                                                                decoration: InputDecoration(
                                                                    hintText:
                                                                        'amount',
                                                                    labelStyle: TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w400),
                                                                    hintStyle: TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w400),
                                                                    border:
                                                                        InputBorder
                                                                            .none),
                                                                onChanged:
                                                                    (text) {
                                                                  setState(
                                                                      () {});
                                                                },
                                                                // style: TextStyle(fontSize: 18.0),
                                                              )),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: Container(
                                                      margin:
                                                          EdgeInsets.all(10.0),
                                                      width: 200,
                                                      height: 45,
                                                      alignment:
                                                          Alignment.centerRight,
                                                      decoration: const BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          5.0)),
                                                          color: Color(
                                                              0xff25476a)),
                                                      // child: _isPageLoading ? Center(
                                                      //   child: CircularProgressIndicator(),
                                                      // ):
                                                      child: ButtonTheme(
                                                        minWidth: 200,
                                                        height: 40,
                                                        child: MaterialButton(
                                                          highlightColor: Colors
                                                              .transparent,
                                                          splashColor: Colors
                                                              .transparent,
                                                          onPressed: () async {
                                                            AddBagAmount(
                                                                _controllers[
                                                                        index]
                                                                    .text,
                                                                "${_bag[index].bagName}",
                                                                index,
                                                                (int.tryParse(selectedDenomination
                                                                            .toString())! *
                                                                        int.tryParse(_controllers[index]
                                                                            .text
                                                                            .toString())!)
                                                                    .toString(),_bag[index].bagId.toString());
                                                            setState(() {
                                                              _controllers[index].text = "";
                                                              _controllersamount[index].text = "";

                                                            });
                                                            // if(istrue) {

                                                            // _cashDetails.add({
                                                            //       'denomination': selectedDenomination,
                                                            //       'count': _controllers[index].text,
                                                            //       'amount': int.tryParse(selectedDenomination.toString())! * int.tryParse(_controllers[index].text.toString())!}
                                                            // );
                                                            // _cashDetails.add(Bagsmodel(denomination: selectedDenomination,count: _controllers[index].text,amount: int.tryParse(selectedDenomination.toString())! * int.tryParse(_controllers[index].text.toString())!));
                                                            // print("working r");
                                                            // setState(() {});
                                                            // }
                                                          },
                                                          textColor:
                                                              Colors.white,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(10.0),
                                                            child: Text(
                                                              'Add',
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
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
                                                                _cashDetails
                                                                    .length,
                                                            itemBuilder:
                                                                (context, i) {
                                                              return Container(
                                                                margin: EdgeInsets
                                                                    .all(10.0),
                                                                decoration: BoxDecoration(
                                                                    border: Border.all(
                                                                        color: Color(
                                                                            0xffABAAB0),
                                                                        width:
                                                                            1.0),
                                                                    borderRadius:
                                                                        BorderRadius.all(
                                                                            Radius.circular(10.0))),
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            10.0),
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Row(
                                                                      children: [
                                                                        Image
                                                                            .asset(
                                                                          "images/bag.png",
                                                                          height:
                                                                              15.0,
                                                                        ),
                                                                        SizedBox(
                                                                            width:
                                                                                6.0),
                                                                        Text(
                                                                          "Bag - ",
                                                                          style:
                                                                              TextStyle(fontWeight: FontWeight.w600),
                                                                        ),
                                                                        Text(
                                                                          "${_bag[index].bagName}",
                                                                          style:
                                                                              TextStyle(fontWeight: FontWeight.w400),
                                                                        ),
                                                                        Spacer(),
                                                                        SizedBox(
                                                                            height:
                                                                                18.0,
                                                                            width:
                                                                                18.0,
                                                                            child:
                                                                                new IconButton(
                                                                              padding: new EdgeInsets.all(0.0),
                                                                              icon: new Icon(Icons.delete, size: 18.0),
                                                                              onPressed: () {
                                                                                _removeCashDetail(_cashDetails[i].bagLogId.toString(),_bag[index].bagId.toString());
                                                                              },
                                                                            ))
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                      height:
                                                                          10,
                                                                    ),
                                                                    Container(
                                                                      height: 1,
                                                                      color: Colors
                                                                          .grey,
                                                                    ),
                                                                    SizedBox(
                                                                      height:
                                                                          10,
                                                                    ),
                                                                    Container(
                                                                      child:
                                                                          Text(
                                                                        "Denomination",
                                                                        style: TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.w600),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      height: 5,
                                                                    ),
                                                                    Container(
                                                                      margin: const EdgeInsets
                                                                              .only(
                                                                          top:
                                                                              10,
                                                                          bottom:
                                                                              10.0),
                                                                      width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width,
                                                                      height:
                                                                          40,
                                                                      alignment:
                                                                          Alignment
                                                                              .centerLeft,
                                                                      padding: EdgeInsets.symmetric(
                                                                          horizontal:
                                                                              10.0),
                                                                      decoration: BoxDecoration(
                                                                          color: Color(
                                                                              0xffF1F0F6),
                                                                          borderRadius:
                                                                              BorderRadius.all(Radius.circular(8.0))),
                                                                      // child: Text("${_cashDetails[i]['denomination']}"),
                                                                      child: Text(
                                                                          "${_cashDetails[i].denomination}"),
                                                                    ),
                                                                    Container(
                                                                      child:
                                                                          Text(
                                                                        "Count",
                                                                        style: TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.w600),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      height: 5,
                                                                    ),
                                                                    Container(
                                                                      margin: const EdgeInsets
                                                                              .only(
                                                                          top:
                                                                              10,
                                                                          bottom:
                                                                              10.0),
                                                                      width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width,
                                                                      height:
                                                                          40,
                                                                      alignment:
                                                                          Alignment
                                                                              .centerLeft,
                                                                      padding: EdgeInsets.symmetric(
                                                                          horizontal:
                                                                              10.0),
                                                                      decoration: BoxDecoration(
                                                                          color: Color(
                                                                              0xffF1F0F6),
                                                                          borderRadius:
                                                                              BorderRadius.all(Radius.circular(8.0))),
                                                                      // child: Text("${_cashDetails[i]['count']}"),
                                                                      child: Text(
                                                                          "${_cashDetails[i].count}"),
                                                                    ),
                                                                    Container(
                                                                      child:
                                                                          Text(
                                                                        "Amount",
                                                                        style: TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.w600),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      height: 5,
                                                                    ),
                                                                    Container(
                                                                      margin: const EdgeInsets
                                                                              .only(
                                                                          top:
                                                                              10,
                                                                          bottom:
                                                                              10.0),
                                                                      width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width,
                                                                      height:
                                                                          40,
                                                                      alignment:
                                                                          Alignment
                                                                              .centerLeft,
                                                                      padding: EdgeInsets.symmetric(
                                                                          horizontal:
                                                                              10.0),
                                                                      decoration: BoxDecoration(
                                                                          color: Color(
                                                                              0xffF1F0F6),
                                                                          borderRadius:
                                                                              BorderRadius.all(Radius.circular(8.0))),
                                                                      // child: Text("${_cashDetails[i]['amount']}"),
                                                                      child: Text(
                                                                          "${_cashDetails[i].amount}"),
                                                                    )
                                                                  ],
                                                                ),
                                                              );
                                                            }),
                                                      ],
                                                    ),
                                                  ),
                                                  if (_cashDetails.isNotEmpty)
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      height: 40,
                                                      margin:
                                                          EdgeInsets.all(10.0),
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 10.0),
                                                      decoration: BoxDecoration(
                                                          color:
                                                              Color(0xffF1F0F6),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          8.0))),
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                            "${calculateTotalAmount(_bag[index].data ?? []).toInt()}",
                                                            // "",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                          ),
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
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  DeliveryViewPage(
                                                    bagValue: "${_bag.fold("", (previousValue, element) => previousValue+" "+element.bagName.toString())}",
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
