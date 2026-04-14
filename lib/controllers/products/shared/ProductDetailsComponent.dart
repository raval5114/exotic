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
          const Text(
            "Product Details",
            style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.bold,
              fontSize: 18,
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
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        color: Colors.grey[600],
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      detail["value"],
                      style: const TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 14,
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
              children: const [
                Text(
                  "All Details",
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 15,
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
