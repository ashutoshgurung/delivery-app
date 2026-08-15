import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_ordering_app/features/features_flag.dart';
import 'package:food_ordering_app/model/address_model.dart';
import 'package:food_ordering_app/model/favourite_model.dart';
import 'package:food_ordering_app/model/order_model.dart';
import 'package:food_ordering_app/services/location_service.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final LocationService _locationService = LocationService();

  // ─────────────────────────────────────────────────────────────────────
  // USER
  // ─────────────────────────────────────────────────────────────────────

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
      'role': 'customer',
      'createdAt': Timestamp.now(),
    });
  }

  Future<void> saveGoogleUser({
    required String uid,
    required String name,
    required String email,
    String imageUrl = "",
  }) async {
    final userRef = _db.collection('users').doc(uid);

    final existingUser = await userRef.get();

    if (!existingUser.exists) {
      await userRef.set({
        'name': name,
        'email': email,
        'imageUrl': imageUrl,
        'role': 'customer',
        'createdAt': Timestamp.now(),
      });
    }
  }

  Future<DocumentSnapshot> getUser(String uid) async {
    return await _db.collection('users').doc(uid).get();
  }

  // ─────────────────────────────────────────────────────────────────────
  // USER ROLE
  // ─────────────────────────────────────────────────────────────────────

  Future<String> getUserRole(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();

    if (!doc.exists) {
      return 'customer';
    }

    final data = doc.data();

    if (data == null) {
      return 'customer';
    }

    return data['role'] ?? 'customer';
  }

  Future<void> setUserRole({
    required String uid,
    required String role,
  }) async {
    await _db.collection('users').doc(uid).set(
      {
        'role': role,
      },
      SetOptions(merge: true),
    );
  }

  Future<void> updateUser({
    required String uid,
    String? name,
    String? imageUrl,
  }) async {
    final data = <String, dynamic>{};

    if (name != null) {
      data['name'] = name;
    }

    if (imageUrl != null) {
      data['imageUrl'] = imageUrl;
    }

    if (data.isNotEmpty) {
      await _db.collection('users').doc(uid).update(data);
    }
  }

  // ─────────────────────────────────────────────────────────────────────
  // FAVOURITES
  // ─────────────────────────────────────────────────────────────────────

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
              .map(
                (doc) => FavouriteModel.fromMap(
                  doc.id,
                  doc.data(),
                ),
              )
              .toList(),
        );
  }

  Future<void> addFavourite(
    String uid,
    FavouriteModel item,
  ) async {
    if (!FeatureFlags.enableFavourites) return;

    await _db
        .collection('users')
        .doc(uid)
        .collection('favourites')
        .doc(item.title)
        .set(item.toMap());
  }

  Future<void> removeFavourite(
    String uid,
    String title,
  ) async {
    if (!FeatureFlags.enableFavourites) return;

    await _db
        .collection('users')
        .doc(uid)
        .collection('favourites')
        .doc(title)
        .delete();
  }

  // ─────────────────────────────────────────────────────────────────────
  // CUSTOMER ORDERS
  // ─────────────────────────────────────────────────────────────────────

  Stream<List<OrderModel>> ordersStream(String uid) {
    return _db
        .collection('users')
        .doc(uid)
        .collection('orders')
        .orderBy(
          'createdAt',
          descending: true,
        )
        .snapshots()
        .map(
          (snap) => snap.docs
              .map(
                (doc) => OrderModel.fromMap(
                  doc.id,
                  doc.data(),
                ),
              )
              .toList(),
        );
  }

  // ─────────────────────────────────────────────────────────────────────
  // PLACE ORDER
  //
  // Saves the same order in:
  //
  // orders/{orderId}
  //
  // and
  //
  // users/{uid}/orders/{orderId}
  // ─────────────────────────────────────────────────────────────────────

  Future<String> placeOrder(
    String uid,
    OrderModel order,
  ) async {
    final user = await _db
        .collection('users')
        .doc(uid)
        .get();

    final userData = user.data() ?? {};

    final locationData =
        await _locationService.getLocationWithAddress();

    final orderRef = _db
        .collection('orders')
        .doc();

    final currentUser =
        FirebaseAuth.instance.currentUser;

    final updatedOrder = OrderModel(
      id: orderRef.id,
      restaurantName: order.restaurantName,
      items: order.items,
      totalPrice: order.totalPrice,

      // Every new order starts as pending.
      status: 'pending',

      createdAt: order.createdAt,

      customerId: uid,

      customerName:
          userData['name'] ??
          currentUser?.displayName ??
          'Customer',

      customerEmail:
          userData['email'] ??
          currentUser?.email ??
          '',

      lat: locationData['lat'],
      lng: locationData['lng'],
      address: locationData['address'],
    );

    final orderData = updatedOrder.toMap();

    final batch = _db.batch();

    // ─────────────────────────────────────────────────────────
    // ADMIN ORDER
    // ─────────────────────────────────────────────────────────

    batch.set(
      orderRef,
      orderData,
    );

    // ─────────────────────────────────────────────────────────
    // CUSTOMER ORDER
    // ─────────────────────────────────────────────────────────

    final customerOrderRef = _db
        .collection('users')
        .doc(uid)
        .collection('orders')
        .doc(orderRef.id);

    batch.set(
      customerOrderRef,
      orderData,
    );

    await batch.commit();

    return orderRef.id;
  }

  // ─────────────────────────────────────────────────────────────────────
  // ADMIN - ALL ORDERS
  // ─────────────────────────────────────────────────────────────────────

  Stream<List<OrderModel>> allOrdersStream() {
    return _db
        .collection('orders')
        .orderBy(
          'createdAt',
          descending: true,
        )
        .snapshots()
        .map(
          (snap) => snap.docs
              .map(
                (doc) => OrderModel.fromMap(
                  doc.id,
                  doc.data(),
                ),
              )
              .toList(),
        );
  }

  // ─────────────────────────────────────────────────────────────────────
  // ADMIN - UPDATE ORDER STATUS
  //
  // Updates BOTH:
  //
  // orders/{orderId}
  //
  // and
  //
  // users/{customerId}/orders/{orderId}
  //
  // This is what makes the customer screen update
  // immediately.
  // ─────────────────────────────────────────────────────────────────────

  Future<void> updateOrderStatus({
    required String orderId,
    required String customerId,
    required String status,
  }) async {
    final batch = _db.batch();

    // Admin copy
    final adminOrderRef = _db
        .collection('orders')
        .doc(orderId);

    batch.update(
      adminOrderRef,
      {
        'status': status,
      },
    );

    // Customer copy
    final customerOrderRef = _db
        .collection('users')
        .doc(customerId)
        .collection('orders')
        .doc(orderId);

    batch.update(
      customerOrderRef,
      {
        'status': status,
      },
    );

    await batch.commit();
  }
 

