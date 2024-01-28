import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:velocity_x/velocity_x.dart';
import '../models/product_model.dart';
import '../utils/shop_provider.dart';
import '../widgets/app_header.dart';
import '../widgets/lists/product_list.dart';

class HomeTab extends StatefulWidget {
  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  late String? shopId;
  String userId = FirebaseAuth.instance.currentUser!.uid;
  TextEditingController _searchController = TextEditingController();
  List<Product> _filteredProducts = [];


  Future<String?> getSelectedShopId() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString('selectedShopId');
    } catch (e) {
      print('Error getting selectedShopId: $e');
      return null;
    }
  }


  Future<void> loadDataFromFirestore() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('shopCollection/${shopId}/product_list').get();
    List<Map<String, dynamic>> firestoreData =
    querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    ProductModel.products = firestoreData.map<Product>((item) => Product.fromMap(item)).toList();
    setState(() {
      _filteredProducts = ProductModel.products;
    });
  }

  void showToast() {
    Fluttertoast.showToast(
      msg: 'No shop is selected. Go to Shops Tab and select a listed shop',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0,

    );
  }

  Future<void> loadData() async {
    shopId = await getSelectedShopId();

    if (shopId != null) {
      // Do something with the selectedShopId
      print('Selected Shop ID: $shopId');
      await loadDataFromFirestore();

    } else {
      // Handle the case when the selectedShopId is not available
      showToast();
      print('No selected Shop ID found');

    }
  }

  void filterProducts(String searchQuery) {
    setState(() {
      _filteredProducts = ProductModel.products
          .where((product) => product.name.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    });
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // loadData();
    return Scaffold(
      backgroundColor: Color(0xff82CD47),
      floatingActionButton: Container(
        height: 65,
        width: 65,
        child: FloatingActionButton(
          backgroundColor: Colors.green,
          onPressed: () {
            Navigator.pushNamed(context, '/cart');
          },
          child: Icon(CupertinoIcons.cart, size: 40),
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.fromLTRB(10, 16, 10, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppHeader(),
              HeightBox(10),
              TextField(
                controller: _searchController,
                onChanged: (value) {
                  filterProducts(value);
                },
                decoration: InputDecoration(
                  //labelText: 'Search Products',
                  hintText: 'Search Products',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                ),
              ),
              if (_filteredProducts.isNotEmpty)
                ProductList(products: _filteredProducts)
                    .pOnly(top: 16)
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







