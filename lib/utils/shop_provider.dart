import 'package:flutter/material.dart';

class ShopProvider with ChangeNotifier {
  String? _shopId;

  String? get shopId => _shopId;

  void setShopId(String shopId) {
    _shopId = shopId;
    notifyListeners();
  }

  String? getShopId() {
    return _shopId;
  }
}
