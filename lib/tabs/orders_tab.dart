// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/order_model.dart';
import '../widgets/lists/order_list.dart';

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


  // fetch userId of user
  Future<void> getdetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId') ?? '';
    print(userId);
    getOrdersDetails();
  }


  // seperate the previous and ongoing orders
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
            id: orderId,
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


  // fetch products from order
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