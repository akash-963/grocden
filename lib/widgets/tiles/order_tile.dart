import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../models/order_model.dart';
import '../../pages/order_details_page.dart';


class OrderTile extends StatefulWidget {
  final MyOrder order;

  const OrderTile({Key? key, required this.order}) : super(key: key);

  @override
  State<OrderTile> createState() => _OrderTileState();
}

class _OrderTileState extends State<OrderTile> {
  late String shopName;


  // Get Shop Name to pass as parameter
  Future<void> getShopName() async {
    DocumentSnapshot shopSnapshot =
    await FirebaseFirestore.instance.collection('shopCollection').doc(widget.order.shop).get();

    // Access the 'name' field from the shop document
    shopName =  shopSnapshot['name'];
    // print(shopName);
  }


  @override
  void initState() {
    super.initState();
    getShopName();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(4.0),
      child: Padding(
        padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
        child: ListTile(
          leading: Image.asset("assets/images/17727433.jpg"),
          title: Text('Order ID: ${widget.order.id}'),
          //${order.orderId}'),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Date : ${widget.order.createdTimestamp.toDate()}"),
              SizedBox(height: 10,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total Value: \₹ ${widget.order.totalValue}'),
                  Text('Status: ${widget.order.status}'),
                ],
              ),
            ]
          ),
          onTap: () {
            // Handle the tap event, e.g., navigate to a detailed order view
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OrderDetailsPage(order: widget.order, shop: shopName),
              ),
            );
          },
        ),
      ),
    );
  }
}