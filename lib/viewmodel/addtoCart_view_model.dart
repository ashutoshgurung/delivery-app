// import 'package:flutter/material.dart';
// import 'package:food_ordering_app/model/addtocart_model.dart';

// class AddtocartProvider extends ChangeNotifier {
//   final List<AddtocartModel> _cartItems = [];

//   List<AddtocartModel> get cartItems => _cartItems;

//   int get cartCount =>
//       _cartItems.fold(0, (sum, item) => sum + item.quantity);

//   int get totalPrice =>
//       _cartItems.fold(0, (sum, item) => sum + item.totalPrice);

//   void addProduct({
//     required String image,
//     required String name,
//     required int price,
//     required int quantity,
//     required String size,
//   }) {
//     final item = AddtocartModel(
//       image: image,
//       name: name,
//       price: price,
//       quantity: quantity,
//       size: size,
//     );

//     final existingIndex = _cartItems.indexWhere(
//       (e) => e.name == item.name && e.size == item.size,
//     );

//     if (existingIndex != -1) {
//       _cartItems[existingIndex].quantity += quantity;
//     } else {
//       _cartItems.add(item);
//     }

//     notifyListeners();
//   }

//   void incrementQuantity(int index) {
//     _cartItems[index].quantity++;
//     notifyListeners();
//   }

//   void decrementQuantity(int index) {
//     if (_cartItems[index].quantity > 1) {
//       _cartItems[index].quantity--;
//     } else {
//       _cartItems.removeAt(index);
//     }
//     notifyListeners();
//   }

//   void removeItem(int index) {
//     _cartItems.removeAt(index);
//     notifyListeners();
//   }

//   void clearCart() {
//     _cartItems.clear();
//     notifyListeners();
//   }
// }

import 'package:flutter/material.dart';
import 'package:food_ordering_app/model/addtocart_model.dart';
import 'package:food_ordering_app/model/addon_model.dart';
import 'package:hive/hive.dart';

class AddtocartProvider extends ChangeNotifier {
  final Box<AddtocartModel> _box = Hive.box<AddtocartModel>('cart');

  List<AddtocartModel> get cartItems => _box.values.toList();

  int get cartCount =>
      cartItems.fold(0, (sum, item) => sum + item.quantity);

  int get totalPrice =>
      cartItems.fold(0, (sum, item) => sum + item.totalPrice);

  void addProduct({
    required String image,
    required String name,
    required int price,
    required int quantity,
    required String size,
    List<AddonModel>? addons,
  }) {
    final existingIndex = cartItems.indexWhere(
      (e) => e.name == name && e.size == size,
    );

    if (existingIndex != -1) {
      final item = _box.getAt(existingIndex)!;
      item.quantity += quantity;
      item.save();
    } else {
      _box.add(AddtocartModel(
        image: image,
        name: name,
        price: price,
        quantity: quantity,
        size: size,
        addons: addons,
      ));
    }

    notifyListeners();
  }

  void incrementQuantity(int index) {
    final item = _box.getAt(index)!;
    item.quantity++;
    item.save();
    notifyListeners();
  }

  void decrementQuantity(int index) {
    final item = _box.getAt(index)!;
    if (item.quantity > 1) {
      item.quantity--;
      item.save();
    } else {
      _box.deleteAt(index);
    }
    notifyListeners();
  }

  void removeItem(int index) {
    _box.deleteAt(index);
    notifyListeners();
  }

  void clearCart() {
    _box.clear();
    notifyListeners();
  }
}