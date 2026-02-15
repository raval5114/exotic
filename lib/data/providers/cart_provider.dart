import 'package:exotic/data/models/cart.dart';
import 'package:flutter/material.dart';

/// CartProvider is the single source of truth for cart dataapp.
/// It stores cart items, pricing summary, and exposes mutation methods
/// that keep UI and business logic in sync.
class CartProvider extends ChangeNotifier {
  /// PRIVATE FIELDS
  ///
  /// List of all cart items currently added by the user
  List<Cart> _cartProducts = [];

  /// Total MRP of all cart items (before discount)
  int _totalMrp = 0;

  /// Total discount applied across all cart items
  double _totalDiscount = 0;

  /// Platform / convenience fee applied to the cart
  int _platformFee = 0;

  /// Final payable amount after discounts + platform fee
  double _grandTotal = 0;

  /// GETTERS
  ///
  /// Exposes cart items as an unmodifiable list to prevent
  /// accidental mutations from UI layer
  List<Cart> get cartProducts => List.unmodifiable(_cartProducts);

  /// Cart summary getters
  int get totalMrp => _totalMrp;
  double get totalDiscount => _totalDiscount;
  int get platformFee => _platformFee;
  double get grandTotal => _grandTotal;

  /// UI state helpers
  ///
  /// isLoading → used while fetching cart from API
  /// hasData   → indicates cart contains at least one item
  bool isLoading = true;
  bool hasData = false;

  /// SETTERS
  ///
  /// Individual setters (used rarely — bulk update preferred)

  set cartProducts(List<Cart> value) {
    _cartProducts = value;
    notifyListeners();
  }

  set totalMrp(int value) {
    _totalMrp = value;
    notifyListeners();
  }

  set totalDiscount(double value) {
    _totalDiscount = value;
    notifyListeners();
  }

  set platformFee(int value) {
    _platformFee = value;
    notifyListeners();
  }

  set grandTotal(double value) {
    _grandTotal = value;
    notifyListeners();
  }

  /// BULK UPDATE (RECOMMENDED)
  ///
  /// Updates entire cart state in one go.
  ///
  /// Used when:
  /// • Fetching cart from API
  /// • Syncing server-calculated values
  ///
  /// This avoids multiple notifyListeners() calls and
  /// guarantees state consistency.
  void updateFromApi({
    required List<Cart> products,
    required int totalMrp,
    required double totalDiscount,
    required int platformFee,
    required double grandTotal,
  }) {
    _cartProducts = products;
    _totalMrp = totalMrp;
    _totalDiscount = totalDiscount;
    _platformFee = platformFee;
    _grandTotal = grandTotal;

    isLoading = false;
    hasData = products.isNotEmpty;

    notifyListeners();
  }

  /// REMOVE CART ITEM
  ///
  /// Removes a cart item locally and re-adjusts pricing summary.
  ///
  /// Called after:
  /// • Successful delete API response
  ///
  /// Why local update?
  /// • Instant UI response
  /// • Avoids unnecessary cart re-fetch
  /// • Backend is already the source of truth
  void removeCart(int cartId) {
    final index = _cartProducts.indexWhere((e) => e.cartId == cartId);

    // If item not found, do nothing
    if (index == -1) return;

    final Cart removedItem = _cartProducts[index];

    // 1️⃣ Remove item from cart list
    _cartProducts.removeAt(index);

    // 2️⃣ Deduct pricing values related to the removed item
    _totalMrp -= removedItem.mrp;
    _totalDiscount -= removedItem.discount;
    _grandTotal -= removedItem.totalPrice;

    // 3️⃣ Handle platform fee when cart becomes empty
    if (_cartProducts.isEmpty) {
      _platformFee = 0;
      hasData = false;
    }

    // 4️⃣ Safety checks to prevent negative totals
    if (_totalMrp < 0) _totalMrp = 0;
    if (_totalDiscount < 0) _totalDiscount = 0;
    if (_grandTotal < 0) _grandTotal = 0;

    notifyListeners();
  }

  void addQuantity(int cartId) {
    final index = _cartProducts.indexWhere((e) => e.cartId == cartId);
    if (index == -1) return;

    final item = _cartProducts[index];

    final double perUnitMrp = item.mrp / item.quantity;
    final double perUnitDiscount = item.discount / item.quantity;
    final double perUnitTotal = item.totalPrice / item.quantity;

    final updatedItem = item.copyWith(
      quantity: item.quantity + 1,
      mrp: (item.mrp + perUnitMrp).round(),
      discount: (item.discount + perUnitDiscount).round(),
      totalPrice: item.totalPrice + perUnitTotal,
    );

    _cartProducts[index] = updatedItem;

    _totalMrp += perUnitMrp.round();
    _totalDiscount += perUnitDiscount;
    _grandTotal += perUnitTotal;

    notifyListeners();
  }

  void minusQuantity(int cartId) {
    final index = _cartProducts.indexWhere((e) => e.cartId == cartId);
    if (index == -1) return;

    final item = _cartProducts[index];
    if (item.quantity <= 1) return;

    final double perUnitMrp = item.mrp / item.quantity;
    final double perUnitDiscount = item.discount / item.quantity;
    final double perUnitTotal = item.totalPrice / item.quantity;

    final updatedItem = item.copyWith(
      quantity: item.quantity - 1,
      mrp: (item.mrp - perUnitMrp).round(),
      discount: (item.discount - perUnitDiscount).round(),
      totalPrice: item.totalPrice - perUnitTotal,
    );

    _cartProducts[index] = updatedItem;

    _totalMrp -= perUnitMrp.round();
    _totalDiscount -= perUnitDiscount;
    _grandTotal -= perUnitTotal;

    if (_totalMrp < 0) _totalMrp = 0;
    if (_totalDiscount < 0) _totalDiscount = 0;
    if (_grandTotal < 0) _grandTotal = 0;

    notifyListeners();
  }

  /// ---------------- RESET CART ----------------
  /// Clears entire cart state.
  ///
  /// Used when:
  /// • User logs out
  /// • Order placed successfully
  /// • Cart reset is required
  void clearCart() {
    _cartProducts.clear();
    _totalMrp = 0;
    _totalDiscount = 0;
    _platformFee = 0;
    _grandTotal = 0;
    hasData = false;
    isLoading = false;

    notifyListeners();
  }
}
