
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';

import 'package:grocden/models/product_model.dart';

class OrderModel {
  static final shopModel = OrderModel._internal();

  OrderModel._internal();

  factory OrderModel() => shopModel;

  static List<Order> orders = [];

}

class Order {
  final int id;
  final String desc;
  final int tprice;
  final String status;
  //String tags;
  final List<Product> products;
  Order({required this.id, required this.desc, required this.tprice, required this.products, required this.status});

  String toJson() => json.encode((toMap()));
  factory Order.fromJson(String src) => Order.fromMap(jsonDecode(src));

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'desc': this.desc,
      'tprice': this.tprice,
      'products' : this.products,
      'status': this.status,
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['id'] as int,
      desc: map['desc'] as String,
      tprice: map['tprice'] as int,
      products: map['products'] as List<Product>,
      status: map['status'] as String,
    );
  }

  Order copyWith({
    int? id,
    String? desc,
    int? tprice,
    List<Product>? products,
    String? status,
  }) {
    return Order(
      id: id ?? this.id,
      desc: desc ?? this.desc,
      tprice:  tprice ?? this.tprice,
      products: products ?? this.products,
      status: status ?? this.status,
    );
  }

  @override
  String toString() {
    return 'Order {id: $id, desc: $desc, total_price: $tprice, status: $status}';
  }
}

































class MyOrder {
  final String shop;
  final String buyer;
  final double totalValue;
  final Timestamp createdTimestamp;
  Timestamp? deliveredTimestamp;
  Timestamp? cancelledTimestamp;
  String? tag;
  String? status;
  List<ProductOrderDetails> products;

  MyOrder({
    required this.shop,
    required this.buyer,
    required this.totalValue,
    required this.createdTimestamp,
    required this.products,
    this.deliveredTimestamp,
    this.cancelledTimestamp,
    this.tag,
    this.status,
  });
}

class ProductOrderDetails {
  final String productName;
  final num quantity;
  final num price;

  final String productId;

  ProductOrderDetails({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.price,
  });
}
