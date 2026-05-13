import 'package:flutter/material.dart';
import 'package:exotic/data/models/address_model.dart';

class AddressProvider with ChangeNotifier {
  List<Address> _addresses = [];

  List<Address> get addresses => _addresses;

  Address? get defaultAddress {
    try {
      return _addresses.firstWhere((addr) => addr.caIsDefault == 1);
    } catch (e) {
      return _addresses.isNotEmpty ? _addresses.first : null;
    }
  }

  void setDefaultAddress(int caId) {
    for (int i = 0; i < _addresses.length; i++) {
      if (_addresses[i].caId == caId) {
        _addresses[i] = _addresses[i].copyWith(caIsDefault: 1);
      } else {
        _addresses[i] = _addresses[i].copyWith(caIsDefault: 0);
      }
    }
    notifyListeners();
  }

  void _clearDefaults() {
    for (int i = 0; i < _addresses.length; i++) {
      _addresses[i] = _addresses[i].copyWith(caIsDefault: 0);
    }
  }

  // Create
  void addAddress(Address address) {
    if (address.caIsDefault == 1) {
      _clearDefaults();
    } else if (_addresses.isEmpty) {
      // If first address, make it default
      address = address.copyWith(caIsDefault: 1);
    }
    _addresses.add(address);
    notifyListeners();
  }

  // Read
  Address? getAddressById(int caId) {
    try {
      return _addresses.firstWhere((addr) => addr.caId == caId);
    } catch (e) {
      return null;
    }
  }

  // Update
  void updateAddress(int caId, Address updatedAddress) {
    if (updatedAddress.caIsDefault == 1) {
      _clearDefaults();
    }
    final index = _addresses.indexWhere((addr) => addr.caId == caId);
    if (index != -1) {
      _addresses[index] = updatedAddress;
      notifyListeners();
    }
  }

  // Delete
  void deleteAddress(int caId) {
    _addresses.removeWhere((addr) => addr.caId == caId);
    if (_addresses.isNotEmpty && defaultAddress == null) {
      _addresses[0] = _addresses[0].copyWith(caIsDefault: 1);
    }
    notifyListeners();
  }

  // Append a list
  void appendAddresses(List<Address> newAddresses) {
    _addresses.addAll(newAddresses);
    notifyListeners();
  }

  // Set all
  void setAddresses(List<Address> addresses) {
    _addresses = addresses;
    notifyListeners();
  }
}
