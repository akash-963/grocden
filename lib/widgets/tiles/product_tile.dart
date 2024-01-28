import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grocden/widgets/product_image.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../models/product_model.dart';
import '../cart_button.dart';
import '../shop_image.dart';


class OrderDetails {
  final String productName;
  final int quantity;
  final double price;
  final double value;

  OrderDetails({
    required this.productName,
    required this.quantity,
    required this.price,
    required this.value,
  });
}

class OrderSummary {
  final List<OrderDetails> orderDetailsList;
  final double totalCartValue;

  OrderSummary({
    required this.orderDetailsList,
    required this.totalCartValue,
  });
}



class ProductTile extends StatelessWidget {
  final Product product;

  const ProductTile({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(10),
      ),
      height: 300,
      child: Column(
        children: [
          Hero(
            tag: Key(product.id.toString()),
            child: ProductImage(image: product.image), // Display the first image if available
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  product.name.text.lg.ellipsis.color(context.accentColor).bold.make(),
                  product.desc.text.maxLines(2).ellipsis.make(),
                  SizedBox(height: 5,),
                  ButtonBar(
                    alignment: MainAxisAlignment.spaceBetween,
                    buttonPadding: EdgeInsets.zero,
                    children: [
                      "\₹${product.price}".text.xl.bold.make(),
                      AddToCart(product: product),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}