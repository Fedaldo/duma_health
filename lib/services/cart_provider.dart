import 'package:duma_health/models/cart_product.dart';
import 'package:duma_health/utils/functions.dart';
import 'package:flutter/material.dart';

class CartProvider with ChangeNotifier {
  final List<CartProduct> _cartProducts = [];

  List<CartProduct> get allCartProducts => _cartProducts;

  int get totalAmount => _cartProducts.isNotEmpty
      ? _cartProducts
          .map<int>((e) => e.total)
          .reduce((value, element) => value + element)
      : 0;

  addToCart(CartProduct cartProd) {
    if (checkItem(cartProd)) {
      removeToCart(cartProd.id!);
      _cartProducts.add(cartProd);
      notifyListeners();
    } else {
      _cartProducts.add(cartProd);
      notifyListeners();
    }
  }

  bool checkItem(CartProduct cartRequest) {
    bool exist = false;
    for (int i = 0; i < _cartProducts.length; i++) {
      if (_cartProducts[i].id == cartRequest.id) {
        exist = true;
      }
    }
    return exist;
  }

  removeToCart(int id) {
    _cartProducts.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  updateQty(CartProduct product, int qty) {
    if (checkItem(product)) {
      product.qty = qty;
      product.total =
          AppFunctions.calculateItemTotal(price: product.price, q: qty);
    }
    notifyListeners();
  }

  void cleanCart() {
    _cartProducts.clear();
  }

  int isFromMultipleSellers() {
    int? owner = int.parse(_cartProducts[0].phId);
    if (_cartProducts.length == 1) return 0;

    for (int i = 1; i < _cartProducts.length; i++) {
      if (int.parse(_cartProducts[i].phId) != owner) return 1;
    }
    return 0;
  }

  String allSellersIds() {
    int? owner = int.parse(_cartProducts[0].phId);

    String integers = "";
    integers += owner.toString();

    for (int i = 1; i < _cartProducts.length; i++) {
      if (int.parse(_cartProducts[i].phId) != owner) {
        integers += ",${_cartProducts[i].phId}";
      }
    }
    return integers;
  }

  int getItemsLength() {
    return _cartProducts.length;
  }

  double discount = 0;
  String percentage = "0";

  setDiscount({required String percentage}) {
    this.percentage = percentage;
    int p = double.parse(percentage).toInt();
    double res = (p * totalAmount) / 100;
    discount = res;
    notifyListeners();
  }
}
