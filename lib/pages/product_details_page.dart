import 'package:flutter/material.dart';

import '../models/product_model.dart';

class ProductDetailsPage extends StatelessWidget {
  final Product product;

  ProductDetailsPage({required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Text('Product Details Page'),
        ),
      ),
    );
  }
}