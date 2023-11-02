import 'package:flutter/material.dart';

import '../models/order_model.dart';

class OrdersTab extends StatelessWidget {
  const OrdersTab({super.key});

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
        body: const TabBarView(
          children: [
            Icon(Icons.directions_car),
            Icon(Icons.directions_transit),
          ],
        ),
      )
    );
  }
}


class OrderList extends StatelessWidget {
  final List<Order> orders;

  OrderList({required this.orders});

  @override
  Widget build(BuildContext context) {
    var ordersOngoing;
    return ListView.builder(
      shrinkWrap: true,
      itemCount: ordersOngoing.length,
      itemBuilder: (context, index) {
        final order = ordersOngoing[index];

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
  final Order order;
  const OrderDetailsPage({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class OrderTile extends StatelessWidget {
  final Order order;
  const OrderTile({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}


