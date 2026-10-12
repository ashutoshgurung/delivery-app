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
//   final String? customerEmail;
//   final String? paymentMethod;

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
//     this.customerEmail,
//     this.paymentMethod,
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
//       customerEmail: map['customerEmail'],
//       paymentMethod: map['paymentMethod'],
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
//     'customerEmail': customerEmail,
//     'paymentMethod': paymentMethod,
//   };
// }


// import 'package:cloud_firestore/cloud_firestore.dart';

// class OrderModel {
//   final String id;
//   final String userId;
//   final String restaurantName;
//   final List<dynamic> items;
//   final double totalPrice;
//   final String status;
//   final DateTime createdAt;

//   final double? lat;
//   final double? lng;
//   final String? address;

//   OrderModel({
//     this.id = '',
//     required this.userId,
//     required this.restaurantName,
//     required this.items,
//     required this.totalPrice,
//     required this.status,
//     required this.createdAt,
//     this.lat,
//     this.lng,
//     this.address,
//   });

//   Map<String, dynamic> toMap() {
//     return {
//       'userId': userId,
//       'restaurantName': restaurantName,
//       'items': items,
//       'totalPrice': totalPrice,
//       'status': status,
//       'createdAt': Timestamp.fromDate(createdAt),
//       'lat': lat,
//       'lng': lng,
//       'address': address,
//     };
//   }

//   factory OrderModel.fromMap(
//     String id,
//     Map<String, dynamic> map,
//   ) {
//     return OrderModel(
//       id: id,
//       userId: map['userId'] ?? '',
//       restaurantName: map['restaurantName'] ?? '',
//       items: List<dynamic>.from(map['items'] ?? []),
//       totalPrice: (map['totalPrice'] ?? 0).toDouble(),
//       status: map['status'] ?? 'Pending',
//       createdAt: _parseDate(map['createdAt']),
//       lat: map['lat'] != null
//           ? (map['lat'] as num).toDouble()
//           : null,
//       lng: map['lng'] != null
//           ? (map['lng'] as num).toDouble()
//           : null,
//       address: map['address'],
//     );
//   }

//   static DateTime _parseDate(dynamic value) {
//     if (value is Timestamp) {
//       return value.toDate();
//     }

//     if (value is DateTime) {
//       return value;
//     }

//     return DateTime.now();
//   }

//   OrderModel copyWith({
//     String? id,
//     String? userId,
//     String? restaurantName,
//     List<dynamic>? items,
//     double? totalPrice,
//     String? status,
//     DateTime? createdAt,
//     double? lat,
//     double? lng,
//     String? address,
//   }) {
//     return OrderModel(
//       id: id ?? this.id,
//       userId: userId ?? this.userId,
//       restaurantName: restaurantName ?? this.restaurantName,
//       items: items ?? this.items,
//       totalPrice: totalPrice ?? this.totalPrice,
//       status: status ?? this.status,
//       createdAt: createdAt ?? this.createdAt,
//       lat: lat ?? this.lat,
//       lng: lng ?? this.lng,
//       address: address ?? this.address,
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  final String id;
  final String restaurantName;
  final List<Map<String, dynamic>> items;
  final int totalPrice;
  final String status;
  final DateTime createdAt;
  final String? customerEmail;
  final String? paymentMethod;
  final String? userId;

  OrderModel({
    required this.id,
    required this.restaurantName,
    required this.items,
    required this.totalPrice,
    required this.status,
    required this.createdAt,
    this.customerEmail,
    this.paymentMethod,
    this.userId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'restaurantName': restaurantName,
      'items': items,
      'totalPrice': totalPrice,
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
      'customerEmail': customerEmail,
      'paymentMethod': paymentMethod,
      'userId': userId,
    };
  }

  factory OrderModel.fromMap(
    String id,
    Map<String, dynamic> map,
  ) {
    DateTime createdDate;

    final createdAt = map['createdAt'];

    if (createdAt is Timestamp) {
      createdDate = createdAt.toDate();
    } else if (createdAt is DateTime) {
      createdDate = createdAt;
    } else {
      createdDate = DateTime.now();
    }

    return OrderModel(
      id: id,
      restaurantName:
          map['restaurantName']?.toString() ?? 'Restaurant',
      items: List<Map<String, dynamic>>.from(
        (map['items'] as List? ?? []).map(
          (item) => Map<String, dynamic>.from(item),
        ),
      ),
      totalPrice: (map['totalPrice'] ?? 0).toInt(),
      status: map['status']?.toString() ?? 'pending',
      createdAt: createdDate,
      customerEmail: map['customerEmail']?.toString(),
      paymentMethod: map['paymentMethod']?.toString(),
      userId: map['userId']?.toString(),
    );
  }
}