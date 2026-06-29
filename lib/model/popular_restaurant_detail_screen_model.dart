class PopularRestaurantDetailScreenModel {
  final String image;
  final String name;
  final String location;
  final String time;
  final String deliveryBadge;
  final Map<String, List<Map<String, dynamic>>> menuItems;
  final List<Map<String, String>> categories;

  PopularRestaurantDetailScreenModel({
    required this.image,
    required this.name,
    required this.location,
    required this.time,
    required this.menuItems,
    required this.categories,
    this.deliveryBadge = 'Free delivery on orders above Rs.1000',
  });
}
