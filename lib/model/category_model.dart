<<<<<<< HEAD
class CategoryModel {
  final String id;
  final String name;
  final String image;
=======
import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel {
  final String id;
  final String name;
  final String imageUrl;
  final DateTime createdAt;
>>>>>>> origin/main

  const CategoryModel({
    required this.id,
    required this.name,
<<<<<<< HEAD
    required this.image,
  });

  factory CategoryModel.fromMap(String id, Map<String, dynamic> map) {
    return CategoryModel(
      id: id,
      name: map['name'] ?? '',
      image: map['image'] ?? '',
=======
    required this.imageUrl,
    required this.createdAt,
  });

  factory CategoryModel.fromMap(
    String id,
    Map<String, dynamic> map,
  ) {
    return CategoryModel(
      id: id,
      name: map['name'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      createdAt: map['createdAt'] is Timestamp
          ? (map['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
>>>>>>> origin/main
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
<<<<<<< HEAD
      'image': image,
=======
      'imageUrl': imageUrl,
      'createdAt': Timestamp.fromDate(createdAt),
>>>>>>> origin/main
    };
  }
}