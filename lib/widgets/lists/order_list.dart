import 'package:flutter/material.dart';

import '../../models/order_model.dart';
import '../tiles/order_tile.dart';

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
        return OrderTile(order: order);
      },
    );
  }
}