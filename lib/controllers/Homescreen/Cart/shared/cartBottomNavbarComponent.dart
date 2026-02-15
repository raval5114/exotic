import 'package:exotic/data/providers/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class CartBottomNavigationBarComponent extends StatelessWidget {
  const CartBottomNavigationBarComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey, width: 0.3)),
        ),
        child: Consumer<CartProvider>(
          builder: (context, cart, _) {
            if (cart.isLoading) {
              return _loadingUI();
            }

            if (!cart.hasData) {
              return const SizedBox.shrink();
            }

            return _loadedUI(cart);
          },
        ),
      ),
    );
  }

  // =========================
  // LOADING UI
  // =========================
  Widget _loadingUI() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _shimmer(width: 120, height: 14),
            const SizedBox(height: 4),
            _shimmer(width: 100, height: 24),
          ],
        ),
        const SizedBox(
          height: 42,
          width: 120,
          child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
        ),
      ],
    );
  }

  // =========================
  // LOADED UI
  // =========================
  Widget _loadedUI(CartProvider cart) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        /// PRICE SECTION
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '₹${cart.totalMrp}',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
                decoration: TextDecoration.lineThrough,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Text(
                  '₹${cart.grandTotal.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(width: 4),
                const Icon(Icons.info_outline, size: 16),
              ],
            ),
          ],
        ),

        /// PLACE ORDER BUTTON
        ElevatedButton(
          onPressed: () {
            // Place order
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          child: const Text(
            'Place Order',
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      ],
    );
  }

  // =========================
  // SHIMMER
  // =========================
  Widget _shimmer({required double width, required double height}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(width: width, height: height, color: Colors.white),
    );
  }
}
