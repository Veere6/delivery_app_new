import 'package:delivery_app/CommonMethod/CommonColors.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';

class DeliveryViewPage extends StatelessWidget {
  final String bagValue;
  final String totalValue;

  DeliveryViewPage({required this.bagValue, required this.totalValue});

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
                                  Text("A1",style: TextStyle(
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
                                  Text("70000",style: TextStyle(
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
                              height: 70,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage("images/background_img.png"),
                                fit: BoxFit.cover),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8.0)
                                )
                              ),
                              padding: EdgeInsets.all(10.0),
                              child: Container(
                                height: 60,
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
                                child: Image.asset("images/camera.png"),
                              ),
                            ),
                            SizedBox(height: 20,),
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
                                  Image.asset("images/location.png",
                                    height: 15.0,),
                                  SizedBox(width: 10.0),
                                  Text("Location",
                                    style: TextStyle(fontWeight: FontWeight.w600),),
                                  Spacer(),
                                  Text("",style: TextStyle(
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
                                  Image.asset("images/calender.png",
                                    height: 15.0,),
                                  SizedBox(width: 5.0),
                                  Text("Date",
                                    style: TextStyle(fontWeight: FontWeight.w600),),
                                  Spacer(),
                                  Text("28-04-2023",style: TextStyle(
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
                                  Text("18:23",style: TextStyle(
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
                                  Text("#2334",style: TextStyle(
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
                          showDialog(
                              context: context,
                              builder: (context){
                                return Container(
                                  child: Dialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: 400,
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(40.0)),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            child: Image.asset("images/success_img.png",
                                            height: 200,),
                                          ),
                                          Container(
                                            alignment: Alignment.center,
                                            child: Text("Order\nsuccessful",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontWeight: FontWeight.w600,
                                            fontSize: 20),),
                                          ),
                                          SizedBox(height: 60,),
                                        Container(
                                              margin: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 20.0),
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
                                                    Navigator.of(context).push(MaterialPageRoute(
                                                        builder: (context) => DeliveryViewPage(bagValue: "bagValue", totalValue: "totalValue")
                                                    ));
                                                  },
                                                  textColor: Colors.white,
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(10.0),
                                                    child: Text('Okay', style: TextStyle(fontWeight: FontWeight.w600),),
                                                  ),
                                                ),
                                              ),
                                            ),

                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              });
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
