import 'dart:convert';

// class ProductModel {
//   static final shopModel = ProductModel._internal();
//
//   ProductModel._internal();
//
//   factory ProductModel() => shopModel;
//
//   static List<CartItem> products = [];
//
// }

class CartItem {
  final String id;
  final String name;
  final String desc;
  final num price;
  num quantity;
  final String shop;
  final String image;
  CartItem({required this.id, required this.name, required this.desc, required this.price,required this.quantity, required this.shop, required this.image});

  String toJson() => json.encode((toMap()));
  factory CartItem.fromJson(String src) => CartItem.fromMap(jsonDecode(src));

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'name': this.name,
      'desc': this.desc,
      'price': this.price,
      'quantity': this.quantity,
      'image': this.image,
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      id: map['id'] as String,
      name: map['name'] as String,
      desc: map['desc'] as String,
      price: map['price'] as num,
      quantity: map['quantity'] as num,
      shop: map['shopId'] as String,
      image: map['image'] as String,
    );
  }

  setQuantity(num newQuantity) {
    this.quantity = newQuantity;
  }

  CartItem copyWith({
    String? id,
    String? name,
    String? desc,
    num? price,
    num? quantity,
    String? shop,
    String? image,
  }) {
    return CartItem(
      id: id ?? this.id,
      name: name ?? this.name,
      desc: desc ?? this.desc,
      price:  price ?? this.price,
      quantity: quantity ?? this.quantity,
      shop: shop ?? this.shop,
      image: image ?? this.image,
    );
  }

  @override
  String toString() {
    return 'CartItem {id: $id, name: $name, desc: $desc, price: $price, quantity: $quantity, image: $image}';
  }
}