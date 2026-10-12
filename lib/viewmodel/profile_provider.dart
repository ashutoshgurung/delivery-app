import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:food_ordering_app/model/address_model.dart';
import 'package:food_ordering_app/model/favourite_model.dart';
import 'package:food_ordering_app/model/order_model.dart';
import 'package:food_ordering_app/model/users_model.dart';
import 'package:food_ordering_app/services/auth_service.dart';
import 'package:food_ordering_app/services/firestore_service.dart';

enum ProfileState { idle, loading, error }

class ProfileViewModel extends ChangeNotifier {
  final FirestoreService _firestoreService;
  final AuthServices _authService;

  ProfileViewModel({
    FirestoreService? firestoreService,
    AuthServices? authService,
  }) : _firestoreService = firestoreService ?? FirestoreService(),
       _authService = authService ?? AuthServices();

  // ── State ──────────────────────────────────────────────────────────────────
  ProfileState _state = ProfileState.idle;
  UserModel? _user;
  String? _errorMessage;
  bool _isUploadingImage = false;

  // ── Real-time data ─────────────────────────────────────────────────────────
  List<OrderModel> _orders = [];
  List<FavouriteModel> _favourites = [];
  List<AddressModel> _addresses = [];

  StreamSubscription? _ordersSub;
  StreamSubscription? _favouritesSub;
  StreamSubscription? _addressesSub;

  // ── Getters ────────────────────────────────────────────────────────────────
  ProfileState get state => _state;
  UserModel? get user => _user;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _state == ProfileState.loading;
  bool get isUploadingImage => _isUploadingImage;

  List<OrderModel> get orders => _orders;
  List<FavouriteModel> get favourites => _favourites;
  List<AddressModel> get addresses => _addresses;

  int get orderCount => _orders.length;
  int get favouriteCount => _favourites.length;
  int get addressCount => _addresses.length;

  Future<void> loadUser() async {
    _setState(ProfileState.loading);

    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) throw Exception("No authenticated user");

      final doc = await _firestoreService.getUser(uid);
      var data = doc.data();
      if (data == null) {
        final authUser = FirebaseAuth.instance.currentUser!;
        await _firestoreService.saveUser(
          uid: uid,
          name: authUser.displayName ?? '',
          email: authUser.email ?? '',
          imageUrl: authUser.photoURL ?? '',
        );
        data = (await _firestoreService.getUser(uid)).data();
      }
      if (data == null) throw Exception("User data not found");

      _user = UserModel.fromMap(uid, data);

      _subscribeStreams(uid);

      _setState(ProfileState.idle);
    } catch (e) {
      _errorMessage = _friendlyError(e);
      _setState(ProfileState.error);
    }
  }

  void _subscribeStreams(String uid) {
    _ordersSub?.cancel();
    _ordersSub = _firestoreService.ordersStream(uid).listen((list) {
      _orders = list;
      notifyListeners();
    }, onError: (Object error) => _handleStreamError(error));

    _favouritesSub?.cancel();
    _favouritesSub = _firestoreService.favouritesStream(uid).listen((list) {
      _favourites = list;
      notifyListeners();
    }, onError: (Object error) => _handleStreamError(error));

    _addressesSub?.cancel();
    _addressesSub = _firestoreService.addressesStream(uid).listen((list) {
      _addresses = list;
      notifyListeners();
    }, onError: (Object error) => _handleStreamError(error));
  }

  Future<void> placeOrder(OrderModel order) async {
    if (_user == null) return;
    try {
      await _firestoreService.placeOrder(_user!.uid, order);
    } catch (e) {
      _errorMessage = "Failed to place order";
      notifyListeners();
    }
  }

  Future<void> addAddress(AddressModel address) async {
    if (_user == null) return;
    try {
      await _firestoreService.addAddress(_user!.uid, address);
    } catch (e) {
      _errorMessage = "Failed to add address";
      notifyListeners();
    }
  }

  Future<void> deleteAddress(String addressId) async {
    if (_user == null) return;
    try {
      await _firestoreService.deleteAddress(_user!.uid, addressId);
    } catch (e) {
      _errorMessage = "Failed to delete address";
      notifyListeners();
    }
  }

  Future<void> setDefaultAddress(String addressId) async {
    if (_user == null) return;
    try {
      await _firestoreService.setDefaultAddress(_user!.uid, addressId);
    } catch (e) {
      _errorMessage = "Failed to set default address";
      notifyListeners();
    }
  }

  Future<void> updateProfileImage(File imageFile) async {
    if (_user == null) return;
    _isUploadingImage = true;
    notifyListeners();

    try {
      final ref = FirebaseStorage.instance.ref().child(
        'profile_images/${_user!.uid}.jpg',
      );
      await ref.putFile(imageFile);
      final downloadUrl = await ref.getDownloadURL();
      await _firestoreService.updateUser(
        uid: _user!.uid,
        imageUrl: downloadUrl,
      );
      _user = _user!.copyWith(imageUrl: downloadUrl);
    } catch (e) {
      _errorMessage = "Failed to update profile image";
    } finally {
      _isUploadingImage = false;
      notifyListeners();
    }
  }

  Future<bool> updateName(String newName) async {
    if (_user == null) return false;
    try {
      await _firestoreService.updateUser(uid: _user!.uid, name: newName);
      _user = _user!.copyWith(name: newName);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = "Failed to update name";
      notifyListeners();
      return false;
    }
  }

  Future<bool> logout() async {
    try {
      _ordersSub?.cancel();
      _favouritesSub?.cancel();
      _addressesSub?.cancel();
      await _authService.logOut();
      _user = null;
      _orders = [];
      _favourites = [];
      _addresses = [];
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = "Failed to logout. Please try again.";
      notifyListeners();
      return false;
    }
  }

  @override
  void dispose() {
    _ordersSub?.cancel();
    _favouritesSub?.cancel();
    _addressesSub?.cancel();
    super.dispose();
  }

  void _setState(ProfileState newState) {
    _state = newState;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    if (_state == ProfileState.error) _state = ProfileState.idle;
    notifyListeners();
  }

  void _handleStreamError(Object error) {
    _errorMessage = _friendlyError(error);
    _state = ProfileState.error;
    notifyListeners();
  }

  String _friendlyError(Object e) {
    final msg = e.toString().toLowerCase();
    if (msg.contains('network') || msg.contains('socket')) {
      return "No internet connection";
    }
    if (msg.contains('permission')) return "Permission denied";
    return "Something went wrong. Please try again.";
  }
}
