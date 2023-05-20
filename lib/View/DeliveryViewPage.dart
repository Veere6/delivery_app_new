import 'package:delivery_app/Models/OrderDeliverModel.dart';
import 'package:delivery_app/Services/Services.dart';
import 'package:delivery_app/View/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'dart:async';
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class DeliveryViewPage extends StatefulWidget {
  final String bagValue;
  final String totalValue;
  String orderId = "";
  String user_id;

  DeliveryViewPage({required this.bagValue, required this.totalValue, required this.orderId,required this.user_id});
  @override
  _DeliveryState createState() => _DeliveryState();
}

class _DeliveryState extends State<DeliveryViewPage> {

  File? _documentImage;
  late OrderDeliverModel _orderDeliverModel;

  Future<void> pickImage () async {
    try{
      final _docImage;
      _docImage = await ImagePicker().
      pickImage(
          source: ImageSource.camera,);

      setState((){
        if(_docImage != null){
          setState(() {
            _documentImage = File(_docImage.path);
          });
        }else{
          // print('No image capture');
        }
      });
    }catch(e){
      print("zfsdghfagsgdf ${e}");
    }
  }

  Future<void> OrderDeliver() async {
    _orderDeliverModel = await Service.OrderDeliver("${widget.user_id}", widget.orderId, _documentImage!);

    if(_orderDeliverModel.status == true){

      Fluttertoast.showToast(msg: _orderDeliverModel.msg.toString(),
          toastLength: Toast.LENGTH_SHORT);
      Navigator.pushAndRemoveUntil<dynamic>(
        context,
        MaterialPageRoute<dynamic>(
          builder: (BuildContext context) => HomePage(),
        ),
            (route) => false,//if you want to disable back feature set to false
      );
    }else {
      Fluttertoast.showToast(msg: _orderDeliverModel.msg.toString(),
          toastLength: Toast.LENGTH_SHORT);

    }
  }


  @override
  void initState() {
    initBackgroundFetch();
  }

