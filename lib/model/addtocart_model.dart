// import 'package:food_ordering_app/model/addon_model.dart';

// class AddtocartModel {
//   final String image;
//   final String name;
//   final int price;
//   int quantity;
//   final String size;
//   final List<AddonModel> addons;

//   AddtocartModel({
//     required this.name,
//     required this.price,
//     required this.quantity,
//     required this.size,
//     required this.image,
//     List<AddonModel>? addons,
//   }) : addons = addons ?? [];

//   int get totalPrice {
//     final addonTotal = addons.fold<int>(
//       0,
//       (sum, addon) => sum + addon.price.toInt(),
//     );

//     return (price + addonTotal) * quantity;
//   }
// }

import 'package:hive/hive.dart';
import 'package:food_ordering_app/model/addon_model.dart';

part 'addtocart_model.g.dart';

@HiveType(typeId: 1)
class AddtocartModel extends HiveObject {
  @HiveField(0)
  final String image;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final int price;

  @HiveField(3)
  int quantity;

  @HiveField(4)
  final String size;

  @HiveField(5)
  final List<AddonModel> addons;

  AddtocartModel({
    required this.image,
    required this.name,
    required this.price,
    required this.quantity,
    required this.size,
    List<AddonModel>? addons,
  }) : addons = addons ?? [];

  int get totalPrice {
    final addonTotal =
        addons.fold<int>(0, (sum, addon) => sum + addon.price.toInt());
    return (price + addonTotal) * quantity;
  }
}