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
      margin: const EdgeInsets.only(bottom: 2),
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Product Details",
            style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 10),

          /// ✅ FIXED LIST RENDERING
          ...productDetails.map((detail) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 90,
                    child: Text(
                      detail["key"],
                      style: const TextStyle(
                        fontFamily: 'Roboto',
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      detail["value"],
                      style: const TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 15,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),

          const SizedBox(height: 12),

          InkWell(
            onTap: onViewAllDetails,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  "All Details",
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
                Icon(Icons.arrow_forward_ios, size: 14),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
