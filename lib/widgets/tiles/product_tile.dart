// import 'package:flutter/material.dart';
// import 'package:velocity_x/velocity_x.dart';
//
// import '../../models/product_model.dart';
// import '../shop_image.dart';
//
//
// class ProductTile extends StatelessWidget{
//   final Product product;
//   const ProductTile({super.key, required this.product});
//
//   @override
//   Widget build(BuildContext context) {
//     return VxBox(
//         child: Row(
//           children: [
//             Hero(
//                 tag: Key(product.id.toString()),
//                 child: ShopImage(image: product.image)),
//             Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     product.name.text.lg.color(context.accentColor).bold.make(),
//                     product.desc.text.make(),
//                     10.heightBox,
//                     ButtonBar(
//                         alignment: MainAxisAlignment.spaceBetween,
//                         buttonPadding: EdgeInsets.zero,
//                         children: [
//                           "\$${product.price}".text.xl.bold.make(),
//                           _AddToCart(product: product)
//                         ]
//                     ).pOnly(right: 16)
//                   ],
//                 )
//             )
//           ],
//         )
//
//     ).color(context.cardColor).roundedLg.square(130).make().py8();
//   }
//
// }



// import 'package:flutter/material.dart';
// import 'package:velocity_x/velocity_x.dart';
//
// import '../../models/product_model.dart';
// import '../shop_image.dart';
//
//
// class ProductTile extends StatelessWidget{
//   final Product product;
//   const ProductTile({super.key, required this.product});
//
//   @override
//   Widget build(BuildContext context) {
//     return VxBox(
//         child: Column(
//           children: [
//             Hero(
//                 tag: Key(product.id.toString()),
//                 child: ShopImage(image: product.image)),
//             Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     product.name.text.lg.ellipsis.color(context.accentColor).bold.make(),
//                     product.desc.text.ellipsis.make(),
//                     // 10.heightBox,
//                     ButtonBar(
//                         alignment: MainAxisAlignment.spaceBetween,
//                         buttonPadding: EdgeInsets.zero,
//                         children: [
//                           "\₹${product.price}".text.xl.bold.make(),
//                           _AddToCart(product: product)
//                         ]
//                     )
//                     //.pOnly(right: 4)
//                   ],
//                 )
//             ).pOnly(left: 8,right: 8)
//           ],
//         )
//
//     ).color(context.cardColor).rounded.height(250).make();
//   }
//
// }






import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
            child: ShopImage(image: product.image), // Display the first image if available
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



// class _AddToCart extends StatefulWidget {
//   final Product product;
//
//   const _AddToCart({
//     super.key, required this.product,
//   });
//
//   @override
//   State<_AddToCart> createState() => _AddToCartState();
// }



//
// class _AddToCartState extends State<_AddToCart> {
//   bool isAdded = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 100,
//       height: 30,
//       decoration: ShapeDecoration(
//         color: Color(0xff403b58),
//         shape: StadiumBorder()
//       ),
//       child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: [
//           InkWell(
//               onTap: () {
//                 final _catalog = ProductModel();
//                 //final _cart = CartModel();
//                 //_cart.catalog = _catalog;
//                 isAdded = isAdded.toggle();
//                 //_cart.add(widget.catalog);
//                 setState(() {
//
//                 });
//               },
//               //child: isAdded ? Icon(Icons.done) :"Add to Cart".text.make()
//               child: Icon(Icons.remove,color: Colors.white,)
//           ),
//           Container(
//             width: 1.2, // Width of the separator line
//             color: Colors.white,
//           ),
//           Text(" 1 ", style: TextStyle(color: Colors.white),),
//           Container(
//             width: 1.2, // Width of the separator line
//             color: Colors.white,
//           ),
//           InkWell(
//               onTap: () {
//                 final _catalog = ProductModel();
//                 //final _cart = CartModel();
//                 //_cart.catalog = _catalog;
//                 isAdded = isAdded.toggle();
//                 //_cart.add(widget.catalog);
//                 setState(() {
//
//                 });
//               },
//               //child: isAdded ? Icon(Icons.done) :"Add to Cart".text.make()
//               child: Icon(Icons.add,color: Colors.white,)
//           ),
//         ]
//       ),
//     );
//   }
// }





