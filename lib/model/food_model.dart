class FoodModel {
  final String id;
  final String restaurantId;
  final String restaurantName;
  final String category;
  final String name;
  final String description;
  final String image;
  final int price;
  final bool available;

  const FoodModel({
    required this.id,
    required this.restaurantId,
    required this.restaurantName,
    required this.category,
    required this.name,
    required this.description,
    required this.image,
    required this.price,
    this.available = true,
  });

  factory FoodModel.fromMap(String id, Map<String, dynamic> map) {
    return FoodModel(
      id: id,
      restaurantId: map['restaurantId'] ?? '',
      restaurantName: map['restaurantName'] ?? '',
      category: map['category'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      image: map['image'] ?? '',
      price: (map['price'] as num?)?.toInt() ?? 0,
      available: map['available'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'restaurantId': restaurantId,
      'restaurantName': restaurantName,
      'category': category,
      'name': name,
      'description': description,
      'image': image,
      'price': price,
      'available': available,
    };
  }
}