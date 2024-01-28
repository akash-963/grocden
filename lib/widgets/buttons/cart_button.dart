import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../models/cart_model.dart';
import '../../models/product_model.dart';

class ChangeQuantity extends StatefulWidget {
  final CartItem product;

  const ChangeQuantity({Key? key, required this.product}) : super(key: key);

  @override
  State<ChangeQuantity> createState() => _ChangeQuantityState();
}

class _ChangeQuantityState extends State<ChangeQuantity> {
  final String userId = FirebaseAuth.instance.currentUser!.uid;
  String? shopId;
  bool isInCart = false;
  int quantity = 0;


  // get user and shop details
  Future<void> getDetails() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      // userId = prefs.getString('userId')!;
      shopId = prefs.getString('selectedShopId')!;
      // print("$userId + $shopId");
    } catch(e) {
      print("Something gone wrong");
    }
  }

  // Check if the product is in the cart
  void checkCart() async {
    DocumentSnapshot cartItemSnapshot = await FirebaseFirestore.instance
        .collection('userCollection')
        .doc(userId)
        .collection('cart_items')
        .doc(widget.product.id)
        .get();

    if (cartItemSnapshot.exists) {
      setState(() {
        isInCart = true;
        quantity = cartItemSnapshot['quantity'];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getDetails();
    checkCart();
  }

  @override
  Widget build(BuildContext context) {
    // getDetails();
    checkCart();
    return Container(
      width: 100,
      height: 30,
      decoration: ShapeDecoration(
        color: Color(0xff403b58),
        shape: StadiumBorder(),
      ),
      child: isInCart
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                onTap: () {
                  if (quantity > 1) {
                    setState(() {
                      quantity--;
                    });
                    updateQuantityInCart();
                  } else {
                    deleteFromCart();
                    isInCart = false;
                  }
                },
                child: Icon(Icons.remove, color: Colors.white),
              ),
              Container(
                width: 1.2, // Width of the separator line
                color: Colors.white,
              ),
              Text(
                //stateChange ? "${changedQuantity}"
                //            : "${widget.product.quantity}",
                // "${quantity}",
                '${widget.product.quantity}',
                style: TextStyle(color: Colors.white),
              ),
              Container(
                width: 1.2, // Width of the separator line
                color: Colors.white,
              ),
              InkWell(
                onTap: () {
                  // stateChange = true;
                  _updateQuantity(1); // Increase quantity
                },
                child: Icon(Icons.add, color: Colors.white),
              ),
            ],
          )
        : InkWell(
            onTap: () {
              setState(() {
                isInCart = true;
                quantity = 1;
              });
              addToCart();
            },
            child: Icon(Icons.add, color: Colors.white),
        ),
    );
  }

  // Function to update the quantity in Firestore
  Future<void> _updateQuantity(int change) async {
    try {
      // print(widget.product.id);
      // Fetch the current quantity from Firestore
      DocumentReference cartItemRef = FirebaseFirestore.instance
          .collection('userCollection')
          .doc(userId)
          .collection('cart_items')
          .doc(widget.product.id); // Assuming product ID is the document ID

      DocumentSnapshot cartItemSnapshot = await cartItemRef.get();
      // print(cartItemSnapshot);

      if (cartItemSnapshot.exists) {
        // Update the quantity based on the change
        num currentQuantity = cartItemSnapshot['quantity'];
        num newQuantity = currentQuantity + change;
        // changedQuantity = newQuantity as int;

        // print(currentQuantity);
        // print(newQuantity);
        // Ensure the quantity doesn't go below 0
        // newQuantity = newQuantity.clamp(0, double.maxFinite);

        // Update the quantity in Firestore
        await cartItemRef.update({'quantity': newQuantity});
        widget.product.setQuantity(newQuantity);
        // (widget.product.quantity);
        // Update the local state to trigger a rebuild
        setState(() {

        });
      } else {
        print("Doesn't exist");
      }
    } catch (e) {
      print('Error updating quantity: $e');
    }
  }

  // Function to add the product to the cart
  void addToCart() {
    num quantity = 1;
    // print(widget.product.quantity);
    // print(widget.product.price);
    FirebaseFirestore.instance
        .collection('userCollection')
        .doc(userId)
        .collection('cart_items')
        .doc(widget.product.id)
        .set({
      'quantity': quantity,
      'shopId': shopId,
      'price': widget.product.price*quantity,
      'name': widget.product.name,
    });
    //print(widget.product.shopId);

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
      quantity = 0;
    });
  }


  void updateQuantityInCart() {
    // path = 'userCollection/${userId}/cartItems/${widget.product.id}';
    // print(path);
    // print(quantity);
    FirebaseFirestore.instance
        .collection('userCollection')
        .doc(userId)
        .collection('cart_items')
        .doc(widget.product.id)
        .update({
      'quantity': quantity,
    });
  }
}