import 'package:flutter/material.dart';

class ReceiptProvider extends ChangeNotifier {
  String _orderId = "";
  List<Map<String, dynamic>> _orderItems = [];

  String get orderId => _orderId;
  List<Map<String, dynamic>> get orderItems => _orderItems;

  void createReceipt({
    required String orderId,
    required List<Map<String, dynamic>> items,
  }) {
    _orderId = orderId;
    _orderItems = items;
    notifyListeners();
  }

  void clearReceipt() {
    _orderId = "";
    _orderItems = [];
    notifyListeners();
  }
}