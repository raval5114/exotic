import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:exotic/data/models/address_model.dart';

class AddressProvider with ChangeNotifier {
  // ─── State ──────────────────────────────────────────────────────────────────
  List<Address> _addresses = [];
  String? _userId;
  int? _persistedAddressId;

  static const String _prefKey = 'default_address_pref';

  List<Address> get addresses => _addresses;

  AddressProvider() {
    _loadDefaultAddressFromPrefs();
  }

  // ─── Computed default ───────────────────────────────────────────────────────
  Address? get defaultAddress {
    try {
      return _addresses.firstWhere((addr) => addr.caIsDefault == 1);
    } catch (_) {
      return _addresses.isNotEmpty ? _addresses.first : null;
    }
  }

  // ─── SharedPreferences helpers ──────────────────────────────────────────────

  /// Saves {"userId": ..., "defaultAddressId": ...} to prefs.
  /// Always overwrites the previous entry so only one default is ever stored.
  Future<void> _saveDefaultAddressPref(String userId, int caId) async {
    final prefs = await SharedPreferences.getInstance();
    final data = jsonEncode({'userId': userId, 'defaultAddressId': caId});
    await prefs.setString(_prefKey, data);
  }

  /// Removes the persisted entry (called when no addresses remain).
  Future<void> _clearDefaultAddressPref() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_prefKey);
  }

  /// Returns the stored Map<String, dynamic> or null if nothing is saved.
  Future<Map<String, dynamic>?> getDefaultAddressPref() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_prefKey);
    if (raw == null) return null;
    return jsonDecode(raw) as Map<String, dynamic>;
  }

  // ─── Initialisation (loads saved defaults) ──────────────────────────────────

  Future<void> _loadDefaultAddressFromPrefs() async {
    final pref = await getDefaultAddressPref();
    if (pref != null) {
      _userId = pref['userId']?.toString();
      _persistedAddressId = pref['defaultAddressId'] as int?;
      _ensureSingleDefault();
      notifyListeners();
    }
  }

  /// Restores the persisted default for [userId] and applies it to the list.
  /// Falls back to the server's caIsDefault flag, then to the first address.
  Future<void> loadDefaultAddress(String userId) async {
    _userId = userId;
    final pref = await getDefaultAddressPref();

    if (pref != null && pref['userId'] == userId) {
      final savedId = pref['defaultAddressId'] as int?;
      if (savedId != null && _addresses.any((a) => a.caId == savedId)) {
        _persistedAddressId = savedId;
        _applyDefault(savedId);
        notifyListeners();
        return;
      }
    }

    // Fallback: use server-side default or first address
    final serverDefault = _addresses.where((a) => a.caIsDefault == 1).toList();
    if (serverDefault.isNotEmpty) {
      _persistedAddressId = serverDefault.first.caId!;
      _applyDefault(serverDefault.first.caId!);
    } else if (_addresses.isNotEmpty) {
      _persistedAddressId = _addresses.first.caId!;
      _applyDefault(_addresses.first.caId!);
    }

    notifyListeners();
  }

  // ─── Internal helpers ───────────────────────────────────────────────────────

  /// Marks [caId] as the sole default; clears all others.
  /// Enforces the single-default constraint every time.
  void _applyDefault(int caId) {
    for (int i = 0; i < _addresses.length; i++) {
      _addresses[i] = _addresses[i].copyWith(
        caIsDefault: _addresses[i].caId == caId ? 1 : 0,
      );
    }
  }

  void _clearDefaults() {
    for (int i = 0; i < _addresses.length; i++) {
      _addresses[i] = _addresses[i].copyWith(caIsDefault: 0);
    }
  }

  /// Ensures that there is exactly one default address in the list.
  void _ensureSingleDefault() {
    if (_addresses.isEmpty) return;

    // 1. If we have a persisted address ID for the current/last user, apply it
    if (_persistedAddressId != null &&
        _addresses.any((a) => a.caId == _persistedAddressId)) {
      _applyDefault(_persistedAddressId!);
      return;
    }

    // 2. Otherwise, check if there's any server-side default and keep only the first
    final defaultAddresses =
        _addresses.where((a) => a.caIsDefault == 1).toList();
    if (defaultAddresses.isNotEmpty) {
      _applyDefault(defaultAddresses.first.caId!);
    } else {
      // 3. Fallback to the first address
      final firstId = _addresses.first.caId;
      if (firstId != null) {
        _applyDefault(firstId);
      }
    }
  }

  // ─── Public API ─────────────────────────────────────────────────────────────

  /// Sets [caId] as the only default address and persists the choice for [userId].
  Future<void> setDefaultAddress(int caId, String userId) async {
    _applyDefault(caId);
    _persistedAddressId = caId;
    _userId = userId;
    await _saveDefaultAddressPref(userId, caId);
    notifyListeners();
  }

  // Create
  void addAddress(Address address) {
    if (address.caIsDefault == 1) {
      _clearDefaults();
    } else if (_addresses.isEmpty) {
      // First address always becomes the default
      address = address.copyWith(caIsDefault: 1);
    }
    _addresses.add(address);
    _ensureSingleDefault();
    notifyListeners();
  }

  // Read
  Address? getAddressById(int caId) {
    try {
      return _addresses.firstWhere((addr) => addr.caId == caId);
    } catch (_) {
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
      _ensureSingleDefault();
      notifyListeners();
    }
  }

  // Delete — promotes next address to default if deleted one was the default
  Future<void> deleteAddress(int caId, String userId) async {
    final wasDefault = getAddressById(caId)?.caIsDefault == 1;
    _addresses.removeWhere((addr) => addr.caId == caId);

    if (wasDefault) {
      if (_addresses.isNotEmpty) {
        _ensureSingleDefault();
        final newDefault = defaultAddress;
        if (newDefault != null && newDefault.caId != null) {
          _persistedAddressId = newDefault.caId;
          _userId = userId;
          await _saveDefaultAddressPref(userId, newDefault.caId!);
        }
      } else {
        _persistedAddressId = null;
        _userId = null;
        await _clearDefaultAddressPref();
      }
    } else {
      _ensureSingleDefault();
    }

    notifyListeners();
  }

  // Append a list
  void appendAddresses(List<Address> newAddresses) {
    _addresses.addAll(newAddresses);
    _ensureSingleDefault();
    notifyListeners();
  }

  // Set all
  void setAddresses(List<Address> addresses) {
    _addresses = addresses;
    _ensureSingleDefault();
    notifyListeners();
  }

  void clearAddress() {
    _addresses = [];
    _userId = null;
    _persistedAddressId = null;
    notifyListeners();
  }
}
