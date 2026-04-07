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
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              offset: const Offset(0, -2),
              blurRadius: 8,
            ),
          ],
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
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '₹${cart.totalMrp}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade500,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '₹${cart.grandTotal.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(Icons.info_outline, size: 14, color: Colors.grey.shade600),
                ],
              ),
            ],
          ),
        ),

        /// PLACE ORDER BUTTON
        ElevatedButton(
          onPressed: () {
            // Place order
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF9647fe),
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            minimumSize: const Size(120, 40),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            'Place Order',
            style: TextStyle(
              fontSize: 14, 
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
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
