import 'dart:developer';
import 'dart:ffi';
import 'dart:io';

import 'package:delivery_app/Models/AddBagAmountModel.dart';
import 'package:delivery_app/Models/Bagsmodel.dart';
import 'package:delivery_app/Models/GetBagModel.dart';
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

  EditDeliveryPage(this.order_id, this.amount);

  @override
  _EditDeliveryPageState createState() => _EditDeliveryPageState();
}

class _EditDeliveryPageState extends State<EditDeliveryPage> {
  late GetBagModel _getBagModel;
  late AddtBagAmountModel _addtBagAmountModel;
  SharedPreferences? _bagPreferences;
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
  List<BagBody> _bag = [];
  List<TextEditingController> _controllers = [];
  List<TextEditingController> _controllersamount = [];
  String barcodeScanRes = "";

  Future<void> BagList() async {
    // print("ahdffghdfjlsdhf ${_bagPreferences?.getStringList("_bagList")}");

    if (barcodeScanRes.isNotEmpty) {
      _getBagModel = await Service.BagList("6", "5");
      if (_getBagModel.status == true) {
        setState(() {
          for (int i = 0; i < _getBagModel.body!.length; i++) {
            _bag = _getBagModel.body ?? <BagBody>[];
          }
        });
      }
    }
  }

  @override
  void dipose() {
    _bagPreferences?.clear();
  }

  getAsync() async {
    try {
      _bagPreferences = await SharedPreferences.getInstance();
      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  Future<bool> AddBagAmount(
      String count, String name, int position, String amount) async {
    _addtBagAmountModel = await Service.AddBagAmount(
        "6", "1", selectedDenomination.toString(), count, widget.order_id);

    if (_addtBagAmountModel.status == true) {
      Fluttertoast.showToast(
          msg: _addtBagAmountModel.msg.toString(),
          toastLength: Toast.LENGTH_SHORT);
      _addCashDetail(
          count, selectedDenomination.toString(), amount, name, position);
      // _addCashDetail(count);
      // print(_cashDetails);
      // print(_addtBagAmountModel.msg);
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

  void _addList(String bagname) {
    setState(() {
      bag_list.add(Bag(name: bagname, data: []));

      // _list.add(barcodeScanRes);
    });
  }

  // final List<Map<String, dynamic>> _cashDetails = [];

  // List<Datum> data=[];
  List<Bag> bag_list = [];

  void _addCashDetail(String count, String denomination, String amount,
      String name, int position) {
    // void _addCashDetail(String count) {
    setState(() {
      // print("Position ${position}");
      bag_list[position].data?.add(
          Datum(denomination: denomination, count: count, amount: amount));
      selectedDenomination = 'Select Denomination';
    });
  }
  void _removeCashDetail(int position,int removeposition) {
    // void _addCashDetail(String count) {
    setState(() {
      print("Position ${position}");
      bag_list[position].data?.removeAt(removeposition);
    });
  }

  double calculateTotalAmount(List<Datum> cashDetails) {
    return cashDetails.fold(0,
        (previousValue, map) => previousValue + int.parse(map.amount ?? "0"));
  }

  double finaltotolAmount(List<Bag> _cashdetails) {
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
    // print(widget.order_id);
    // print(_list);
    // print(_bagPreferences?.getStringList("_bagList"));
    super.initState();
    setState(() {});
    getAsync();
  }

  Future<void> scanBarcodeNormal() async {
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      if (barcodeScanRes.matchAsPrefix("-1") == null) {
        // _bagPreferences?.setStringList("_bagList", bag_list);
        _addList("A-${bag_list.length + 1} bag");
        BagList();
      }
      // print("ahdgfhdhf ${_list}");
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
                                  Image.asset(
                                    "images/person.png",
                                    height: 15.0,
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
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Image.asset(
                                    "images/bag.png",
                                    height: 15.0,
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
                              SizedBox(
                                height: 10,
                              ),
                              Container(
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
                    if (bag_list.isNotEmpty)
                      Container(
                        child: Column(
                          children: [
                            ListView.builder(
                                itemCount: bag_list.length,
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  _controllers.add(TextEditingController());
                                  _controllersamount
                                      .add(TextEditingController());
                                  List<Datum> _cashDetails =
                                      bag_list[index].data ?? [];
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
                                                              "${bag_list[index].name}",
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
                                                                selectedDenomination =
                                                                    data!;
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
                                                                  if (selectedDenomination !=
                                                                      "Select Denomination") {
                                                                    _controllersamount[
                                                                            index]
                                                                        .text = (int.parse(text) *
                                                                            int.parse(selectedDenomination.toString()))
                                                                        .toString();
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
                                                                "${bag_list[index].name}",
                                                                index,
                                                                (int.tryParse(selectedDenomination
                                                                            .toString())! *
                                                                        int.tryParse(_controllers[index]
                                                                            .text
                                                                            .toString())!)
                                                                    .toString());
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
                                                              'Add More',
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
                                                                          "${bag_list[index].name}",
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
                                                                              icon: new Icon(Icons.clear, size: 18.0),
                                                                              onPressed: () {
                                                                                _removeCashDetail(index,i);
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
                                                            "${calculateTotalAmount(bag_list[index].data ?? []).toInt()}",
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
                            if (bag_list.isNotEmpty)
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
                                      "${finaltotolAmount(bag_list ?? []).toInt()}",
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
                                    if (finaltotolAmount(bag_list ?? [])
                                            .toInt() ==
                                        int.parse(widget.amount)) {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  DeliveryViewPage(
                                                    bagValue: "bagValue",
                                                    totalValue: "totalValue",
                                                    orderId: widget.order_id,
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
