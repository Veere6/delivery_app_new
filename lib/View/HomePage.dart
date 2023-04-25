import 'package:delivery_app/CommonMethod/CommonColors.dart';
import 'package:delivery_app/View/EditDeliveryPage.dart';
import 'package:flutter/material.dart';


class HomePage extends StatefulWidget {
  @override
  _MyStatefulWidgetPageState createState() => _MyStatefulWidgetPageState();
}


class _MyStatefulWidgetPageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/
    final double itemHeight = (size.width / 1.5)+20;
    final double itemWidth = size.width / 1.5;
    return Scaffold(
      body: SafeArea(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[

              Container(
                padding: EdgeInsets.all(16.0),
                child:
                Text(
                  'Nifty',
                  style: TextStyle(
                    fontSize: 26.0,
                    letterSpacing: 5,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                // Image.asset('assets/logo.png'),
              ),
              SizedBox(height: 16.0),
              Container(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Todays Deliveries',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 0.0),
              GridView.builder(
                shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15.0,
                    mainAxisSpacing: 15.0,
                    childAspectRatio: (itemWidth / itemHeight),
                  ),
                  itemCount: 3,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemBuilder: (context, index){
                    return InkWell(
                      onTap: (){
                      },
                      child:OrderContainer(
                        orderId: '12345',
                        orderName: 'Sample Order',
                        location: 'New York',
                        assignedBy: 'John Doe',
                      )
                    );
                  }
              ),
              SizedBox(height: 16.0),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Spacer(),
                    ElevatedButton(
                      child: Text('Set Order for Delivery'),
                      onPressed: () {},
                    ),
                    SizedBox(width: 10,),
                    ElevatedButton(
                      child: Text('Edit Delievery'),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => EditDeliveryPage()),
                        );
                      },
                    ),
                    SizedBox(width: 10,),
                  ]
              ),
            ],
          ),
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
