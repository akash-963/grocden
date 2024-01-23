import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

import '../models/shop_model.dart';
import '../widgets/lists/shops_list.dart';

class ShopsPage extends StatefulWidget{
  @override
  State<ShopsPage> createState() => _ShopsPageState();
}

class _ShopsPageState extends State<ShopsPage> {
  late String shopId;


  Future<void> loadShopFromFirestore() async {
    try {
      ShopModel.shops.clear();
      // Fetch the document containing the shop IDs
      DocumentSnapshot localitiesSnapshot = await FirebaseFirestore.instance
          .collection('localitiesCollection')
          .doc('XLLiGa6XWIxFPyAYTezE')
          .get();

      // Check if the document exists
      if (localitiesSnapshot.exists) {
        // Extract the shop IDs from the 'shopIds' array field
        List<String> shopIds = List<String>.from(localitiesSnapshot['shops']);
        //print(shopIds);

        // Fetch details of each shop using the shop IDs
        for (String shopId in shopIds) {
          DocumentSnapshot shopSnapshot = await FirebaseFirestore.instance
              .collection('shopCollection')
              .doc(shopId)
              .get();

          // Check if the shop document exists
          if (shopSnapshot.exists) {
            // Extract shop details and use them as needed
            Map<String, dynamic> shopData = shopSnapshot.data() as Map<String, dynamic>;
            ShopModel.shops.add(Shop.fromMap(shopData));
          }
        }

        setState(() {
          // Update the UI or perform any other actions
        });
      } else {
        print('Document does not exist');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  void initState(){
    super.initState();
    loadShopFromFirestore();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Nearby Shops"),
      ),
      body: SafeArea(
        child: Container(
          padding: Vx.m8,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //CatalogueHeader(),
              if(ShopModel.shops!=null && ShopModel.shops.isNotEmpty)
                ShopsList()
                    .py8()
                    .expand()
              else
                CircularProgressIndicator().centered().expand(),
            ],
          ),
        ),
      ),
    );
  }
}