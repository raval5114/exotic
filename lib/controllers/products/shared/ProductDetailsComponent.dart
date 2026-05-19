import 'dart:convert';
import 'package:exotic/data/models/product_orignal.dart';
import 'package:flutter/material.dart';

class ProductDetailsComponent extends StatelessWidget {
  final ProductModel product;
  final VoidCallback? onViewAllDetails;

  const ProductDetailsComponent({
    super.key,
    required this.product,
    this.onViewAllDetails,
  });

  /// Converts:
  /// {"fabric":["Georgette"],"color":["Red"]}
  /// →
  /// [{key: fabric, value: Georgette}, {key: color, value: Red}]
  List<Map<String, dynamic>> getProductDetails(String raw) {
    final Map<String, dynamic> decoded = jsonDecode(raw);
    final List<Map<String, dynamic>> result = [];

    decoded.forEach((key, value) {
      if (value is List) {
        for (final item in value) {
          result.add({"key": key, "value": item.toString()});
        }
      }
    });

    return result;
  }

  @override
  Widget build(BuildContext context) {
    final productDetails = getProductDetails(product.pDetail ?? '{}');

    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Product Details",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),

          ...productDetails.map((detail) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 120,
                    child: Text(
                      detail["key"],
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontFamily: 'Roboto',
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      detail["value"],
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontFamily: 'Roboto',
                        color: Colors.black87,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),

          const Divider(thickness: 1, height: 24, color: Colors.black12),

          InkWell(
            onTap: onViewAllDetails,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "All Details",
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                Icon(Icons.chevron_right, size: 24, color: Colors.black),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
