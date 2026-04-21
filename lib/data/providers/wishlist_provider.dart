import 'package:exotic/data/models/wishlist.dart';
import 'package:flutter/material.dart';

class WishlistProvider extends ChangeNotifier {
  final List<WishlistModel> _wishlist = [];
  bool _isLoading = false;

  List<WishlistModel> get wishlist => _wishlist;
  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// DATA is List<dynamic>
  void setWishlist(List<dynamic> data) {
    _wishlist
      ..clear()
      ..addAll(
        data.map((e) => WishlistModel.fromJson(e as Map<String, dynamic>)),
      );

    notifyListeners();
  }

  void removeByProduct(int productId) {
    _wishlist.removeWhere((e) => e.productId == productId);
    notifyListeners();
  }

  bool isWishlisted(int productId) {
    return _wishlist.any((e) => e.productId == productId);
  }

  void clear() {
    _wishlist.clear();
    notifyListeners();
  }
}
