import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocity_x/velocity_x.dart';

import '../models/product_model.dart';
import '../widgets/lists/product_list.dart';

class SearchProductsScreen extends StatefulWidget {
  @override
  _SearchProductsScreenState createState() => _SearchProductsScreenState();
}

class _SearchProductsScreenState extends State<SearchProductsScreen> {
  late String? shopId;
  TextEditingController _searchController = TextEditingController();
  late FocusNode _searchFocusNode;
  List<Product> _filteredProducts = []; // Assuming Product is your data model


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
    _searchFocusNode = FocusNode();
    loadData();
  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          focusNode: _searchFocusNode,
          autofocus: true,
          cursorColor: Colors.black54,
          onChanged: (value) {
            filterProducts(value);
          },
          decoration: InputDecoration(
            hintText: 'Search Products',
            border: InputBorder.none,

          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list_outlined),
            onPressed: () {
              // Implement filter functionality here
            },
          ),
        ],
      ),
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
      // body: _filteredProducts.isNotEmpty
      //       ? ProductList(products: _filteredProducts).pOnly(top: 16).expand()
      //       : Center(child: CircularProgressIndicator()),
      body: SafeArea(
        child: Container(
        child: _filteredProducts.isNotEmpty
          ? ProductList(products: _filteredProducts).pOnly(top: 16).expand()
          : CircularProgressIndicator().centered().expand(),
        ),
      ),
    );
  }
}
