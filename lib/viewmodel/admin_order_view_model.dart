import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:food_ordering_app/model/order_model.dart';
import 'package:food_ordering_app/services/firestore_service.dart';

class AdminOrderViewModel extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  StreamSubscription<List<OrderModel>>? _ordersSubscription;

  List<OrderModel> _orders = [];
  bool _isLoading = true;
  String? _errorMessage;

  List<OrderModel> get orders => _orders;

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  AdminOrderViewModel() {
    listenToOrders();
  }

  void listenToOrders() {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    _ordersSubscription?.cancel();

    _ordersSubscription = _firestoreService.allOrdersStream().listen(
      (orders) {
        _orders = orders;
        _isLoading = false;
        _errorMessage = null;
        notifyListeners();
      },
      onError: (error) {
        _isLoading = false;
        _errorMessage = error.toString();
        notifyListeners();
      },
    );
  }

  Future<void> changeStatus(
    OrderModel order,
    String newStatus,
  ) async {
    if (order.customerId == null || order.customerId!.isEmpty) {
      _errorMessage = 'Customer information is missing.';
      notifyListeners();
      return;
    }

    try {
      await _firestoreService.updateOrderStatus(
        orderId: order.id,
        customerId: order.customerId!,
        status: newStatus,
      );
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _ordersSubscription?.cancel();
    super.dispose();
  }
}