Future<void> deleteOrder({
  required String orderId,
  required String customerId,
}) async {
  final batch = _db.batch();

  // Admin order
  final adminOrderRef = _db
      .collection('orders')
      .doc(orderId);

  batch.delete(adminOrderRef);

  // Customer order
  final customerOrderRef = _db
      .collection('users')
      .doc(customerId)
      .collection('orders')
      .doc(orderId);

  batch.delete(customerOrderRef);

  await batch.commit();
}

 
  Stream<List<AddressModel>> addressesStream(
    String uid,
  ) {
    return _db
        .collection('users')
        .doc(uid)
        .collection('addresses')
        .snapshots()
        .map(
          (snap) => snap.docs
              .map(
                (doc) => AddressModel.fromMap(
                  doc.id,
                  doc.data(),
                ),
              )
              .toList(),
        );
  }

  Future<void> addAddress(
    String uid,
    AddressModel address,
  ) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('addresses')
        .add(address.toMap());
  }

  Future<void> deleteAddress(
    String uid,
    String addressId,
  ) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('addresses')
        .doc(addressId)
        .delete();
  }

  Future<void> setDefaultAddress(
    String uid,
    String addressId,
  ) async {
    final batch = _db.batch();

    final all = await _db
        .collection('users')
        .doc(uid)
        .collection('addresses')
        .get();

    for (final doc in all.docs) {
      batch.update(
        doc.reference,
        {
          'isDefault': false,
        },
      );
    }

    batch.update(
      _db
          .collection('users')
          .doc(uid)
          .collection('addresses')
          .doc(addressId),
      {
        'isDefault': true,
      },
    );

    await batch.commit();
  }
}