// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:food_ordering_app/features/features_flag.dart';
// import 'package:food_ordering_app/model/address_model.dart';
// import 'package:food_ordering_app/model/favourite_model.dart';
// import 'package:food_ordering_app/model/order_model.dart';
// import 'package:food_ordering_app/model/stores_setting_model.dart';
// import 'package:food_ordering_app/services/location_service.dart';

// class FirestoreService {
//   final FirebaseFirestore _db = FirebaseFirestore.instance;
//   final LocationService _locationService = LocationService();

//   // ── USER ────────────────────────────────────────────────────────────────
//   Future<void> saveUser({
//     required String uid,
//     required String name,
//     required String email,
//     String imageUrl = "",
//   }) async {
//     // FIX: Check if user exists to avoid overwriting admin role
//     final docSnapshot = await _db.collection('users').doc(uid).get();

//     final userData = <String, dynamic>{
//       'name': name,
//       'email': email,
//       'imageUrl': imageUrl,
//     };

//     // Only set role to 'user' if this is a new user
//     if (!docSnapshot.exists) {
//       userData['role'] = 'user';
//       userData['createdAt'] = Timestamp.now();
//     }

//     await _db.collection('users').doc(uid).set(userData, SetOptions(merge: true));
//   }

//   Future<DocumentSnapshot> getUser(String uid) async {
//     return await _db.collection('users').doc(uid).get();
//   }

//   Future<void> updateUser({
//     required String uid,
//     String? name,
//     String? imageUrl,
//   }) async {
//     final data = <String, dynamic>{};

//     if (name != null) data['name'] = name;
//     if (imageUrl != null) data['imageUrl'] = imageUrl;

//     if (data.isNotEmpty) {
//       await _db.collection('users').doc(uid).update(data);
//     }
//   }

//   // ── FAVOURITES (FEATURE TOGGLED) ────────────────────────────────────────
//   Stream<List<FavouriteModel>> favouritesStream(String uid) {
//     if (!FeatureFlags.enableFavourites) {
//       return const Stream.empty();
//     }

//     return _db
//         .collection('users')
//         .doc(uid)
//         .collection('favourites')
//         .snapshots()
//         .map(
//           (snap) => snap.docs
//               .map((doc) => FavouriteModel.fromMap(doc.id, doc.data()))
//               .toList(),
//         );
//   }

//   Future<void> addFavourite(String uid, FavouriteModel item) async {
//     if (!FeatureFlags.enableFavourites) return;

//     await _db
//         .collection('users')
//         .doc(uid)
//         .collection('favourites')
//         .doc(item.title)
//         .set(item.toMap());
//   }

//   Future<void> removeFavourite(String uid, String title) async {
//     if (!FeatureFlags.enableFavourites) return;

//     await _db
//         .collection('users')
//         .doc(uid)
//         .collection('favourites')
//         .doc(title)
//         .delete();
//   }

//   // ── ORDERS ───────────────────────────────────────────────────────────────
//   Stream<List<OrderModel>> ordersStream(String uid) {
//     return _db
//         .collection('users')
//         .doc(uid)
//         .collection('orders')
//         .orderBy('createdAt', descending: true)
//         .snapshots()
//         .map(
//           (snap) => snap.docs
//               .map((doc) => OrderModel.fromMap(doc.id, doc.data()))
//               .toList(),
//         );
//   }

//   Future<void> placeOrder(String uid, OrderModel order) async {
//     final locationData = await _locationService.getLocationWithAddress();
//     final updatedOrder = OrderModel(
//       id: order.id,
//       restaurantName: order.restaurantName,
//       items: order.items,
//       totalPrice: order.totalPrice,
//       status: order.status,
//       createdAt: order.createdAt,
//       lat: locationData['lat'],
//       lng: locationData['lng'],
//       address: locationData['address'],
//     );
//     await _db
//         .collection('users')
//         .doc(uid)
//         .collection('orders')
//         .add(updatedOrder.toMap());
//   }

//   // ── ADDRESSES ───────────────────────────────────────────────────────────
//   Stream<List<AddressModel>> addressesStream(String uid) {
//     return _db
//         .collection('users')
//         .doc(uid)
//         .collection('addresses')
//         .snapshots()
//         .map(
//           (snap) => snap.docs
//               .map((doc) => AddressModel.fromMap(doc.id, doc.data()))
//               .toList(),
//         );
//   }

//   Future<void> addAddress(String uid, AddressModel address) async {
//     await _db
//         .collection('users')
//         .doc(uid)
//         .collection('addresses')
//         .add(address.toMap());
//   }

//   Future<void> deleteAddress(String uid, String addressId) async {
//     await _db
//         .collection('users')
//         .doc(uid)
//         .collection('addresses')
//         .doc(addressId)
//         .delete();
//   }

//   Future<void> setDefaultAddress(String uid, String addressId) async {
//     final batch = _db.batch();

//     final all = await _db
//         .collection('users')
//         .doc(uid)
//         .collection('addresses')
//         .get();

//     for (final doc in all.docs) {
//       batch.update(doc.reference, {'isDefault': false});
//     }

//     batch.update(
//       _db.collection('users').doc(uid).collection('addresses').doc(addressId),
//       {'isDefault': true},
//     );

//     await batch.commit();
//   }
//   // ── STORE SETTINGS ──────────────────────────────────────────────────────
//   Future<StoreSettingsModel> getStoreSettings() async {
//     final doc = await _db.collection('settings').doc('store').get();
//     return StoreSettingsModel.fromMap(doc.data());
//   }

