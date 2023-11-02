import 'dart:convert';

class ShopModel {
  static final shopModel = ShopModel._internal();

  ShopModel._internal();

  factory ShopModel() => shopModel;

  static List<Shop> shops = [];

}

class Shop {
  final String id;
  final String name;
  final String address1;
  final String address2;
  final String image;
  //final String coordinates;

  // Shop({required this.id, required this.name, required this.address1, required this.address2, required this.image, required this.coordinates});

  Shop({required this.id, required this.name, required this.address1, required this.address2, required this.image});

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'name': this.name,
      'address1': this.address1,
      'address2': this.address2,
      'image': this.image,
      //'coordinates': this.coordinates,
    };
  }

  String toJson() => json.encode((toMap()));
  factory Shop.fromJson(String src) => Shop.fromMap(jsonDecode(src));

  factory Shop.fromMap(Map<String, dynamic> map) {
    return Shop(
      id: map['id'] as String,
      name: map['name'] as String,
      address1: map['address1'] as String,
      address2: map['address2'] as String,
      image: map['image'] as String,
      //coordinates: map['coordinates'] as String,
    );
  }

  Shop copyWith({
    String? id,
    String? name,
    String? address1,
    String? address2,
    String? image,
    String? coordinates,
  }) {
    return Shop(
      id: id ?? this.id,
      name: name ?? this.name,
      address1: address1 ?? this.address1,
      address2: address2 ?? this.address2,
      image: image ?? this.image,
      // coordinates: coordinates ?? this.coordinates,
    );
  }

  @override
  String toString() {
    return 'Shop{id: $id, name: $name, address1: $address1, address2: $address2, image: $image,}';
  }
}