import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class AppHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: Vx.m8,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          "Grocden.Com".text.xl5.bold.color(Color(0xff285430)).make(),
          5.heightBox,
          "Products We Currently Offer".text.xl2.make(),
        ],
      ),
    );
  }
}