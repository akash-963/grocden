// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/order_model.dart';

class OrdersTab extends StatefulWidget {
  const OrdersTab({super.key});

  @override
  State<OrdersTab> createState() => _OrdersTabState();
}

class _OrdersTabState extends State<OrdersTab> {
  // List<MyOrder> orders = [];
  List<MyOrder> ongoingOrders = [];
  List<MyOrder> previousOrders = [];
  late String userId;

  Future<void> getdetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId')!;
    print(userId);
    getOrdersDetails();
  }

  // Inside _OrdersTabState
  void getOrdersDetails() async {
    try {
      List<String> orderIds = await fetchOrderIdsForUser(userId);
      List<MyOrder> orders = await fetchOrdersDetails(orderIds);

      // Now you can use the 'orders' list as needed
      setState(() {
        ongoingOrders = orders.where((order) => order.status == "ongoing").toList();
        previousOrders = orders.where((order) => order.status == "previous").toList();
      });
    } catch (e) {
      print('Error fetching orders: $e');
    }
  }



  // Fetch order IDs from user collection
  Future<List<String>> fetchOrderIdsForUser(String userId) async {
    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('userCollection')
          .doc(userId)
          .get();

      if (userSnapshot.exists) {
        List<dynamic> orderIds = userSnapshot['OrdersHistory'];
        print(orderIds);
        return List<String>.from(orderIds);
      }

      return [];
    } catch (e) {
      print('Error fetching order IDs: $e');
      return [];
    }
  }



  // Fetch details for each order from orders collection
  Future<List<MyOrder>> fetchOrdersDetails(List<String> orderIds) async {
    List<MyOrder> orders = [];

    for (String orderId in orderIds) {
      try {
        DocumentSnapshot orderSnapshot = await FirebaseFirestore.instance
            .collection('ordersCollection')
            .doc(orderId)
            .get();

        if (orderSnapshot.exists) {
          List<ProductOrderDetails> products = await fetchProductsForOrder(orderId);

          MyOrder order = MyOrder(
            shop: orderSnapshot['shop'],
            buyer: orderSnapshot['buyer'],
            totalValue: orderSnapshot['totalValue'],
            createdTimestamp: orderSnapshot['createdTimestamp'],
            deliveredTimestamp: orderSnapshot['deliveredTimestamp'],
            cancelledTimestamp: orderSnapshot['cancelledTimestamp'],
            tag: orderSnapshot['tag'],
            status: orderSnapshot['status'],
            products: products,
          );

          orders.add(order);
        }
      } catch (e) {
        print('Error fetching order details: $e');
      }
    }

    print(orders);
    return orders;
  }

  Future<List<ProductOrderDetails>> fetchProductsForOrder(String orderId) async {
    try {
      QuerySnapshot productSnapshot = await FirebaseFirestore.instance
          .collection('ordersCollection') // Assuming the products collection is under the ordersCollection
          .doc(orderId)
          .collection('products')
          .get();

      return productSnapshot.docs.map((productDoc) {
        return ProductOrderDetails(
          productId: productDoc.id,
          productName: productDoc['productName'],
          quantity: productDoc['quantity'],
          price: productDoc['price'],
        );
      }).toList();
    } catch (e) {
      print('Error fetching products for order: $e');
      return [];
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdetails();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            tabs: [
              Tab(text: "Ongoing"),
              Tab(text: "Previous"),
            ],
          ),
          title: const Text('Orders'),

        ),
        body: TabBarView(
          children: [
            OrderList(orders: ongoingOrders),
            Container(child: SingleChildScrollView(child: OrderList(orders: previousOrders))),
          ],
        ),
      )
    );
  }
}






// class OrderList extends StatelessWidget {
//   final List<MyOrder> orders;
//
//   OrderList({required this.orders});
//
//   @override
//   Widget build(BuildContext context) {
//     var ordersOngoing;
//     return ListView.builder(
//       shrinkWrap: true,
//       itemCount: ordersOngoing.length,
//       itemBuilder: (context, index) {
//         final order = ordersOngoing[index];
//
//         return InkWell(
//           onTap: () => Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => OrderDetailsPage(order: order),
//             ),
//           ),
//           child: OrderTile(order: order,),
//         );
//       },
//     );
//   }
// }


class OrderList extends StatelessWidget {
  final List<MyOrder> orders;

  OrderList({required this.orders});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OrderDetailsPage(order: order),
            ),
          ),
          child: OrderTile(order: order),
        );
      },
    );
  }
}


