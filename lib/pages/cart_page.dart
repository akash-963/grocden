import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:velocity_x/velocity_x.dart';
import '../models/cart_model.dart';
import '../widgets/buttons/cart_button.dart';
import '../widgets/shop_image.dart';
import 'order_summary.dart';


class OrderDetails {
  final String productId;
  final String productName;
  final num quantity;
  final num price;
  final num value;

  OrderDetails({
    required this.productName,
    required this.quantity,
    required this.price,
    required this.value, required this.productId,
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



class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  String userId = FirebaseAuth.instance.currentUser!.uid;
  List<CartItem> _cartProducts = [];


  Future<void> proceedToBuy() async {

    try {
      // Replace 'cart_items' with your actual collection name
      QuerySnapshot cartItemsSnapshot =
      await FirebaseFirestore.instance.collection('userCollection/${userId}/cart_items').get();

      List<OrderDetails> orderDetailsList = [];
      double totalCartValue = 0;

      for (QueryDocumentSnapshot cartItem in cartItemsSnapshot.docs) {
        String productId = cartItem.id;
        // String shopId = cartItem['shopId'];
        String productName = cartItem['name'];
        num quantity = cartItem['quantity'];
        num price = cartItem['price'];
        num value = quantity * price;


        orderDetailsList.add(OrderDetails(
          productId: productId,
          productName: productName,
          quantity: quantity,
          price: price,
          value: value,
        ));

        totalCartValue += value;
      }

      OrderSummary orderSummary =
      OrderSummary(orderDetailsList: orderDetailsList, totalCartValue: totalCartValue);

      // Now you have the order details, and you can use them as needed
      print('Order Details:');
      for (OrderDetails orderDetails in orderSummary.orderDetailsList) {
        print('Product: ${orderDetails.productName}, Quantity: ${orderDetails.quantity}, Price: ${orderDetails.price}, Value: ${orderDetails.value}');
      }

      print('Total Cart Value: ${orderSummary.totalCartValue}');

      // Add your logic to proceed with the order
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OrderSummaryPage(orderSummary: orderSummary),
        ),
      );


    } catch (e) {
      print('Error reading cart items: $e');
      // Handle the error
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Container(
        height: 75,
        width: 100,
        padding: EdgeInsets.all(4),
        child: FloatingActionButton(
          onPressed: () {
            proceedToBuy();
          },
          child: Text("Proceed to Buy",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
          backgroundColor: Colors.green,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      appBar: AppBar(
        title: Text("Cart Page"),
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: Center(
          child: Column(
            children: [
              if (_cartProducts.isNotEmpty)
                CartList(cartItems: _cartProducts)
                    .pOnly(top: 16)
                    .expand()
              else
                "Cart is empty".text.xl2.make().centered().expand(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadCartItems();
  }

  Future<void> _loadCartItems() async {
    print(userId);
    try {
      // Fetch cart items from the user's cart collection
      QuerySnapshot cartSnapshot = await FirebaseFirestore.instance
          .collection('userCollection')
          .doc(userId)
          .collection('cart_items')
          .get();

      List<CartItem> cartItems = [];


      // Iterate over each cart item document
      for (QueryDocumentSnapshot cartDoc in cartSnapshot.docs) {
        // Extract data from the cart item document
        String productId = cartDoc.id;
        // print(productId);
        String shopId = cartDoc['shopId'];
        // print(shopId);
        int quantity = cartDoc['quantity'];
        // print(quantity);
        // num value = cartDoc['value'];


        print(shopId);
        // Fetch product details from the shop's product list
        DocumentSnapshot productSnapshot = await FirebaseFirestore.instance
            .collection('shopCollection')
            .doc(shopId)
            .collection('product_list')
            .doc(productId)
            .get();

        if (productSnapshot.exists) {
          // Extract product details
          Map<String, dynamic> productData =
          productSnapshot.data() as Map<String, dynamic>;

          // Create CartItem object
          CartItem cartItem = CartItem(
            id: productId,
            name: productData['name'],
            desc: productData['desc'],
            price: productData['price'],
            image: productData['image'],
            shop: shopId,
            quantity: quantity,
          );

          // Add the cart item to the list
          cartItems.add(cartItem);
        }
      }

      print(cartItems);
      // Update the state to trigger a rebuild with the loaded cart items
      setState(() {
        _cartProducts = cartItems;
      });
    } catch (e) {
      print('Error loading cart items: $e');
    }
  }
}

class CartList extends StatelessWidget {
  final List<CartItem> cartItems;

  CartList({required this.cartItems});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      //   crossAxisCount: 2,
      //   crossAxisSpacing: 8,
      //   mainAxisSpacing: 8,
      //   childAspectRatio: (2 / 2.3),
      // ),
      padding: EdgeInsets.all(8),
      shrinkWrap: true,
      itemCount: cartItems.length,
      itemBuilder: (context, index) {
        final item = cartItems[index];
        return CartTile(item: item);
      },
    );
  }
}

class CartTile extends StatelessWidget {
  final CartItem item;
  const CartTile({Key? key, required this.item}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(10),
      ),
      height: 100,
      child: Row(
        children: [
          Hero(
            tag: Key(item.id.toString()),
            child: ShopImage(image: item.image), // Display the first image if available
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  item.name.text.lg.ellipsis.color(context.accentColor).bold.make(),
                  item.desc.text.maxLines(2).ellipsis.make(),
                  SizedBox(height: 5,),
                  ButtonBar(
                    alignment: MainAxisAlignment.spaceBetween,
                    buttonPadding: EdgeInsets.zero,
                    children: [
                      "\$${item.price}".text.xl.bold.make(),
                      ChangeQuantity(product: item),
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







// class _ChangeQuantity extends StatefulWidget {
//   final CartItem product;
//
//   const _ChangeQuantity({Key? key, required this.product}) : super(key: key);
//
//   @override
//   State<_ChangeQuantity> createState() => _ChangeQuantityState();
// }
//
//
// class _ChangeQuantityState extends State<_ChangeQuantity> {
//   // You can implement quantity change logic here
//   // TextEditingController quantity = TextEditingController();
//   // bool stateChange = false;
//   // int changedQuantity = widget.product.quantity as int;
//   String userId = FirebaseAuth.instance.currentUser!.uid;
//
//   @override
//   Widget build(BuildContext context) {
//     // quantity = widget.product.quantity as TextEditingController;
//     // print("Rebuild");
//     // print(stateChange);
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
//               // stateChange = true;
//               _updateQuantity(-1); // Decrease quantity
//             },
//             child: Icon(Icons.remove, color: Colors.white),
//           ),
//           Container(
//             width: 1.2, // Width of the separator line
//             color: Colors.white,
//           ),
//           Text(
//             //stateChange ? "${changedQuantity}"
//             //            : "${widget.product.quantity}",
//             // "${quantity}",
//             '${widget.product.quantity}',
//             style: TextStyle(color: Colors.white),
//           ),
//           Container(
//             width: 1.2, // Width of the separator line
//             color: Colors.white,
//           ),
//           InkWell(
//             onTap: () {
//               // stateChange = true;
//               _updateQuantity(1); // Increase quantity
//             },
//             child: Icon(Icons.add, color: Colors.white),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // Function to update the quantity in Firestore
//   Future<void> _updateQuantity(int change) async {
//     try {
//       // Replace 'userId' with the actual user ID
//
//       print(widget.product.id);
//       // Fetch the current quantity from Firestore
//       DocumentReference cartItemRef = FirebaseFirestore.instance
//           .collection('userCollection')
//           .doc(userId)
//           .collection('cart_items')
//           .doc(widget.product.id); // Assuming product ID is the document ID
//
//       DocumentSnapshot cartItemSnapshot = await cartItemRef.get();
//       print(cartItemSnapshot);
//
//       if (cartItemSnapshot.exists) {
//         // Update the quantity based on the change
//         num currentQuantity = cartItemSnapshot['quantity'];
//         num newQuantity = currentQuantity + change;
//         // changedQuantity = newQuantity as int;
//
//         print(currentQuantity);
//         print(newQuantity);
//         // Ensure the quantity doesn't go below 0
//         // newQuantity = newQuantity.clamp(0, double.maxFinite);
//
//         // Update the quantity in Firestore
//         await cartItemRef.update({'quantity': newQuantity});
//         widget.product.setQuantity(newQuantity);
//         print(widget.product.quantity);
//         // Update the local state to trigger a rebuild
//         setState(() {
//
//         });
//       } else {
//         print("Doesn't exist");
//       }
//     } catch (e) {
//       print('Error updating quantity: $e');
//     }
//   }
// }
