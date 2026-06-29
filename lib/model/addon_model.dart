import 'package:hive/hive.dart';

part 'addon_model.g.dart';

@HiveType(typeId: 0)
class AddonModel extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  double price;

  AddonModel({required this.name, required this.price});
}