// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../models/order_model.dart';
// import 'cart_page.dart';
//
// class OrderSummaryPage extends StatefulWidget {
//   final OrderSummary orderSummary;
//   OrderSummaryPage({required this.orderSummary});
//
//   @override
//   State<OrderSummaryPage> createState() => _OrderSummaryPageState();
// }
//
// class _OrderSummaryPageState extends State<OrderSummaryPage> {
//   late String shopId,userId,bName,bAddress;
//
//   // get user and shop if from shared pref
//   Future<void> getUserAndShopId() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     userId = prefs.getString('userId')!;
//     shopId = prefs.getString('selectedShopId')!;
//   }
//
//   // get user name and address from firestore document
//   Future<void> getUserDetails() async {
//     try {
//       DocumentSnapshot snapshot = await FirebaseFirestore.instance
//           .doc("userCollection/${userId}")
//           .get();
//
//       if (snapshot.exists) {
//         Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
//
//         // Retrieve the values from the document and assign them to variables
//         String bName = data['name'] ?? ''; // Default value if 'bName' is not present
//         String address = data['address'] ?? ''; // Default value if 'address' is not present
//
//         // Now you can use bName and address variables
//         print('Business Name: $bName');
//         print('Address: $address');
//       } else {
//         print('Document does not exist');
//       }
//     } catch (e) {
//       print('Error fetching user details: $e');
//     }
//   }
//
//   @override
//   void initState(){
//     super.initState();
//     getUserAndShopId();
//     getUserDetails();
//   }
//
//   Future<void> _placeOrder(BuildContext context) async {
//     getUserDetails();
//     getUserAndShopId();
//     try {
//       // Create an Order object
//       MyOrder order = MyOrder(
//         id: '',
//         shop: shopId,
//         buyer: userId,
//         bName: bName,
//         bAddress: bAddress,
//         totalValue: widget.orderSummary.totalCartValue,
//         createdTimestamp: Timestamp.now(),
//         deliveredTimestamp: null,
//         cancelledTimestamp: null,
//         products: widget.orderSummary.orderDetailsList
//             .map(
//               (orderDetails) => ProductOrderDetails(
//             productName: orderDetails.productName,
//             quantity: orderDetails.quantity,
//             price: orderDetails.price,
//             productId: orderDetails.productId,
//           ),
//         )
//             .toList(),
//       );
//
//       // Store the order details in Firestore
//       DocumentReference orderRef =
//       await FirebaseFirestore.instance.collection('ordersCollection').add({
//         'shop': order.shop,
//         'buyer': order.buyer,
//         'totalValue': order.totalValue,
//         'createdTimestamp': order.createdTimestamp,
//         'deliveredTimestamp': null,
//         'cancelledTimestamp': null,
//         'tag': "undelivered",
//         'status': "ongoing",
//       });
//
//       // Store the product details inside the 'products' subcollection
//       CollectionReference productsCollectionRef = orderRef.collection('products');
//       for (ProductOrderDetails productDetails in order.products) {
//         await productsCollectionRef.doc(productDetails.productId).set({
//           'productName': productDetails.productName,
//           'quantity': productDetails.quantity,
//           'price': productDetails.price,
//         });
//       }
//
//       String orderId = orderRef.id;
//       await FirebaseFirestore.instance.doc('userCollection/${userId}/').update({
//         'OrdersHistory': FieldValue.arrayUnion([orderId]),
//       });
//
//       deleteCartItems();
//
//       // Navigate back to the previous screen
//       Navigator.pop(context);
//
//     } catch (e) {
//       print('Error placing order: $e');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Order Summary'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Order Details:',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             for (OrderDetails orderDetails in widget.orderSummary.orderDetailsList)
//               ExpansionTile(
//                 title: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       '${orderDetails.productName.length > 20 ? orderDetails.productName.substring(0, 20) + '...' : orderDetails.productName}',
//                       style: TextStyle(fontSize: 16.0,),
//                     ),
//                     Text('\₹${orderDetails.value}'),
//                   ]
//                 ),
//                 // subtitle: Text('Price: \$${orderDetails.value}'),
//                 children: [
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text('Product: ${orderDetails.productName}'),
//                       Text('Quantity: ${orderDetails.quantity}'),
//                       Text('Value: \₹${orderDetails.value}'),
//                     ],
//                   ),
//                 ],
//               ),
//
//             SizedBox(height: 16),
//             Spacer(),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                   Text(
//                     'Total Cart Value: \₹${widget.orderSummary.totalCartValue}',
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                   ElevatedButton(
//                   onPressed: () {
//                     _placeOrder(context);
//                   },
//                   child: Text('Buy Now'),
//                 ),
//               ]
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//
//   // delete all cart items and then collection itself
//   Future<void> deleteCartItems() async {
//     CollectionReference cartItemsCollection =
//     FirebaseFirestore.instance.collection('userCollection/$userId/cart_items');
//
//     QuerySnapshot cartItemsSnapshot = await cartItemsCollection.get();
//
//     for (QueryDocumentSnapshot document in cartItemsSnapshot.docs) {
//       await cartItemsCollection.doc(document.id).delete();
//     }
//
//     // After deleting all documents, delete the collection itself
//     await cartItemsCollection.doc().delete();
//   }
// }





import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grocden/pages/home_page.dart';
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
  late String shopId, userId;
  String? bName, bAddress;

  // get user and shop id from shared preferences
  Future<void> getUserAndShopId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId')!;
    shopId = prefs.getString('selectedShopId')!;
  }

  // get user name and address from firestore document
  Future<void> getUserDetails() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .doc("userCollection/$userId")
          .get();

      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

        setState(() {
          bName = data['name'] ?? ''; // Default value if 'name' is not present
          bAddress = data['address'] ?? ''; // Default value if 'address' is not present
        });

        print('Business Name: $bName');
        print('Address: $bAddress');
      } else {
        print('Document does not exist');
      }
    } catch (e) {
      print('Error fetching user details: $e');
    }
  }

  @override
  void initState(){
    super.initState();
    getUserAndShopId().then((_) {
      getUserDetails();
    });
  }

  Future<void> _placeOrder(BuildContext context) async {
    await getUserDetails();
    await getUserAndShopId();

    if (bName == null || bAddress == null) {
      print('User details not available');
      return;
    }

    try {
      // Create an Order object
      MyOrder order = MyOrder(
        id: '',
        shop: shopId,
        buyer: userId,
        bName: bName!,
        bAddress: bAddress!,
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
        'bName': order.bName,
        'bAddress': order.bAddress,
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
      await FirebaseFirestore.instance.doc('userCollection/$userId').update({
        'OrdersHistory': FieldValue.arrayUnion([orderId]),
      });

      deleteCartItems();

      showToast();
      await Future.delayed(Duration(seconds: 3));
      // Navigate back to the previous screen
      Navigator.pop(context, '/cart');
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
              ExpansionTile(
                title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${orderDetails.productName.length > 20 ? orderDetails.productName.substring(0, 20) + '...' : orderDetails.productName}',
                        style: TextStyle(fontSize: 16.0,),
                      ),
                      Text('\₹${orderDetails.value}'),
                    ]
                ),
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Product: ${orderDetails.productName}'),
                      Text('Quantity: ${orderDetails.quantity}'),
                      Text('Value: \₹${orderDetails.value}'),
                    ],
                  ),
                ],
              ),

            SizedBox(height: 16),
            Spacer(),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Cart Value: \₹${widget.orderSummary.totalCartValue}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _placeOrder(context);
                    },
                    child: Text('Buy Now'),
                  ),
                ]
            ),
          ],
        ),
      ),
    );
  }

  // delete all cart items and then collection itself
  Future<void> deleteCartItems() async {
    CollectionReference cartItemsCollection =
    FirebaseFirestore.instance.collection('userCollection/$userId/cart_items');

    QuerySnapshot cartItemsSnapshot = await cartItemsCollection.get();

    for (QueryDocumentSnapshot document in cartItemsSnapshot.docs) {
      await cartItemsCollection.doc(document.id).delete();
    }

    // After deleting all documents, delete the collection itself
    await cartItemsCollection.doc().delete();
  }

  void showToast() {
    Fluttertoast.showToast(
      msg: 'Order placed successfully',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0,

    );
  }
}
