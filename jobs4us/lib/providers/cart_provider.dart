import 'package:flutter/material.dart';
import '../models/cart_item.dart';

class CartProvider with ChangeNotifier {
  final List<CartItem> _cartItems = [];

  List<CartItem> get cartItems => _cartItems;

  // get  total quantity of items in cart
  int get totalQuantity => _cartItems.fold(0, (sum, item) => sum + item.quantity);

  // add item to cart
  void addItem(CartItem cartItem) {
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

  // remove item from  cart
  void removeItem(CartItem cartItem) {
    _cartItems.remove(cartItem);
    notifyListeners();
  }

  // increment the quantity of a cart item
  void incrementQuantity(CartItem cartItem) {
    final existingItem = _cartItems.firstWhere(
      (item) => item.product.id == cartItem.product.id,
      orElse: () => CartItem(product: cartItem.product, quantity: 0),
    );

    if (existingItem.quantity > 0) {
      existingItem.quantity++;
      notifyListeners();
    }
  }

  // decrement the quantity of a cart item
  void decrementQuantity(CartItem cartItem) {
    final existingItem = _cartItems.firstWhere(
      (item) => item.product.id == cartItem.product.id,
      orElse: () => CartItem(product: cartItem.product, quantity: 0),
    );

    if (existingItem.quantity > 1) {
      existingItem.quantity--;
    } else {
      _cartItems.remove(existingItem);
    }

    notifyListeners();
  }

  // calculate grand total
  double calculateTotal() {
    return _cartItems.fold(
      0,
      (sum, item) => sum + (item.product.price * item.quantity),
    );
  }

  // clear all items from cart
  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }
}
