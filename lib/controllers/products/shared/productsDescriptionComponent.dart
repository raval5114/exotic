import 'dart:convert';

import 'package:exotic/controllers/products/shared/src/ProductPricingSection.dart';
import 'package:exotic/controllers/products/shared/src/productImageCarousel.dart';
import 'package:exotic/controllers/products/shared/src/productRating.dart';
import 'package:exotic/controllers/products/shared/src/productSizeChart.dart';
import 'package:flutter/material.dart';

class ProductsdescriptionComponent extends StatefulWidget {
  final String productName;
  final String imgages;
  final double ratings;
  final String discount;
  final String discountedPrice;
  final String initialPrice;
  final bool isFreeDelivery;
  final Map<String, dynamic> sizeChart;
  const ProductsdescriptionComponent({
    super.key,
    required this.productName,
    required this.ratings,
    required this.discount,
    required this.discountedPrice,
    required this.initialPrice,
    required this.isFreeDelivery,
    required this.sizeChart,
    required this.imgages,
  });

  @override
  State<ProductsdescriptionComponent> createState() =>
      _ProductsdescriptionComponentState();
}

class _ProductsdescriptionComponentState
    extends State<ProductsdescriptionComponent> {
  List<String> parseImageList(String? rawString) {
    if (rawString == null || rawString.trim().isEmpty) {
      return [];
    }

    try {
      final decoded = jsonDecode(rawString);
      return List<String>.from(decoded);
    } catch (e) {
      debugPrint("Image parse error: $e");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> imagesList = parseImageList(widget.imgages);

    final bool hasDiscount =
        widget.discount.isNotEmpty && widget.discount != '0';

    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Image Carousel ────────────────────────────────────────────
          ProductCarousel(
            imageMaps:
                imagesList.map((e) => ProductImage.fromString(e)).toList(),
            height: 320,
          ),

          // ── Product Info ──────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Name
                Text(
                  widget.productName,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF111111),
                    fontFamily: 'Roboto',
                    height: 1.35,
                  ),
                ),

                const SizedBox(height: 8),

                // Ratings row
                Row(
                  children: [
                    RatingDisplay(rating: widget.ratings, iconSize: 18),
                    const SizedBox(width: 8),
                    Text(
                      '(${widget.ratings.toStringAsFixed(1)})',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade500,
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Pricing
                ProductPricingSection(
                  discount: widget.discount,
                  initialPrice: widget.initialPrice,
                  discountedPrice: widget.discountedPrice,
                ),

                const SizedBox(height: 10),

                // Badges row
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    if (widget.isFreeDelivery)
                      _Badge(
                        icon: Icons.local_shipping_outlined,
                        label: 'Free Delivery',
                        color: const Color(0xFF1B8A5A),
                        bgColor: const Color(0xFFE6F6EF),
                      ),
                    if (hasDiscount)
                      _Badge(
                        icon: Icons.discount_outlined,
                        label: '${widget.discount}% OFF',
                        color: const Color(0xFFD44000),
                        bgColor: const Color(0xFFFFF0E6),
                      ),
                  ],
                ),

                const SizedBox(height: 16),

                // ── Size Selector ─────────────────────────────────────
                SizeSelector(productData: widget.sizeChart),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Small pill-shaped badge used in the badges row.
class _Badge extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final Color bgColor;

  const _Badge({
    required this.icon,
    required this.label,
    required this.color,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 12.5,
              color: color,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
