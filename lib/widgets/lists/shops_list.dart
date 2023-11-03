import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grocden/tabs/home_tab.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/shop_model.dart';
import '../../pages/order_by_list_page.dart';
import '../../utils/shop_provider.dart';
import '../tiles/shops_tile.dart';

class ShopList extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: ShopModel.shops.length,
      itemBuilder: (context,index){
        final shop = ShopModel.shops[index];

        //infinite list
        //final shop = ShopModel.shops[index%ShopModel.shops.length];
        return InkWell(
        onTap: () async {
          await saveSelectedShopId(shop.id);
          showToast();
          // Use the Navigator to push the HomeTab route
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => OrderByListPage(shop: shop)),
          // );
        },
          child: ShopTile(shop: shop),
        );
      },
    );
  }

  Future<void> saveSelectedShopId(String shopId) async {
    try {
      // Save the selected shopId to SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('selectedShopId', shopId);
    } catch (e) {
      print('Error saving selectedShopId: $e');
    }
  }

  void showToast() {
    Fluttertoast.showToast(
      msg: 'This is a toast message',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0,

    );
  }
}

