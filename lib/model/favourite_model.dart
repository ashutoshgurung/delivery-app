// class FavouriteModel {
//   final String id;         // Firestore doc id
//   final String image;
//   final String title;
//   final String subtitle;
//   final int? price;

//   const FavouriteModel({
//     this.id = "",
//     required this.image,
//     required this.title,
//     required this.subtitle,
//     this.price,
//   });

//   factory FavouriteModel.fromMap(String id, Map<String, dynamic> map) {
//     return FavouriteModel(
//       id: id,
//       image: map['image'] ?? "",
//       title: map['title'] ?? "",
//       subtitle: map['subtitle'] ?? "",
//       price: map['price'],
//     );
//   }

//   Map<String, dynamic> toMap() => {
//         'image': image,
//         'title': title,
//         'subtitle': subtitle,
//         'price': price,
//       };

//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//       other is FavouriteModel && title == other.title;

//   @override
//   int get hashCode => title.hashCode;
// }

import 'package:hive/hive.dart';

part 'favourite_model.g.dart';

@HiveType(typeId: 2)
class FavouriteModel extends HiveObject {
  // Remove 'const' from constructor — HiveObject is not const-compatible
  // Keep 'final' on fields — you never mutate them directly

  @HiveField(0)
  final String id;

  @HiveField(1)
  final String image;

  @HiveField(2)
  final String title;

  @HiveField(3)
  final String subtitle;

  @HiveField(4)
  final int? price;

  FavouriteModel({           // <-- 'const' removed here
    this.id = "",
    required this.image,
    required this.title,
    required this.subtitle,
    this.price,
  });

  factory FavouriteModel.fromMap(String id, Map<String, dynamic> map) {
    return FavouriteModel(
      id: id,
      image: map['image'] ?? "",
      title: map['title'] ?? "",
      subtitle: map['subtitle'] ?? "",
      price: map['price'],
    );
  }

  Map<String, dynamic> toMap() => {
    'image': image,
    'title': title,
    'subtitle': subtitle,
    'price': price,
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FavouriteModel && title == other.title;

  @override
  int get hashCode => title.hashCode;
}