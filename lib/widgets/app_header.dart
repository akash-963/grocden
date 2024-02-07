import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class AppHeader extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      padding: Vx.m8,
      child: Row(
        children:[
          CircleAvatar(
            backgroundImage: AssetImage('assets/images/logo.png',),
            radius: 40,
            backgroundColor: Colors.transparent,
          ),
          SizedBox(width: 10,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              "Grocden.Com".text.size(screenWidth * 0.08).bold.color(Color(0xff285430)).make(),
              5.heightBox,
              "Groceries at your doorstep".text.size(screenWidth * 0.05).make(),
            ],
          ),
        ]
      ),
    );
  }
}