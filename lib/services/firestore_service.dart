import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_ordering_app/features/features_flag.dart';
import 'package:food_ordering_app/model/address_model.dart';
import 'package:food_ordering_app/model/favourite_model.dart';
import 'package:food_ordering_app/model/order_model.dart';
import 'package:food_ordering_app/services/location_service.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final LocationService _locationService = LocationService();

  // ── USER ────────────────────────────────────────────────────────────────
  Future<void> saveUser({
    required String uid,
    required String name,
    required String email,
    String imageUrl = "",
  }) async {
    await _db.collection('users').doc(uid).set({
      'name': name,
      'email': email,
      'imageUrl': imageUrl,
      'createdAt': Timestamp.now(),
    });
  }

  Future<DocumentSnapshot> getUser(String uid) async {
    return await _db.collection('users').doc(uid).get();
  }

  Future<void> updateUser({
    required String uid,
    String? name,
    String? imageUrl,
  }) async {
    final data = <String, dynamic>{};

    if (name != null) data['name'] = name;
    if (imageUrl != null) data['imageUrl'] = imageUrl;

    if (data.isNotEmpty) {
      await _db.collection('users').doc(uid).update(data);
    }
  }

  // ── FAVOURITES (FEATURE TOGGLED) ────────────────────────────────────────
  Stream<List<FavouriteModel>> favouritesStream(String uid) {
    if (!FeatureFlags.enableFavourites) {
      return const Stream.empty();
    }

    return _db
        .collection('users')
        .doc(uid)
        .collection('favourites')
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((doc) => FavouriteModel.fromMap(doc.id, doc.data()))
              .toList(),
        );
  }

  Future<void> addFavourite(String uid, FavouriteModel item) async {
    if (!FeatureFlags.enableFavourites) return;

    await _db
        .collection('users')
        .doc(uid)
        .collection('favourites')
        .doc(item.title)
        .set(item.toMap());
  }

  Future<void> removeFavourite(String uid, String title) async {
    if (!FeatureFlags.enableFavourites) return;

    await _db
        .collection('users')
        .doc(uid)
        .collection('favourites')
        .doc(title)
        .delete();
  }

  // ── ORDERS ───────────────────────────────────────────────────────────────
  Stream<List<OrderModel>> ordersStream(String uid) {
    return _db
        .collection('users')
        .doc(uid)
        .collection('orders')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((doc) => OrderModel.fromMap(doc.id, doc.data()))
              .toList(),
        );
  }

  Future<void> placeOrder(String uid, OrderModel order) async {
    final locationData = await _locationService.getLocationWithAddress();
    final updatedOrder = OrderModel(
      id: order.id,
      restaurantName: order.restaurantName,
      items: order.items,
      totalPrice: order.totalPrice,
      status: order.status,
      createdAt: order.createdAt,
      lat: locationData['lat'],
      lng: locationData['lng'],
      address: locationData['address'],
    );
    await _db
        .collection('users')
        .doc(uid)
        .collection('orders')
        .add(updatedOrder.toMap());
  }

  // ── ADDRESSES ───────────────────────────────────────────────────────────
  Stream<List<AddressModel>> addressesStream(String uid) {
    return _db
        .collection('users')
        .doc(uid)
        .collection('addresses')
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((doc) => AddressModel.fromMap(doc.id, doc.data()))
              .toList(),
        );
  }

  Future<void> addAddress(String uid, AddressModel address) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('addresses')
        .add(address.toMap());
  }

  Future<void> deleteAddress(String uid, String addressId) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('addresses')
        .doc(addressId)
        .delete();
  }

  Future<void> setDefaultAddress(String uid, String addressId) async {
    final batch = _db.batch();

    final all = await _db
        .collection('users')
        .doc(uid)
        .collection('addresses')
        .get();

    for (final doc in all.docs) {
      batch.update(doc.reference, {'isDefault': false});
    }

    batch.update(
      _db.collection('users').doc(uid).collection('addresses').doc(addressId),
      {'isDefault': true},
    );

    await batch.commit();
  }
}
