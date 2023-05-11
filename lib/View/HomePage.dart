import 'package:delivery_app/CommonMethod/CommonColors.dart';
import 'package:delivery_app/Models/OrderListModel.dart';
import 'package:delivery_app/Services/Services.dart';
import 'package:delivery_app/View/EditDeliveryPage.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _MyStatefulWidgetPageState createState() => _MyStatefulWidgetPageState();
}


class _MyStatefulWidgetPageState extends State<HomePage> {
  List<Body> _orderList = [];
  late OrderListModel _orderListModel;
  bool _isPageLoading = false;


  Future<void> GetOrderList() async {
    _isPageLoading = true;
    _orderListModel = await Service.DeliveryOrderList("6");
    if(_orderListModel.status == true){
      setState(() {
        _isPageLoading = false;
        for(int i=0; i<_orderListModel.body!.length; i++){
          _orderList = _orderListModel.body ?? <Body> [];
        }
      });
    }
  }





  @override
  void initState(){
    GetOrderList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/
    final double itemHeight = (size.width / 1.5)+20;
    final double itemWidth = size.width / 1.5;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          color: Color(0xff25476a)
                      ),
                    margin: EdgeInsets.only(left: 15.0, top: 20.0, right: 15.0),
                    padding: EdgeInsets.all(10.0),
                    child:
                    Row(
                      children: [
                        Image.asset("images/back_icon.png",
                        height: 20.0,),
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
                  SizedBox(height: 10.0),
                  Container(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Today`s Deliveries',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  _isPageLoading ?  Center(
                    child: CircularProgressIndicator(
                      color: Color(0xff25476A),
                    ),
                  ):ListView.builder(
                    shrinkWrap: true,
                      itemCount: _orderList.length,
                      scrollDirection: Axis.vertical,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index){
                      Body body = _orderList[index];
                        return InkWell(
                          onTap: (){
                          },
                          child:Card(
                          color: Colors.transparent,
                        margin: EdgeInsets.fromLTRB(20, 0, 20, 20),
                        elevation: 8.0,
                        shadowColor: Colors.black,
                        child: Container(
                        // width: MediaQuery.of(context).size.width,
                        // height: 150,
                        decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.white
                        ),
                          child: Row(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(left: 10.0, top: 10.0, right: 10.0),
                                        child: Image.asset("images/person.png",
                                        height: 15.0,),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(top: 10.0,),
                                        child: Text(body.orderId.toString(),
                                          style: TextStyle(fontWeight: FontWeight.w600),
                                        ),
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(left: 10.0, top: 10.0, right: 10.0),
                                        child: Image.asset("images/location.png",
                                        height: 15.0,),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(top: 10.0,),
                                        child: Text("Location",
                                          style: TextStyle(fontWeight: FontWeight.w400),
                                        ),
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(left: 10.0, top: 10.0, right: 10.0),
                                        child: Image.asset("images/bag.png",
                                        height: 15.0,),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(top: 10.0,),
                                        child: Text("Bag",
                                          style: TextStyle(fontWeight: FontWeight.w400),
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 10.0,),
                                  Row(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.all(10),
                                        padding: EdgeInsets.all(10),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                              color: CommonColors.buttonColor,
                                                width: 2.0),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.0)),
                                        ),
                                        child: Text("Set Order For Delivery",
                                        style: TextStyle(color: CommonColors.buttonColor,
                                         fontWeight: FontWeight.w600,
                                        ),),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Navigator.of(context).push(MaterialPageRoute(
                                              builder: (context) => EditDeliveryPage(body.orderId.toString(), body.amount.toString()))
                                          );
                                        },
                                        child: Container(
                                          width: 130,
                                          alignment: Alignment.center,
                                          padding: EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: CommonColors.buttonColor,
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(10.0)
                                            )
                                          ),
                                          child: Text("Edit Delivery",
                                           style: TextStyle(color: Colors.white,
                                             fontWeight: FontWeight.w600,
                                           ),),
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              )
                            ],
                          ),
                        )
                          )
                        );
                      }
                  ),
                  // SizedBox(height: 16.0),
                  // Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //     children: <Widget>[
                  //       Spacer(),
                  //       ElevatedButton(
                  //         child: Text('Set Order for Delivery'),
                  //         onPressed: () {},
                  //       ),
                  //       SizedBox(width: 10,),
                  //       ElevatedButton(
                  //         child: Text('Edit Delievery'),
                  //         onPressed: () {
                  //           Navigator.push(
                  //             context,
                  //             MaterialPageRoute(builder: (context) => EditDeliveryPage()),
                  //           );
                  //         },
                  //       ),
                  //       SizedBox(width: 10,),
                  //     ]
                  // ),
                ],
              ),
          ),
        ),
        ),
    );
  }
  BoxDecoration myBoxDecoration() {
    return BoxDecoration(
      border: Border.all(
        color: Colors.red, //                   <--- border color
        width: 5.0,
      ),
    );
  }
}

class OrderContainer extends StatelessWidget {
  final String orderId;
  final String orderName;
  final String location;
  final String assignedBy;

  OrderContainer({
    required this.orderId,
    required this.orderName,
    required this.location,
    required this.assignedBy,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order ID: $orderId',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.0),
          Text(
            'Order Name: $orderName',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.0),
          Text(
            'Location: $location',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.0),
          Text(
            'Assigned By: $assignedBy',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
