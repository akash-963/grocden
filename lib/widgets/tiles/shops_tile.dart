// import 'package:flutter/material.dart';
// import 'package:jare_s_application/core/app_export.dart';
// import 'package:jare_s_application/widgets/custom_icon_button.dart';
//
// class ShopTile extends StatelessWidget {
//   const ShopTile({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.fromLTRB(13, 16, 13, 16),
//       decoration: AppDecoration.outlineBlack90033.copyWith(
//         borderRadius: BorderRadiusStyle.roundedBorder10,
//       ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           CustomImageView(
//             svgPath: ImageConstant.imgCar,
//             height: getSize(40),
//             width: getSize(40),
//             margin: getMargin(top: 10, bottom: 16),
//           ),
//           Padding(
//             padding: getPadding(left: 20, top: 7),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 Text(
//                   "",
//                   overflow: TextOverflow.ellipsis,
//                   textAlign: TextAlign.left,
//                   style: AppStyle.txtArialMT20,
//                 ),
//                 SizedBox(
//                   width: getHorizontalSize(135),
//                   child: Text(
//                     "opposite to shop 2,\nLane 1, Somewhere",
//                     maxLines: null,
//                     textAlign: TextAlign.left,
//                     style: AppStyle.txtArialMT15,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Spacer(),
//           CustomIconButton(
//             height: 40,
//             width: 40,
//             margin: getMargin(top: 7, right: 10, bottom: 19),
//             child: CustomImageView(
//               svgPath: ImageConstant.imgLocation,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }





// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:grocden/models/shop_model.dart';
//
// class ShopTile extends StatelessWidget{
//   final Shop shop;
//   const ShopTile({super.key, required this.shop});
//
//   @override
//   Widget build(BuildContext context){
//     return Container(
//       padding: EdgeInsets.fromLTRB(13, 16, 13, 16),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(10),
//         color: Colors.white60,
//         boxShadow: [
//           BoxShadow(
//             blurRadius: 10,
//             offset: Offset(
//               5,
//               10
//             )
//           )
//         ]
//       ),
//       child: Row(
//         children: [
//           //CustomShopImage(),
//           Spacer(),
//           Column(
//             children: [
//               Text('Name'),
//               Text('Add l1'),
//               Text('Add l2'),
//             ],
//           ),
//           Spacer(),
//           //CustomIcon(),
//           Icon(Icons.location_pin,),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../models/shop_model.dart';
import '../shop_image.dart';

class ShopTile extends StatelessWidget{
  final Shop shop;

  const ShopTile({super.key, required this.shop});
  @override
  Widget build(BuildContext context) {
    return VxBox(
        child: Row(
          children: [
            ShopImage(image: shop.image),
            Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    shop.name.text.lg.xl3.color(context.accentColor).bold.make(),
                    10.heightBox,
                    shop.address1.text.make(),
                    shop.address2.text.make(),
                  ],
                )
            ),
            Icon(Icons.location_pin,size: 50, color: context.primaryColor,),
            16.widthBox
          ],
        )

    ).color(context.cardColor).roundedLg.square(120).make().py8();
  }

}