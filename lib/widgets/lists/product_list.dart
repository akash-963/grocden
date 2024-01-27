// import 'package:flutter/material.dart';
// import 'package:grocden/models/product_model.dart';
// import '../tiles/product_tile.dart';
//
//
// class ProductList extends StatelessWidget{
//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       shrinkWrap: true,
//       itemCount: ProductModel.products.length,
//       itemBuilder: (context,index){
//         final product = ProductModel.products[index];
//
//         return InkWell(
//             onTap: () => Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                     builder: (context)=>
//                         ProductDetailsPage()
//                 )
//             ),
//             child: ProductTile(product:  product));
//       },
//     );
//   }
// }
//
// class ProductDetailsPage extends StatefulWidget {
//   const ProductDetailsPage({super.key});
//
//   @override
//   State<ProductDetailsPage> createState() => _ProductDetailsPageState();
// }
//
// class _ProductDetailsPageState extends State<ProductDetailsPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Text('Product Details Page'),
//       ),
//     );
//   }
// }





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
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          height: 250,
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