class OrderDetailsPage extends StatelessWidget {
  final MyOrder order;
  const OrderDetailsPage({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

// class OrderTile extends StatelessWidget {
//   final MyOrder order;
//   const OrderTile({super.key, required this.order});
//
//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
// }



class OrderTile extends StatelessWidget {
  final MyOrder order;

  const OrderTile({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: ListTile(
        title: Text('Order ID: '),
        //${order.orderId}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Shop: ${order.shop}'),
            Text('Buyer: ${order.buyer}'),
            Text('Total Value: ${order.totalValue}'),
            Text('Status: ${order.status}'),
            Text('Created Date: ${order.createdTimestamp.toDate()}'),
            if (order.deliveredTimestamp != null)
              Text('Delivered Date: ${order.deliveredTimestamp!.toDate()}'),
            if (order.cancelledTimestamp != null)
              Text('Cancelled Date: ${order.cancelledTimestamp!.toDate()}'),
            // Display other order details as needed
          ],
        ),
        onTap: () {
          // Handle the tap event, e.g., navigate to a detailed order view
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OrderDetailsPage(order: order),
            ),
          );
        },
      ),
    );
  }
}





// class OrderHistoryPage extends StatefulWidget {
//   @override
//   _OrderHistoryPageState createState() => _OrderHistoryPageState();
// }
//
// class _OrderHistoryPageState extends State<OrderHistoryPage> {
//   late String userId; // Replace with the actual user ID
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Order History'),
//       ),
//       body: FutureBuilder(
//         future: _fetchOrderIds(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return CircularProgressIndicator(); // Loading indicator while fetching data
//           }
//
//           if (snapshot.hasError) {
//             return Text('Error: ${snapshot.error}');
//           }
//
//           List<String> orderIds = snapshot.data as List<String>;
//
//           if (orderIds.isEmpty) {
//             return Center(child: Text('No orders found.'));
//           }
//
//           return ListView.builder(
//             itemCount: orderIds.length,
//             itemBuilder: (context, index) {
//               return FutureBuilder(
//                 future: _fetchOrderDetails(orderIds[index]),
//                 builder: (context, orderSnapshot) {
//                   if (orderSnapshot.connectionState == ConnectionState.waiting) {
//                     return CircularProgressIndicator(); // Loading indicator while fetching data
//                   }
//
//                   if (orderSnapshot.hasError) {
//                     return Text('Error: ${orderSnapshot.error}');
//                   }
//
//                   Map<String, dynamic> orderDetails = orderSnapshot.data as Map<String, dynamic>;
//
//                   // Build and return the order tile widget
//                   return OrderTile(order: order);
//                 },
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
//
//
//
//   Future<List<String>> _fetchOrderIds() async {
//     try {
//       DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
//           .collection('userCollection')
//           .doc(userId)
//           .get();
//
//       if (userSnapshot.exists) {
//         List<dynamic> orderIds = userSnapshot['OrdersHistory'];
//         return List<String>.from(orderIds);
//       }
//
//       return [];
//     } catch (e) {
//       print('Error fetching order IDs: $e');
//       return [];
//     }
//   }
//
//   Future<Map<String, dynamic>> _fetchOrderDetails(String orderId) async {
//     try {
//       DocumentSnapshot orderSnapshot = await FirebaseFirestore.instance
//           .collection('ordersCollection')
//           .doc(orderId)
//           .get();
//
//       if (orderSnapshot.exists) {
//         return orderSnapshot.data() as Map<String, dynamic>;
//       }
//
//       return {};
//     } catch (e) {
//       print('Error fetching order details: $e');
//       return {};
//     }
//   }
// }
//
// class OrderTile extends StatelessWidget {
//   final MyOrder order;
//
//   const OrderTile({Key? key, required this.order}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     // Extract order details
//     String orderId = order['orderId'];
//     String shopId = order['shopId'];
//     String status = order['status'];
//     double totalValue = order['totalValue'];
//     String orderedDate = order['orderedDate'];
//     String deliveredDate = order['deliveredDate'];
//     String canceledDate = order['canceledDate'];
//
//     return ListTile(
//       title: Text('Order ID: $orderId'),
//       subtitle: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text('Shop ID: $shopId'),
//           Text('Status: $status'),
//           Text('Total Value: $totalValue'),
//           Text('Ordered Date: $orderedDate'),
//           if (deliveredDate != null) Text('Delivered Date: $deliveredDate'),
//           if (canceledDate != null) Text('Canceled Date: $canceledDate'),
//         ],
//       ),
//     );
//   }
// }