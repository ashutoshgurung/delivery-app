import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_ordering_app/model/favourite_model.dart';
import 'package:food_ordering_app/services/firestore_service.dart';
import 'package:hive/hive.dart';

class FavouriteViewModel extends ChangeNotifier {
  final FirestoreService _service = FirestoreService();
  final Box<FavouriteModel> _box = Hive.box<FavouriteModel>('favourites');

  StreamSubscription? _sub;

  // UI always reads from Hive — works offline too
  List<FavouriteModel> get favourites => _box.values.toList();

  // called once after login
  void init(String uid) {
    _sub?.cancel();

    _sub = _service.favouritesStream(uid).listen((list) {
      if (list.isEmpty) return;

      _box.clear();

      for (final item in list) {
        _box.put(item.title, item);
      }

      notifyListeners();
    });
  }

  // Called on logout — clears stream and local cache
  void reset() {
    _sub?.cancel();
    _sub = null;
    _box.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  Future<void> toggleFavourite(FavouriteModel item) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    if (isFavourite(item)) {
      // Optimistic update — remove from Hive immediately
      _box.delete(item.title);
      notifyListeners();
      // Then remove from Firestore — stream will confirm
      await _service.removeFavourite(uid, item.title);
    } else {
      // Optimistic update — add to Hive immediately
      _box.put(item.title, item);
      notifyListeners();
      // Then add to Firestore — stream will confirm
      await _service.addFavourite(uid, item);
    }
  }

  bool isFavourite(FavouriteModel item) => _box.containsKey(item.title);
}
