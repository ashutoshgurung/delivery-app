// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:food_ordering_app/model/order_model.dart';
// import 'package:food_ordering_app/services/firestore_service.dart';

// class OrderViewModel extends ChangeNotifier {
//   final FirestoreService _firestoreService =
//       FirestoreService();

//   List<OrderModel> _orders = [];

//   bool _isLoading = true;

//   String? _errorMessage;

//   StreamSubscription<List<OrderModel>>? _subscription;

//   List<OrderModel> get orders => _orders;

//   bool get isLoading => _isLoading;

//   String? get errorMessage => _errorMessage;

//   void startOrdersListener(String uid) {
//     _isLoading = true;
//     _errorMessage = null;

//     notifyListeners();

//     _subscription?.cancel();

//     _subscription =
//         _firestoreService.ordersStream(uid).listen(
//       (orders) {
//         _orders = orders;

//         _isLoading = false;
//         _errorMessage = null;

//         notifyListeners();
//       },
//       onError: (error) {
//         _isLoading = false;
//         _errorMessage = error.toString();

//         notifyListeners();
//       },
//     );
//   }

//   @override
//   void dispose() {
//     _subscription?.cancel();
//     super.dispose();
//   }
// }

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:food_ordering_app/model/order_model.dart';
import 'package:food_ordering_app/services/firestore_service.dart';

class OrderViewModel extends ChangeNotifier {
  final FirestoreService _firestoreService =
      FirestoreService();

  List<OrderModel> _orders = [];

  bool _isLoading = true;

  String? _errorMessage;

  StreamSubscription<List<OrderModel>>? _subscription;

  List<OrderModel> get orders => _orders;

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  // ============================================================
  // START CUSTOMER ORDER LISTENER
  // ============================================================

  void startOrdersListener(
    String uid,
  ) {
    _isLoading = true;
    _errorMessage = null;

    notifyListeners();

    _subscription?.cancel();

    _subscription =
        _firestoreService.ordersStream(uid).listen(
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

  // ============================================================
  // REFRESH
  // ============================================================

  Future<void> refresh(
    String uid,
  ) async {
    startOrdersListener(uid);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}