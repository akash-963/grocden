import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/product_model.dart';

class AddToCart extends StatefulWidget {
  final Product product;
  const AddToCart({Key? key, required this.product}) : super(key: key);

  @override
  State<AddToCart> createState() => _AddToCartState();
}

class _AddToCartState extends State<AddToCart> {
  String userId = FirebaseAuth.instance.currentUser!.uid;
  String? shopId;
  // late String path;
  bool isInCart = false;


  @override
  void initState() {
    super.initState();
    getDetails();
    checkCart();
  }

  // get user and shop details
  Future<void> getDetails() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      shopId = prefs.getString('selectedShopId')!;
      // print(shopId);
      // print("$userId + $shopId");
    } catch(e) {
      print("Something gone wrong");
    }
  }

  // Check if the product is in the cart
  Future<void> checkCart() async {
    // print(userId);
    DocumentSnapshot cartItemSnapshot = await FirebaseFirestore.instance
        .collection('userCollection')
        .doc(userId)
        .collection('cart_items')
        .doc(widget.product.id)
        .get();

    // print(cartItemSnapshot);
    if (cartItemSnapshot.exists) {
      setState(() {
        isInCart = true;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    // getDetails();
    checkCart();
    return Container(
      width: 80,
      height: 30,
      decoration: ShapeDecoration(
        color: Color(0xff403b58),
        shape: StadiumBorder(),
      ),
      child: isInCart
          ? InkWell(
              onTap: (){
                setState(() {
                  isInCart = true;
                });
                deleteFromCart();
              },
              child: Icon(Icons.done, color: Colors.white),
            )
          : InkWell(
              onTap: () {
                setState(() {
                  isInCart = true;
                });
                addToCart();
              },
              child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  // Function to add the product to the cart
  void addToCart() {
    FirebaseFirestore.instance
        .collection('userCollection')
        .doc(userId)
        .collection('cart_items')
        .doc(widget.product.id)
        .set({
      'quantity': 1,
      'shopId': shopId,
      'price': widget.product.price,
      'name': widget.product.name,
    });
    showToast('Item added to cart');
  }

  // Delete the product from the cart_items collection
  void deleteFromCart() async {
    await FirebaseFirestore.instance
        .collection('userCollection')
        .doc(userId)
        .collection('cart_items')
        .doc(widget.product.id)
        .delete();

    // Reset the state to update the UI
    setState(() {
      isInCart = false;
    });
    showToast('Item deleted from cart');
  }


  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.white,
      textColor: Colors.black,
      fontSize: 16.0,
    );
  }
}