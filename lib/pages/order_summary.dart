import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/order_model.dart';
import 'cart_page.dart';

class OrderSummaryPage extends StatefulWidget {
  final OrderSummary orderSummary;
  OrderSummaryPage({required this.orderSummary});

  @override
  State<OrderSummaryPage> createState() => _OrderSummaryPageState();
}

class _OrderSummaryPageState extends State<OrderSummaryPage> {
  late String shopId,userId;


  Future<void> getUserAndShopId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId')!;
    shopId = prefs.getString('selectedShopId')!;
  }


  @override
  void initState(){
    super.initState();
    getUserAndShopId();
  }

  Future<void> _placeOrder(BuildContext context) async {
    try {
      // Create an Order object
      MyOrder order = MyOrder(
        shop: shopId,
        buyer: userId,
        totalValue: widget.orderSummary.totalCartValue,
        createdTimestamp: Timestamp.now(),
        deliveredTimestamp: null,
        cancelledTimestamp: null,
        products: widget.orderSummary.orderDetailsList
            .map(
              (orderDetails) => ProductOrderDetails(
            productName: orderDetails.productName,
            quantity: orderDetails.quantity,
            price: orderDetails.price,
            productId: orderDetails.productId,
          ),
        )
            .toList(),
      );

      // Store the order details in Firestore
      DocumentReference orderRef =
      await FirebaseFirestore.instance.collection('ordersCollection').add({
        'shop': order.shop,
        'buyer': order.buyer,
        'totalValue': order.totalValue,
        'createdTimestamp': order.createdTimestamp,
        'deliveredTimestamp': null,
        'cancelledTimestamp': null,
        'tag': "undelivered",
        'status': "ongoing",
      });

      // Store the product details inside the 'products' subcollection
      CollectionReference productsCollectionRef = orderRef.collection('products');
      for (ProductOrderDetails productDetails in order.products) {
        await productsCollectionRef.doc(productDetails.productId).set({
          'productName': productDetails.productName,
          'quantity': productDetails.quantity,
          'price': productDetails.price,
        });
      }

      String orderId = orderRef.id;
      await FirebaseFirestore.instance.doc('userCollection/${userId}/').update({
        'OrdersHistory': FieldValue.arrayUnion([orderId]),
      });



      // Navigate back to the previous screen
      Navigator.pop(context);

    } catch (e) {
      print('Error placing order: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Summary'),
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
            for (OrderDetails orderDetails in widget.orderSummary.orderDetailsList)
              ListTile(
                title: Text('Product: ${orderDetails.productName}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Quantity: ${orderDetails.quantity}'),
                    Text('Price: \$${orderDetails.price}'),
                    Text('Value: \$${orderDetails.value}'),
                  ],
                ),
              ),
            SizedBox(height: 16),
            Text(
              'Total Cart Value: \$${widget.orderSummary.totalCartValue}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                // Implement your logic to proceed with the order here
                // For now, we'll just pop the current page
                _placeOrder(context);
              },
              child: Text('Buy Now'),
            ),
          ],
        ),
      ),
    );
  }
}
