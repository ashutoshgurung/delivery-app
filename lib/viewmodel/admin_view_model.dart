import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_ordering_app/model/app_user_model.dart';
import 'package:food_ordering_app/model/category_model.dart';
import 'package:food_ordering_app/model/food_model.dart';
import 'package:food_ordering_app/model/order_model.dart';
import 'package:food_ordering_app/model/stores_setting_model.dart';
import 'package:food_ordering_app/services/firestore_service.dart';

class AdminViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirestoreService _firestoreService = FirestoreService();

  List<FoodModel> _foods = [];
  List<CategoryModel> _categories = [];
  List<AppUserModel> _users = [];
  List<OrderModel> _orders = [];

  StoreSettingsModel _storeSettings = const StoreSettingsModel();

  bool _isLoadingFoods = false;
  bool _isLoadingCategories = false;
  bool _isLoadingUsers = false;
  bool _isLoadingSettings = false;
  bool _isLoadingOrders = false;
  bool _isUpdating = false;

  String? _errorMessage;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _ordersSubscription;

  List<FoodModel> get foods => _foods;
  List<CategoryModel> get categories => _categories;
  List<AppUserModel> get users => _users;
  List<OrderModel> get orders => _orders;
  StoreSettingsModel get storeSettings => _storeSettings;

  bool get isLoadingFoods => _isLoadingFoods;
  bool get isLoadingCategories => _isLoadingCategories;
  bool get isLoadingUsers => _isLoadingUsers;
  bool get isLoadingSettings => _isLoadingSettings;
  bool get isLoadingOrders => _isLoadingOrders;
  bool get isLoading => _isLoadingOrders;
  bool get isUpdating => _isUpdating;
  String? get errorMessage => _errorMessage;

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> fetchFoods() async {
    _isLoadingFoods = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final snapshot = await _firestore.collection('foods').orderBy('name').get();
      _foods = snapshot.docs
          .map((doc) => FoodModel.fromMap(doc.id, doc.data()))
          .toList();
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoadingFoods = false;
    notifyListeners();
  }

  Future<bool> addFood(FoodModel food) async {
    try {
      await _firestore.collection('foods').add(food.toMap());
      await fetchFoods();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateFood(FoodModel food) async {
    try {
      await _firestore.collection('foods').doc(food.id).update(food.toMap());
      await fetchFoods();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteFood(String foodId) async {
    try {
      await _firestore.collection('foods').doc(foodId).delete();
      _foods.removeWhere((food) => food.id == foodId);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<void> toggleFoodAvailability(FoodModel food) async {
    final updated = FoodModel(
      id: food.id,
      restaurantId: food.restaurantId,
      restaurantName: food.restaurantName,
      category: food.category,
      name: food.name,
      description: food.description,
      image: food.image,
      price: food.price,
      available: !food.available,
    );
    await updateFood(updated);
  }

  Future<void> fetchCategories() async {
    _isLoadingCategories = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final snapshot = await _firestore.collection('categories').orderBy('name').get();
      _categories = snapshot.docs
          .map((doc) => CategoryModel.fromMap(doc.id, doc.data()))
          .toList();
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoadingCategories = false;
    notifyListeners();
  }

  Future<bool> addCategory(CategoryModel category) async {
    try {
      await _firestore.collection('categories').add(category.toMap());
      await fetchCategories();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateCategory(CategoryModel category) async {
    try {
      await _firestore
          .collection('categories')
          .doc(category.id)
          .update(category.toMap());
      await fetchCategories();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteCategory(String categoryId) async {
    try {
      await _firestore.collection('categories').doc(categoryId).delete();
      _categories.removeWhere((category) => category.id == categoryId);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<void> fetchUsers() async {
    _isLoadingUsers = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final snapshot = await _firestore.collection('users').get();
      _users = snapshot.docs
          .map((doc) => AppUserModel.fromMap(doc.id, doc.data()))
          .toList();
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoadingUsers = false;
    notifyListeners();
  }

  Future<bool> setUserAdmin(String userId, bool isAdmin) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'role': isAdmin ? 'admin' : 'user',
      });
      await fetchUsers();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<void> fetchStoreSettings() async {
    _isLoadingSettings = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _storeSettings = await _firestoreService.getStoreSettings();
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoadingSettings = false;
    notifyListeners();
  }

  Future<bool> updateStoreSettings(StoreSettingsModel settings) async {
    try {
      await _firestoreService.updateStoreSettings(settings);
      _storeSettings = settings;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<void> fetchOrders() async {
    _isLoadingOrders = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final snapshot = await _firestore
          .collection('orders')
          .orderBy('createdAt', descending: true)
          .get();
      _orders = snapshot.docs
          .map((doc) => OrderModel.fromMap(doc.id, doc.data()))
          .toList();
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoadingOrders = false;
    notifyListeners();
  }

  void startOrdersListener() {
    _ordersSubscription?.cancel();

    _isLoadingOrders = true;
    _errorMessage = null;
    notifyListeners();

    _ordersSubscription = _firestore
        .collection('orders')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen(
      (snapshot) {
        _orders = snapshot.docs
            .map((doc) => OrderModel.fromMap(doc.id, doc.data()))
            .toList();
        _isLoadingOrders = false;
        _errorMessage = null;
        notifyListeners();
      },
      onError: (error) {
        _isLoadingOrders = false;
        _errorMessage = error.toString();
        notifyListeners();
      },
    );
  }

  Future<void> updateOrderStatus(String orderId, String status) async {
    try {
      _isUpdating = true;
      _errorMessage = null;
      notifyListeners();

      await _firestore.collection('orders').doc(orderId).update({
        'status': status,
      });

      await fetchOrders();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isUpdating = false;
      notifyListeners();
    }
  }

  Future<void> deleteOrder(String orderId) async {
    try {
      await _firestore.collection('orders').doc(orderId).delete();
      _orders.removeWhere((order) => order.id == orderId);
      notifyListeners();
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

typedef AdminOrderViewModel = AdminViewModel;
