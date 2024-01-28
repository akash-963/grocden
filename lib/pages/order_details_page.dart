import 'package:flutter/material.dart';
import '../models/order_model.dart';

class OrderDetailsPage extends StatefulWidget {
  final MyOrder order;
  final String shop;

  const OrderDetailsPage({Key? key, required this.order, required this.shop}) : super(key: key);

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {


  @override
  Widget build(BuildContext context) {
    // getShopName();
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order Details:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text('Order ID: ${widget.order.id}'),
            Text('Shop: ${widget.shop}'),
            Text('Created Date: ${widget.order.createdTimestamp.toDate()}'),
            if (widget.order.deliveredTimestamp != null)
              Text('Delivered Date: ${widget.order.deliveredTimestamp!.toDate()}'),
            if (widget.order.cancelledTimestamp != null)
              Text('Cancelled Date: ${widget.order.cancelledTimestamp!.toDate()}'),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total Value: \₹${widget.order.totalValue}'),
                Text('Status: ${widget.order.status}'),
              ]
            ),
            SizedBox(height: 16),
            Text(
              'Ordered Products:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            for (ProductOrderDetails orderDetails in widget.order.products)
              ExpansionTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${orderDetails.productName.length > 20 ? orderDetails.productName.substring(0, 20) + '...' : orderDetails.productName}',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    Text('\₹${orderDetails.price}'),
                  ],
                ),
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Product: ${orderDetails.productName}'),
                      Text('Quantity: ${orderDetails.quantity}'),
                      Text('Price: \₹${orderDetails.price}'),
                    ],
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}