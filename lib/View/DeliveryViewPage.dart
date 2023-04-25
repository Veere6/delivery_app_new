import 'package:delivery_app/CommonMethod/CommonColors.dart';
import 'package:flutter/material.dart';

class DeliveryViewPage extends StatelessWidget {
  final String bagValue;
  final String totalValue;

  DeliveryViewPage({required this.bagValue, required this.totalValue});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: SafeArea(
        child: Container(

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back,color: Colors.white,),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Nifty',
                      style: TextStyle(
                        fontSize: 26.0,
                        letterSpacing: 5,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.0),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Edit Delivery',
                  style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                  ),
                ),
              ),
              SizedBox(height: 20),

              new Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)
                ),
                padding: EdgeInsets.symmetric(vertical: 16,),

                margin: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [

                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Bag:',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color:CommonColors.black),
                          ),
                          SizedBox(width: 50),
                          Text(
                            bagValue,
                            style: TextStyle(fontSize: 16, color:CommonColors.black),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total:',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color:CommonColors.black),
                          ),
                          SizedBox(width: 50),
                          Text(
                            '$totalValue',
                            style: TextStyle(fontSize: 16, color:CommonColors.black),

                          ),

                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Summary:',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color:CommonColors.black),
                          ),
                          SizedBox(width: 50),
                          Text(
                            '20 bags',
                            style: TextStyle(fontSize: 16, color:CommonColors.black),

                          ),

                        ],
                      ),
                    ),
                    SizedBox(height: 40),
                    Container(

                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'User image',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color:CommonColors.black),
                          ),
                          SizedBox(width: 20),
                          Image.network(
                            "https://images.pexels.com/photos/771742/pexels-photo-771742.jpeg?auto=compress&cs=tinysrgb&w=600",
                            height: 100,
                            width: 150,
                            fit: BoxFit.cover,
                          ),

                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Location:',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color:CommonColors.black),
                          ),
                          SizedBox(width: 50),
                          Text(
                            'India',
                            style: TextStyle(fontSize: 16, color:CommonColors.black),

                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Datetime:',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color:CommonColors.black),
                          ),
                          SizedBox(width: 50),
                          Text(
                            '23/09/1995 12:12 PM',
                            style: TextStyle(fontSize: 16, color:CommonColors.black),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Cash Box:',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color:CommonColors.black),
                          ),
                          SizedBox(width: 50),
                          Text(
                            '#12345555',
                            style: TextStyle(fontSize: 16, color:CommonColors.black),

                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 50),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Color(0xff3eaaf5)),
                        ),
                        child: Text('Submit'),
                        onPressed: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(builder: (context) => EditDeliveryPage()),
                          // );
                        },
                      ),
                    ),
                  ],
                ),
              ),



            ],
          ),
        )
      ),
    );
  }
}