  void initBackgroundFetch() {
    setState((){
      _currentAddress= "Loading...";
    });
    Geolocator.checkPermission().then((permission)async {
      if (permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
        final currentLocation = await Geolocator.getCurrentPosition();
        _getAddressFromLatLng(currentLocation);
      }
    });
  }
  String _currentAddress = "";
  Future<void> _getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(
        position!.latitude, position!.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        _currentAddress =
        "${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}";
      });
      print(_currentAddress);
    }).catchError((e) {
      if(mounted) {
        setState(() {
          _currentAddress = "Failed";
        });
        print(e);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              child: ConstrainedBox(
                constraints: BoxConstraints(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:<Widget> [
                    Container(
                      // height: 50,
                      // color: CommonColors.buttonColor,
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            color: Color(0xff25476a)
                        ),
                        margin: EdgeInsets.only(left: 15.0, top: 20.0, right: 15.0),
                        padding: EdgeInsets.all(10.0),
                        child:
                        Row(
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: Image.asset("images/back_icon.png",
                                height: 20.0,),
                            ),
                            Spacer(),
                            Container(
                              child: Image.asset("images/delivery_image.png",
                                height: 40,),
                            ),

                            Spacer(),
                            Image.asset("images/manu.png",
                              height: 20.0,),
                          ],
                        )
                      // Image.asset('assets/logo.png'),
                    ),
                    SizedBox(height: 25.0),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Card(
                        elevation: 5,
                        child: Container(
                          padding: EdgeInsets.all(10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 40,
                                padding: EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                    color: Color(0xffF1F0F6),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(8.0)
                                    )
                                ),
                                child: Row(
                                  children: [
                                    Image.asset("images/bag.png",
                                      height: 15.0,),
                                    SizedBox(width: 6.0),
                                    Text("Bag",
                                      style: TextStyle(fontWeight: FontWeight.w600),),
                                    Spacer(),
                                    Text("${widget.bagValue}",style: TextStyle(
                                    ),)
                                  ],
                                ),
                              ),
                              SizedBox(height: 16),
                              Container(
                                height: 40,
                                padding: EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                    color: Color(0xffF1F0F6),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(8.0)
                                    )
                                ),
                                child: Row(
                                  children: [
                                    Text("Total",
                                      style: TextStyle(fontWeight: FontWeight.w600),),
                                    Spacer(),
                                    Text("${widget.totalValue}",style: TextStyle(
                                    ),)
                                  ],
                                ),
                              ),
                              SizedBox(height: 10,),
                              Container(
                                child: Text("User Picture",
                                  style: TextStyle(fontWeight: FontWeight.w600),),
                              ),
                              SizedBox(height: 10,),
                              Container(
                                height: 250,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage("images/background_img.png"),
                                        fit: BoxFit.cover
                                    ),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(8.0)
                                    )
                                ),
                                padding: EdgeInsets.all(10.0),
                                child: InkWell(
                                  onTap: (){
                                    pickImage();
                                  },
                                  child: Container(
                                    height: 200,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Color(0xff25476A),
                                            width: 1
                                        ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5.0)
                                        )
                                    ),
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.all(5.0),
                                    child: _documentImage == null ?
                                    Image.asset("images/camera.png"):
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(20.0)
                                        )
                                      ),
                                      child: Image.file(
                                        _documentImage!,
                                        fit: BoxFit.cover,
                                        width: 150,
                                        height: 150,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20,),
                              InkWell(
                                onTap: (){
                                  initBackgroundFetch();
                                },
                                child: Container(
                                  height: 40,
                                  padding: EdgeInsets.all(10.0),
                                  decoration: BoxDecoration(
                                      color: Color(0xffF1F0F6),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8.0)
                                      )
                                  ),
                                  child: Row(
                                    children: [
                                      Image.asset("images/location.png",
                                        height: 15.0,),
                                      SizedBox(width: 10.0),
                                      Text("Location",
                                        style: TextStyle(fontWeight: FontWeight.w600),),
                                      Spacer(),
                                      Text("$_currentAddress",style: TextStyle(
                                      ),)
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 10,),
                              Container(
                                height: 40,
                                padding: EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                    color: Color(0xffF1F0F6),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(8.0)
                                    )
                                ),
                                child: Row(
                                  children: [
                                    Image.asset("images/calender.png",
                                      height: 15.0,),
                                    SizedBox(width: 5.0),
                                    Text("Date",
                                      style: TextStyle(fontWeight: FontWeight.w600),),
                                    Spacer(),
                                    Text("${DateFormat('dd-MM-yyyy').format(DateTime.now())}",style: TextStyle(
                                    ),)
                                  ],
                                ),
                              ),
                              SizedBox(height: 10,),
                              Container(
                                height: 40,
                                padding: EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                    color: Color(0xffF1F0F6),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(8.0)
                                    )
                                ),
                                child: Row(
                                  children: [
                                    Image.asset("images/clock.png",
                                      height: 15.0,),
                                    SizedBox(width: 10.0),
                                    Text("Time",
                                      style: TextStyle(fontWeight: FontWeight.w600),),
                                    Spacer(),
                                    Text("${DateFormat('kk:mm a').format(DateTime.now())}",style: TextStyle(
                                    ),)
                                  ],
                                ),
                              ),
                              SizedBox(height: 10,),
                              Container(
                                height: 40,
                                padding: EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                    color: Color(0xffF1F0F6),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(8.0)
                                    )
                                ),
                                child: Row(
                                  children: [
                                    Image.asset("images/cash.png",
                                      height: 15.0,),
                                    SizedBox(width: 10.0),
                                    Text("Cash Box",
                                      style: TextStyle(fontWeight: FontWeight.w600),),
                                    Spacer(),
                                    Text("#${widget.orderId}",style: TextStyle(
                                    ),)
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 40.0,),
                    Container(
                      margin: EdgeInsets.all(10.0),
                      alignment: Alignment.bottomCenter,
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          color: Color(0xff25476a)
                      ),
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
                            OrderDeliver();
                            // showDialog(
                            //     context: context,
                            //     builder: (context){
                            //       return Container(
                            //         child: Dialog(
                            //           shape: RoundedRectangleBorder(
                            //             borderRadius: BorderRadius.circular(10),
                            //           ),
                            //           child: Container(
                            //             width: MediaQuery.of(context).size.width,
                            //             height: 400,
                            //             decoration: const BoxDecoration(
                            //               borderRadius: BorderRadius.all(
                            //                   Radius.circular(40.0)),
                            //             ),
                            //             child: Column(
                            //               crossAxisAlignment: CrossAxisAlignment.center,
                            //               mainAxisAlignment: MainAxisAlignment.center,
                            //               children: [
                            //                 Container(
                            //                   child: Image.asset("images/success_img.png",
                            //                     height: 200,),
                            //                 ),
                            //                 Container(
                            //                   alignment: Alignment.center,
                            //                   child: Text("Order\nsuccessful",
                            //                     textAlign: TextAlign.center,
                            //                     style: TextStyle(fontWeight: FontWeight.w600,
                            //                         fontSize: 20),),
                            //                 ),
                            //                 SizedBox(height: 60,),
                            //                 Container(
                            //                   margin: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 20.0),
                            //                   alignment: Alignment.bottomCenter,
                            //                   decoration: const BoxDecoration(
                            //                       borderRadius: BorderRadius.all(Radius.circular(5.0)),
                            //                       color: Color(0xff25476a)
                            //                   ),
                            //                   // child: _isPageLoading ? Center(
                            //                   //   child: CircularProgressIndicator(),
                            //                   // ):
                            //                   child: ButtonTheme(
                            //                     minWidth: MediaQuery.of(context).size.width,
                            //                     height: 40,
                            //                     child: MaterialButton(
                            //                       highlightColor: Colors.transparent,
                            //                       splashColor: Colors.transparent,
                            //                       onPressed: () {
                            //                         // Navigator.of(context).push(MaterialPageRoute(
                            //                         //     builder: (context) => DeliveryViewPage(bagValue: "bagValue", totalValue: "totalValue")
                            //                         // ));
                            //                       },
                            //                       textColor: Colors.white,
                            //                       child: Padding(
                            //                         padding: const EdgeInsets.all(10.0),
                            //                         child: Text('Okay', style: TextStyle(fontWeight: FontWeight.w600),),
                            //                       ),
                            //                     ),
                            //                   ),
                            //                 ),
                            //
                            //               ],
                            //             ),
                            //           ),
                            //         ),
                            //       );
                            //     });
                          },
                          textColor: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text('Submit', style: TextStyle(fontWeight: FontWeight.w600),),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
      ),
    );
  }
}
