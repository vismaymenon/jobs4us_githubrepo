import 'package:flutter/material.dart';
import '../models/cart_item.dart';

class CartProvider with ChangeNotifier {
  final List<CartItem> _cartItems = [];

  List<CartItem> get cartItems => _cartItems;

  int get totalQuantity =>
      _cartItems.fold(0, (sum, item) => sum + item.quantity);

  void addToCart(CartItem cartItem) {
    final existingItem = _cartItems.firstWhere(
      (item) => item.product.id == cartItem.product.id,
      orElse: () => CartItem(product: cartItem.product, quantity: 0),
    );

    if (existingItem.quantity == 0) {
      _cartItems.add(cartItem);
    } else {
      existingItem.quantity += cartItem.quantity;
    }

    notifyListeners();
  }

  void removeFromCart(CartItem cartItem) {
    _cartItems.remove(cartItem);
    notifyListeners();
  }
}