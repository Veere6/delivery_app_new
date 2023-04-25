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
            // padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
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
                SizedBox(height: 16.0),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Order ID: 12345',
                    style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),
                  ),
                ),

                SizedBox(height: 16.0),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Add Bag',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 16.0),
                      Container(
                        width: 60.0,
                        height: 60.0,
                        child: Icon(Icons.qr_code_2_rounded,size: 60,color:Colors.white)
                        // Image.asset('assets/qr_code.png'),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.0),
                Container(
                  // padding: EdgeInsets.symmetric(horizontal: ),

                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: DataTable(
                    columnSpacing:45,
                    columns: [
                      DataColumn(label: Text('Cash',style: TextStyle(color: Colors.black),)),
                      DataColumn(label: Text('Denomination',style: TextStyle(color: Colors.black))),
                      DataColumn(label: Text('Count',style: TextStyle(color: Colors.black))),
                      DataColumn(label: Text('Amount',style: TextStyle(color: Colors.black))),
                    ],
                    rows: _cashDetails.map((detail) {
                      return DataRow(
                        cells: [
                          DataCell(Text('')),
                          DataCell(Text('\$${detail['denomination']}',style: TextStyle(color: Colors.black54))),
                          DataCell(Text('${detail['count']}',style: TextStyle(color: Colors.black54))),
                          DataCell(Text('\$${detail['amount']}',style: TextStyle(color: Colors.black54))),
                        ],
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(height: 16.0),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Color(0xff3eaaf5)),
                      ),
                      onPressed: _addCashDetail,
                      child: Text('Add More'),
                    ),
                  ),
                ),

                SizedBox(height: 16.0),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10)
              ),
              padding: EdgeInsets.symmetric(horizontal: 16,vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                      color: Colors.black
                    ),
                  ),
                  Text(
                    '\$${calculateTotalAmount(_cashDetails).toInt()}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                        color: Colors.black
                    ),
                  ),
                ],
              ),
            ),
                SizedBox(height: 16.0),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Color(0xff3eaaf5)),
                      ),
                      onPressed: (){

                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => DeliveryViewPage(bagValue: "A1", totalValue: '\$${calculateTotalAmount(_cashDetails).toInt()}')),
                        );
                      },
                      child: Text('Next'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
