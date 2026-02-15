import 'package:exotic/data/models/product_orignal.dart';
import 'package:flutter/material.dart';

class ProductAvailableOffersComponent extends StatelessWidget {
  final ProductModel product;
  ProductAvailableOffersComponent({super.key, required this.product});
  final List<Map<String, String>> offers = [
    {
      "title": "New User Offer",
      "highlight": "₹200 off",
      "description": "Applicable for first-time users only",
      "tncLink": "T&C",
    },
    {
      "title": "Combo Offer",
      "highlight": "",
      "description": "Buy with earbuds and get extra 10% off",
      "tncLink": "T&C",
    },
  ];
  List<Map<String, dynamic>> Offers(ProductModel product) {
    return offers;
  }

  Widget _buildOfferTile(Map<String, String> offer) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 2),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.green.shade600,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Icon(Icons.local_offer, color: Colors.white, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: const TextStyle(fontSize: 14, color: Colors.black),
                    children: [
                      TextSpan(
                        text: offer["title"] ?? "",
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      if ((offer["highlight"] ?? "").isNotEmpty)
                        TextSpan(
                          text: " ${offer["highlight"]}",
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                      TextSpan(text: " ${offer["description"] ?? ""}"),
                    ],
                  ),
                ),
                const SizedBox(height: 2),
                GestureDetector(
                  onTap: () {
                    // Implement navigation to T&C if needed
                  },
                  child: Text(
                    offer["tncLink"] ?? "T&C",
                    style: const TextStyle(
                      color: Colors.blue,
                      fontSize: 13,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (offers.isEmpty) return const SizedBox();

    return Container(
      margin: const EdgeInsets.only(bottom: 3),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black26),
        borderRadius: BorderRadius.circular(4),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Available offers",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
          const SizedBox(height: 10),
          ...offers.map(_buildOfferTile).toList(),
        ],
      ),
    );
  }
}
