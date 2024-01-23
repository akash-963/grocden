import 'dart:convert';

class ProductModel {
  static final productModel = ProductModel._internal();

  ProductModel._internal();

  factory ProductModel() => productModel;

  static List<Product> products = [];
}

class Product {
  final String id;
  late String shopId;
  final String name;
  final String desc;
  final num price;
  num quantity = 0;
  // final int price;
  final String image;
  //final List<String> imageUrls;
  Product({required this.id, required this.name, required this.desc, required this.price, required this.image});

  setQuantity(num quantity) {
    this.quantity = quantity;
  }

  String toJson() => json.encode((toMap()));
  factory Product.fromJson(String src) => Product.fromMap(jsonDecode(src));

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'name': this.name,
      'desc': this.desc,
      'price': this.price,
      'image': this.image,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    //var images = map['images'] != null ? (map['images'] as List<dynamic>).cast<String>() : [];

    return Product(
      id: map['id'] as String,
      name: map['name'] as String,
      desc: map['desc'] as String,
      price: map['price'] as num,
      // shopId: map['shopId'] as String,
      // price: map['price'] as int,
      image: map['image'] as String,
      //imageUrls: images,
    );
  }

  Product copyWith({
    String? id,
    String? name,
    String? desc,
    num? price,
    // String? shopId,
    // int? price,
    String? image,
    //List<String>? imageUrls,
  }) {
    return Product(
        id: id ?? this.id,
        name: name ?? this.name,
        desc: desc ?? this.desc,
        price:  price ?? this.price,
        image: image ?? this.image,
        // shopId: shopId ?? this.shopId,
        //imageUrls: imageUrls ?? this.imageUrls,
    );
  }

  @override
  String toString() {
    return 'Product{id: $id, name: $name, desc: $desc, price: $price, image: $image}';
  }


}