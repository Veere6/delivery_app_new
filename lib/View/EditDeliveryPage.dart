import 'package:delivery_app/View/DeliveryViewPage.dart';
import 'package:flutter/material.dart';

class EditDeliveryPage extends StatefulWidget {
  @override
  _EditDeliveryPageState createState() => _EditDeliveryPageState();
}

class _EditDeliveryPageState extends State<EditDeliveryPage> {
  final List<Map<String, dynamic>> _cashDetails = [
    {'denomination': 100, 'count': 2, 'amount': 200},
    {'denomination': 500, 'count': 3, 'amount': 1500},
  ];

  void _addCashDetail() {
    setState(() {
      _cashDetails.add({'denomination': 2000, 'count': 1, 'amount': 2000});
    });
  }

  double calculateTotalAmount(List<Map<String, dynamic>> cashDetails) {
    return cashDetails.fold(0, (previousValue, map) => previousValue + map['amount']);
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
                mainAxisSize: MainAxisSize.max,
                verticalDirection: VerticalDirection.down,
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
                              height: 40.0,),
                          ),

                          Spacer(),
                          Image.asset("images/manu.png",
                            height: 20.0,),
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
                                Image.asset("images/person.png",
                                height: 15.0,),
                                SizedBox(width: 6.0),
                                Text("Order",
                                style: TextStyle(fontWeight: FontWeight.w600),),
                                Spacer(),
                                Text("1234567809",
                                    style: TextStyle(fontWeight: FontWeight.w400))
                              ],
                            ),
                            SizedBox(height: 10,),
                            Row(
                              children: [
                                Image.asset("images/bag.png",
                                height: 15.0,),
                                SizedBox(width: 6.0),
                                Text("Bag",
                                style: TextStyle(fontWeight: FontWeight.w600),),
                                Spacer(),
                                Text("A1",style: TextStyle(
                                    fontWeight: FontWeight.w400
                                ),)
                              ],
                            ),
                            SizedBox(height: 10,),
                            Container(
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

                                  },
                                  textColor: Colors.white,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text('Add Bag', style: TextStyle(fontWeight: FontWeight.w600),),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Card(
                      elevation: 5,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Color(0xffABAAB0),
                                width: 1.0),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0)
                              )
                            ),
                            padding: EdgeInsets.all(10.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: Text("Cash",
                                  style: TextStyle(fontWeight: FontWeight.w600),),
                                ),
                                SizedBox(height: 5,),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Color(0xffF1F0F6),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8.0)
                                    )
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Color(0xffABAAB0),
                                    width: 1.0),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(10.0)
                                )
                            ),
                            padding: EdgeInsets.all(10.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: Text("Denomination",
                                    style: TextStyle(fontWeight: FontWeight.w600),),
                                ),
                                SizedBox(height: 5,),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 40,
                                  alignment: Alignment.centerLeft,
                                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                                  decoration: BoxDecoration(
                                      color: Color(0xffF1F0F6),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8.0)
                                      )
                                  ),
                                  child: Text("500", style: TextStyle(
                                      fontWeight: FontWeight.w400
                                  ),),
                                ),
                                SizedBox(height: 5,),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 40,
                                  alignment: Alignment.centerLeft,
                                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                                  decoration: BoxDecoration(
                                      color: Color(0xffF1F0F6),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8.0)
                                      )
                                  ),
                                  child: Text("200", style: TextStyle(
                                      fontWeight: FontWeight.w400
                                  ),),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Color(0xffABAAB0),
                                    width: 1.0),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(10.0)
                                )
                            ),
                            padding: EdgeInsets.all(10.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: Text("Count",
                                    style: TextStyle(fontWeight: FontWeight.w600),),
                                ),
                                SizedBox(height: 5,),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 40,
                                  alignment: Alignment.centerLeft,
                                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                                  decoration: BoxDecoration(
                                      color: Color(0xffF1F0F6),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8.0)
                                      )
                                  ),
                                  child: Text("100", style: TextStyle(
                                      fontWeight: FontWeight.w400
                                  ),),
                                ),
                                SizedBox(height: 5,),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 40,
                                  alignment: Alignment.centerLeft,
                                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                                  decoration: BoxDecoration(
                                      color: Color(0xffF1F0F6),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8.0)
                                      )
                                  ),
                                  child: Text("100", style: TextStyle(
                                      fontWeight: FontWeight.w400
                                  ),),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerRight,
                            child: Container(
                              margin: EdgeInsets.all(10.0),
                              width: 200,
                              height: 45,
                              alignment: Alignment.centerRight,
                              decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                  color: Color(0xff25476a)
                              ),
                              // child: _isPageLoading ? Center(
                              //   child: CircularProgressIndicator(),
                              // ):
                              child: ButtonTheme(
                                minWidth: 200,
                                height: 40,
                                child: MaterialButton(
                                  highlightColor: Colors.transparent,
                                  splashColor: Colors.transparent,
                                  onPressed: () {
                                    // if (_formKey.currentState!.validate()) {
                                    //   _formKey.currentState!.save();
                                    //   Navigator.push(context,
                                    //     MaterialPageRoute(builder: (context) => HomePage()),
                                    //   );
                                    // }
                                  },
                                  textColor: Colors.white,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text('Add More', style: TextStyle(fontWeight: FontWeight.w600),),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Color(0xffABAAB0),
                                    width: 1.0),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(10.0)
                                )
                            ),
                            padding: EdgeInsets.all(10.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: Text("Amount",
                                    style: TextStyle(fontWeight: FontWeight.w600),),
                                ),
                                SizedBox(height: 5,),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 40,
                                  alignment: Alignment.centerLeft,
                                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                                  decoration: BoxDecoration(
                                      color: Color(0xffF1F0F6),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8.0)
                                      )
                                  ),
                                  child: Text("50000", style: TextStyle(
                                      fontWeight: FontWeight.w400
                                  ),),
                                ),
                                SizedBox(height: 5,),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 40,
                                  alignment: Alignment.centerLeft,
                                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                                  decoration: BoxDecoration(
                                      color: Color(0xffF1F0F6),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8.0)
                                      )
                                  ),
                                  child: Text("20000", style: TextStyle(
                                      fontWeight: FontWeight.w400
                                  ),),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 40,
                            margin: EdgeInsets.all(10.0),
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.symmetric(horizontal: 10.0),
                            decoration: BoxDecoration(
                                color: Color(0xffF1F0F6),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(8.0)
                                )
                            ),
                            child: Row(
                              children: [
                                Text("70000", style: TextStyle(
                                    fontWeight: FontWeight.w400
                                ),),
                                Spacer(),
                                Text("Total", style: TextStyle(
                                    fontWeight: FontWeight.w600
                                ),),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
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
                            child: Text('Next', style: TextStyle(fontWeight: FontWeight.w600),),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
