import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:food_ordering_app/model/category_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminCategoryViewModel extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>?
      _categorySubscription;

  List<CategoryModel> _categories = [];

  bool _isLoading = true;
  bool _isSaving = false;

  String? _errorMessage;

  List<CategoryModel> get categories => _categories;

  bool get isLoading => _isLoading;

  bool get isSaving => _isSaving;

  String? get errorMessage => _errorMessage;

  AdminCategoryViewModel() {
    listenToCategories();
  }

  // ============================================================
  // LISTEN TO CATEGORIES
  // ============================================================

  void listenToCategories() {
    _isLoading = true;
    _errorMessage = null;

    notifyListeners();

    _categorySubscription?.cancel();

    _categorySubscription = _db
        .collection('categories')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen(
      (snapshot) {
        _categories = snapshot.docs
            .map(
              (doc) => CategoryModel.fromMap(
                doc.id,
                doc.data(),
              ),
            )
            .toList();

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
  // ADD CATEGORY
  // ============================================================

  Future<bool> addCategory({
    required String name,
    required String imageUrl,
  }) async {
    if (name.trim().isEmpty) {
      _errorMessage = 'Category name is required.';
      notifyListeners();
      return false;
    }

    try {
      _isSaving = true;
      _errorMessage = null;

      notifyListeners();

      await _db.collection('categories').add({
        'name': name.trim(),
        'imageUrl': imageUrl.trim(),
        'createdAt': Timestamp.now(),
      });

      _isSaving = false;

      notifyListeners();

      return true;
    } catch (e) {
      _isSaving = false;
      _errorMessage = e.toString();

      notifyListeners();

      return false;
    }
  }

  // ============================================================
  // UPDATE CATEGORY
  // ============================================================

  Future<bool> updateCategory({
    required String id,
    required String name,
    required String imageUrl,
  }) async {
    if (name.trim().isEmpty) {
      _errorMessage = 'Category name is required.';
      notifyListeners();
      return false;
    }

    try {
      _isSaving = true;
      _errorMessage = null;

      notifyListeners();

      await _db.collection('categories').doc(id).update({
        'name': name.trim(),
        'imageUrl': imageUrl.trim(),
      });

      _isSaving = false;

      notifyListeners();

      return true;
    } catch (e) {
      _isSaving = false;
      _errorMessage = e.toString();

      notifyListeners();

      return false;
    }
  }

  // ============================================================
  // DELETE CATEGORY
  // ============================================================

  Future<bool> deleteCategory(String id) async {
    try {
      await _db
          .collection('categories')
          .doc(id)
          .delete();

      return true;
    } catch (e) {
      _errorMessage = e.toString();

      notifyListeners();

      return false;
    }
  }

  @override
  void dispose() {
    _categorySubscription?.cancel();
    super.dispose();
  }
}