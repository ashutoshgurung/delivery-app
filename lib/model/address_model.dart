
import 'package:hive/hive.dart';

part 'address_model.g.dart';

@HiveType(typeId: 3)
class AddressModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String label;

  @HiveField(2)
  final String fullAddress;

  @HiveField(3)
  final bool isDefault;

  AddressModel({
    required this.id,
    required this.label,
    required this.fullAddress,
    this.isDefault = false,
  });

  factory AddressModel.fromMap(String id, Map<String, dynamic> map) {
    return AddressModel(
      id: id,
      label: map['label'] ?? "",
      fullAddress: map['fullAddress'] ?? "",
      isDefault: map['isDefault'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {'label': label, 'fullAddress': fullAddress, 'isDefault': isDefault};
  }
}