//   Future<void> updateStoreSettings(StoreSettingsModel settings) async {
//     await _db
//         .collection('settings')
//         .doc('store')
//         .set(settings.toMap(), SetOptions(merge: true));
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_ordering_app/model/address_model.dart';
import 'package:food_ordering_app/model/favourite_model.dart';
import 'package:food_ordering_app/model/order_model.dart';
import 'package:food_ordering_app/model/stores_setting_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ============================================================
  // PLACE ORDER
  // ============================================================

  Future<void> placeOrder(String uid, OrderModel order) async {
    await _firestore.collection('orders').doc(order.id).set({
      ...order.toMap(),
      'userId': uid,
    });
  }

  // ============================================================
  // CUSTOMER ORDERS
  // ============================================================

  Stream<List<OrderModel>> ordersStream(String uid) {
    return _firestore
        .collection('orders')
        .where('userId', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return OrderModel.fromMap(doc.id, doc.data());
          }).toList();
        });
  }

  // ============================================================
  // ADMIN - ALL ORDERS
  // ============================================================

  Stream<List<OrderModel>> allOrdersStream() {
    return _firestore
        .collection('orders')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return OrderModel.fromMap(doc.id, doc.data());
          }).toList();
        });
  }

  Stream<List<FavouriteModel>> favouritesStream(String uid) {
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('favourites')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => FavouriteModel.fromMap(doc.id, doc.data()))
              .toList(),
        );
  }

  Future<void> addFavourite(String uid, FavouriteModel item) async {
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('favourites')
        .doc(item.title)
        .set(item.toMap());
  }

  Future<void> removeFavourite(String uid, String title) async {
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('favourites')
        .doc(title)
        .delete();
  }

  Stream<List<AddressModel>> addressesStream(String uid) {
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('addresses')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => AddressModel.fromMap(doc.id, doc.data()))
              .toList(),
        );
  }

  Future<void> addAddress(String uid, AddressModel address) async {
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('addresses')
        .add(address.toMap());
  }

  Future<void> deleteAddress(String uid, String addressId) async {
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('addresses')
        .doc(addressId)
        .delete();
  }

  Future<void> setDefaultAddress(String uid, String addressId) async {
    final addresses = await _firestore
        .collection('users')
        .doc(uid)
        .collection('addresses')
        .get();
    final target = addresses.docs.where((doc) => doc.id == addressId);

    if (target.isEmpty) {
      throw StateError('Address $addressId does not exist for user $uid.');
    }

    final batch = _firestore.batch();
    for (final doc in addresses.docs) {
      batch.update(doc.reference, {'isDefault': doc.id == addressId});
    }
    await batch.commit();
  }

  // ============================================================
  // UPDATE ORDER STATUS
  // ============================================================

  Future<void> updateOrderStatus(String orderId, String status) async {
    await _firestore.collection('orders').doc(orderId).update({
      'status': status,
    });
  }

  Future<StoreSettingsModel> getStoreSettings() async {
    final snapshot = await _firestore.collection('settings').doc('store').get();
    return StoreSettingsModel.fromMap(snapshot.data());
  }

  Future<void> updateStoreSettings(StoreSettingsModel settings) async {
    await _firestore
        .collection('settings')
        .doc('store')
        .set(settings.toMap(), SetOptions(merge: true));
  }

  // ============================================================
  // USER PROFILE
  // ============================================================

  Future<void> saveUser({
    required String uid,
    required String name,
    required String email,
    String imageUrl = '',
  }) async {
    final userReference = _firestore.collection('users').doc(uid);
    final userSnapshot = await userReference.get();
    final existingData = userSnapshot.data() ?? <String, dynamic>{};
    final userData = <String, dynamic>{};

    final trimmedName = name.trim();
    final trimmedEmail = email.trim();
    final trimmedImageUrl = imageUrl.trim();
    final existingName = existingData['name'];
    final existingEmail = existingData['email'];
    final existingImageUrl = existingData['imageUrl'];

    if (trimmedName.isNotEmpty &&
        (existingName is! String || existingName.trim().isEmpty)) {
      userData['name'] = trimmedName;
    }
    if (trimmedEmail.isNotEmpty &&
        (existingEmail is! String || existingEmail.trim().isEmpty)) {
      userData['email'] = trimmedEmail;
    }
    if (trimmedImageUrl.isNotEmpty &&
        (existingImageUrl is! String || existingImageUrl.trim().isEmpty)) {
      userData['imageUrl'] = trimmedImageUrl;
    }

    if (!userSnapshot.exists) {
      userData['role'] = 'user';
      userData['createdAt'] = FieldValue.serverTimestamp();
    }

    if (userData.isNotEmpty) {
      await userReference.set(userData, SetOptions(merge: true));
    }
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getUser(String uid) async {
    return _firestore.collection('users').doc(uid).get();
  }

  Future<void> updateUser({
    required String uid,
    String? name,
    String? imageUrl,
  }) async {
    final data = <String, dynamic>{};

    if (name != null) data['name'] = name.trim();
    if (imageUrl != null) data['imageUrl'] = imageUrl;

    if (data.isNotEmpty) {
      await _firestore
          .collection('users')
          .doc(uid)
          .set(data, SetOptions(merge: true));
    }
  }

  // ============================================================
  // GET SINGLE ORDER
  // ============================================================

  Future<OrderModel?> getOrder(String orderId) async {
    final doc = await _firestore.collection('orders').doc(orderId).get();

    if (!doc.exists) {
      return null;
    }

    return OrderModel.fromMap(doc.id, doc.data()!);
  }
}
