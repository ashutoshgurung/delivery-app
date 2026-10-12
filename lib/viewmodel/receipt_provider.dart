// import 'package:flutter/material.dart';

// class ReceiptProvider extends ChangeNotifier {
//   String _orderId = "";
//   String _paymentMethod = "";
//   List<Map<String, dynamic>> _orderItems = [];

//   String get orderId => _orderId;
//   String get paymentMethod => _paymentMethod;
//   List<Map<String, dynamic>> get orderItems => _orderItems;

//   void createReceipt({
//     required String orderId,
//     required List<Map<String, dynamic>> items,
//     required String paymentMethod,
//   }) {
//     _orderId = orderId;
//     _orderItems = items;
//     _paymentMethod = paymentMethod;
//     notifyListeners();
//   }

//   void clearReceipt() {
//     _orderId = "";
//     _orderItems = [];
//     _paymentMethod = "";
//     notifyListeners();
//   }
// }


import 'package:flutter/material.dart';

class ReceiptProvider extends ChangeNotifier {
  String _orderId = '';

  String _paymentMethod = '';

  List<Map<String, dynamic>> _orderItems = [];

  String get orderId => _orderId;

  String get paymentMethod =>
      _paymentMethod;

  List<Map<String, dynamic>>
      get orderItems => _orderItems;

  void createReceipt({
    required String orderId,
    required List<Map<String, dynamic>> items,
    required String paymentMethod,
  }) {
    _orderId = orderId;

    _orderItems = List<Map<String, dynamic>>.from(
      items,
    );

    _paymentMethod = paymentMethod;

    notifyListeners();
  }

  void clearReceipt() {
    _orderId = '';

    _orderItems = [];

    _paymentMethod = '';

    notifyListeners();
  }
}