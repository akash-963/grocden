import 'package:flutter/material.dart';
import 'package:grocden/models/product_model.dart';
import '../../utils/grid_delegate.dart';
import '../tiles/product_tile.dart';
//import 'product_details_page.dart';

class ProductList extends StatelessWidget {
  final List<Product> products;

  ProductList({required this.products});

  // @override
  // Widget build(BuildContext context) {
  //   return ListView.builder(
  //     shrinkWrap: true,
  //     itemCount: products.length,
  //     itemBuilder: (context, index) {
  //       final product = products[index];
  //
  //       return InkWell(
  //         onTap: () => Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //             builder: (context) => ProductDetailsPage(product: product),
  //           ),
  //         ),
  //         child: ProductTile(product: product),
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight(
          crossAxisCount: 2,
          crossAxisSpacing: 5,
          mainAxisSpacing: 5,
          height: MediaQuery.of(context).copyWith().size.height / 3.4,
        ),
        shrinkWrap: true,
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index%products.length];
          return InkWell(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductDetailsPage(product: product),
              ),
            ),
            child: ProductTile(product: product),
          );
        },
    );
  }
}

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
