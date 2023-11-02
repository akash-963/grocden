import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class ShopImage extends StatelessWidget{
  final String image;

  const ShopImage({super.key, required this.image}) : assert(image!=null);

  @override
  Widget build(BuildContext context) {
    return Image.network(
        image
    ).box.rounded.p8.color(context.canvasColor).make().p8().h(120).w(100);

  }
}