// class _AddToCartState extends State<_AddToCart> {
//   int quantity = 1;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 100,
//       height: 30,
//       decoration: ShapeDecoration(
//         color: Color(0xff403b58),
//         shape: StadiumBorder(),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: [
//           InkWell(
//             onTap: () {
//               if (quantity > 0) {
//                 setState(() {
//                   quantity--;
//                 });
//               }
//             },
//             child: Icon(Icons.remove, color: Colors.white),
//           ),
//           Container(
//             width: 1.2,
//             color: Colors.white,
//           ),
//           Text(
//             "$quantity",
//             style: TextStyle(color: Colors.white),
//           ),
//           Container(
//             width: 1.2,
//             color: Colors.white,
//           ),
//           InkWell(
//             onTap: () {
//               setState(() {
//                 quantity++;
//               });
//             },
//             child: Icon(Icons.add, color: Colors.white),
//           ),
//         ],
//       ),
//     );
//   }
// }


// class _AddToCart extends StatefulWidget {
//   final Product product;
//
//   const _AddToCart({Key? key, required this.product}) : super(key: key);
//
//   @override
//   State<_AddToCart> createState() => _AddToCartState();
// }
//
// class _AddToCartState extends State<_AddToCart> {
//   String userId = FirebaseAuth.instance.currentUser!.uid;
//   bool isInCart = false;
//   // Default quantity
//   int quantity = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     checkCart();
//   }
//
//
//
//
//
//
//   void checkCart() async {
//     // Check if the product is in the cart
//     DocumentSnapshot cartItemSnapshot = await FirebaseFirestore.instance
//         .collection('userCollection')
//         .doc(userId)
//         .collection('cart_items')
//         .doc(widget.product.id)
//         .get();
//
//     if (cartItemSnapshot.exists) {
//       setState(() {
//         isInCart = true;
//         quantity = cartItemSnapshot['quantity'];
//       });
//     }
//   }
//
//   void deleteFromCart() async {
//     // Delete the product from the cart_items collection
//     await FirebaseFirestore.instance
//         .collection('userCollection')
//         .doc(userId)
//         .collection('cart_items')
//         .doc(widget.product.id)
//         .delete();
//
//     // Reset the state to update the UI
//     setState(() {
//       isInCart = false;
//       quantity = 0;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 100,
//       height: 30,
//       decoration: ShapeDecoration(
//         color: Color(0xff403b58),
//         shape: StadiumBorder(),
//       ),
//       child: isInCart
//           ? Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: [
//           InkWell(
//             onTap: () {
//               if (quantity > 1) {
//                 setState(() {
//                   quantity--;
//                 });
//                 updateQuantityInCart();
//               } else {
//                 deleteFromCart();
//               }
//             },
//             child: Icon(Icons.remove, color: Colors.white),
//           ),
//           Container(
//             width: 1.2,
//             color: Colors.white,
//           ),
//           Text(
//             " $quantity ",
//             style: TextStyle(color: Colors.white),
//           ),
//           Container(
//             width: 1.2,
//             color: Colors.white,
//           ),
//           InkWell(
//             onTap: () {
//               setState(() {
//                 quantity++;
//               });
//               updateQuantityInCart();
//             },
//             child: Icon(Icons.add, color: Colors.white),
//           ),
//         ],
//       )
//           : InkWell(
//         onTap: () {
//           setState(() {
//             isInCart = true;
//             quantity = 1;
//           });
//           addToCart();
//         },
//         child: Icon(Icons.add, color: Colors.white),
//       ),
//     );
//   }
//
//   // Function to add the product to the cart
//   void addToCart() {
//     String shopId = "Q9YnD1G1TshBDnbumiKEgqDiukG2";
//     num quantity = 1;
//     print(widget.product.quantity);
//     print(widget.product.price);
//     FirebaseFirestore.instance
//         .collection('userCollection')
//         .doc(userId)
//         .collection('cart_items')
//         .doc(widget.product.id)
//         .set({
//       'quantity': quantity,
//       'shopId': shopId,
//       'price': widget.product.price*quantity,
//       'name': widget.product.name,
//     });
//     //print(widget.product.shopId);
//
//   }
//
//   // Function to update the quantity in the cart
//   void updateQuantityInCart() {
//     // You should replace 'userId' with the actual user ID
//     String userId = "lK0DVuhU1wgSBAx6NLNlOfT3v3o2";
//     FirebaseFirestore.instance
//         .collection('userCollection')
//         .doc(userId)
//         .collection('cart_items')
//         .doc(widget.product.id)
//         .update({
//       'quantity': quantity,
//     });
//   }
// }
