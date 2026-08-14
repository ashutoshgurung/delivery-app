import 'package:flutter/material.dart';
import 'package:food_ordering_app/model/address_model.dart';
import 'package:hive/hive.dart';

class AddressProvider extends ChangeNotifier {
  final Box<AddressModel> _box = Hive.box<AddressModel>('address');

  List<AddressModel> get addresses => _box.values.toList();

  // Returns the default address, or the first one if none marked default,
  // or null if the box is empty
  AddressModel? get defaultAddress {
    final all = _box.values.toList();
    if (all.isEmpty) return null;
    return all.firstWhere(
      (a) => a.isDefault,
      orElse: () => all.first,
    );
  }

  void addAddress(AddressModel address) {
    // If this is the first address, make it default automatically
    if (_box.isEmpty) {
      _box.add(AddressModel(
        id: address.id,
        label: address.label,
        fullAddress: address.fullAddress,
        isDefault: true,
      ));
    } else {
      _box.add(address);
    }
    notifyListeners();
  }

  void removeAddress(int index) {
    final wasDefault = _box.getAt(index)?.isDefault ?? false;
    _box.deleteAt(index);

    // If deleted address was default and there are remaining addresses,
    // promote the first one to default
    if (wasDefault && _box.isNotEmpty) {
      _promoteFirstToDefault();
    }

    notifyListeners();
  }

  // Makes one address the default and clears default on all others
  void setDefault(int index) {
    final all = _box.values.toList();

    for (int i = 0; i < all.length; i++) {
      final a = all[i];
      _box.putAt(
        i,
        AddressModel(
          id: a.id,
          label: a.label,
          fullAddress: a.fullAddress,
          isDefault: i == index,
        ),
      );
    }

    notifyListeners();
  }

  void updateAddress(int index, AddressModel updated) {
    _box.putAt(index, updated);
    notifyListeners();
  }

  // Clears all addresses — useful on logout
  void clearAddresses() {
    _box.clear();
    notifyListeners();
  }

  void _promoteFirstToDefault() {
    final first = _box.getAt(0)!;
    _box.putAt(
      0,
      AddressModel(
        id: first.id,
        label: first.label,
        fullAddress: first.fullAddress,
        isDefault: true,
      ),
    );
  }
}