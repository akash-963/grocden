import 'package:flutter/material.dart';
import 'package:grocden/tabs/home_tab.dart';
import 'package:provider/provider.dart';
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
        //   onTap: () {
        //     String shopId = shop.id; // Assuming shop has a property called 'id'
        //     print(shopId);
        //     Provider.of<ShopProvider>(context, listen: false).setShopId(shopId);
        //
        //     // Navigate to HomeTab or perform any other actions as needed
        //     Navigator.push(
        //       context,
        //       MaterialPageRoute(builder: (context) => HomeTab()),
        //     );
        //   },
        onTap: () {
          // Use the Navigator to push the HomeTab route
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => OrderByListPage(shop: shop)),
          );
        },
          child: ShopTile(shop: shop),
        );
      },
    );
  }
}

