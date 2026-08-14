// import 'package:cloud_firestore/cloud_firestore.dart';

// class OrderModel {
//   final String id;
//   final String restaurantName;
//   final List<Map<String, dynamic>> items;
//   final int totalPrice;
//   final String status; // "pending", "preparing", "delivered"
//   final DateTime createdAt;
//   final double? lat;
//   final double? lng;
//   final String? address;

//   const OrderModel({
//     required this.id,
//     required this.restaurantName,
//     required this.items,
//     required this.totalPrice,
//     required this.status,
//     required this.createdAt,
//     this.lat,
//     this.lng,
//     this.address,
//   });

//   factory OrderModel.fromMap(String id, Map<String, dynamic> map) {
//     return OrderModel(
//       id: id,
//       restaurantName: map['restaurantName'] ?? "",
//       items: List<Map<String, dynamic>>.from(map['items'] ?? []),
//       totalPrice: map['totalPrice'] ?? 0,
//       status: map['status'] ?? "pending",
//       createdAt: (map['createdAt'] as Timestamp).toDate(),
//       lat: (map['lat'] != null) ? (map['lat'] as num).toDouble() : null,
//       lng: (map['lng'] != null) ? (map['lng'] as num).toDouble() : null,
//       address: map['address'],
//     );
//   }

//   Map<String, dynamic> toMap() => {
//     'restaurantName': restaurantName,
//     'items': items,
//     'totalPrice': totalPrice,
//     'status': status,
//     'createdAt': Timestamp.fromDate(createdAt),
//     'lat': lat,
//     'lng': lng,
//     'address': address,
//   };
// }


import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  final String id;
  final String restaurantName;
  final List<Map<String, dynamic>> items;
  final int totalPrice;
  final String status;
  final DateTime createdAt;

  final String? customerId;
  final String? customerName;
  final String? customerEmail;

  final double? lat;
  final double? lng;
  final String? address;

  const OrderModel({
    required this.id,
    required this.restaurantName,
    required this.items,
    required this.totalPrice,
    required this.status,
    required this.createdAt,
    this.customerId,
    this.customerName,
    this.customerEmail,
    this.lat,
    this.lng,
    this.address,
  });

  factory OrderModel.fromMap(
    String id,
    Map<String, dynamic> map,
  ) {
    return OrderModel(
      id: id,
      restaurantName: map['restaurantName'] ?? '',
      items: List<Map<String, dynamic>>.from(
        (map['items'] ?? []).map(
          (item) => Map<String, dynamic>.from(item),
        ),
      ),
      totalPrice: (map['totalPrice'] ?? 0) is int
          ? map['totalPrice']
          : (map['totalPrice'] as num).toInt(),
      status: map['status'] ?? 'pending',

      createdAt: map['createdAt'] is Timestamp
          ? (map['createdAt'] as Timestamp).toDate()
          : DateTime.now(),

      customerId: map['customerId'],
      customerName: map['customerName'],
      customerEmail: map['customerEmail'],

      lat: map['lat'] != null
          ? (map['lat'] as num).toDouble()
          : null,

      lng: map['lng'] != null
          ? (map['lng'] as num).toDouble()
          : null,

      address: map['address'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'restaurantName': restaurantName,
      'items': items,
      'totalPrice': totalPrice,
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),

      'customerId': customerId,
      'customerName': customerName,
      'customerEmail': customerEmail,

      'lat': lat,
      'lng': lng,
      'address': address,
    };
  }

  OrderModel copyWith({
    String? status,
    double? lat,
    double? lng,
    String? address,
  }) {
    return OrderModel(
      id: id,
      restaurantName: restaurantName,
      items: items,
      totalPrice: totalPrice,
      status: status ?? this.status,
      createdAt: createdAt,
      customerId: customerId,
      customerName: customerName,
      customerEmail: customerEmail,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      address: address ?? this.address,
    );
  }
}