import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class ProductImage extends StatelessWidget{
  final String image;

  const ProductImage({super.key, required this.image}) : assert(image!=null);

  @override
  Widget build(BuildContext context) {
    return Image.network(
        image,
      fit: BoxFit.contain,
    ).box.rounded.color(context.canvasColor).make().p8().h(MediaQuery.of(context).copyWith().size.height / 6,).w(MediaQuery.of(context).copyWith().size.width / 2,);
  }
}