import 'package:exotic/controllers/products/src/productReview.dart';
import 'package:exotic/controllers/products/src/reviewTile.dart';
import 'package:flutter/material.dart';

class Productratingsandreviewscomponents extends StatelessWidget {
  final List<ProductReview> reviews;

  const Productratingsandreviewscomponents({super.key, required this.reviews});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 5),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          const Text(
            "Ratings & Reviews",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            "Good", // This can be computed based on average if needed
            style: const TextStyle(
              color: Colors.black54,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "${reviews.length * 16} ratings and ${reviews.length} reviews", // Example counts
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 8),
          const Divider(thickness: 0.5),

          // Dynamic list of reviews
          ...reviews.asMap().entries.map((entry) {
            final index = entry.key;
            final review = entry.value;
            return Column(
              children: [
                ReviewTile(review: review),
                if (index != reviews.length - 1) const Divider(thickness: 0.5),
              ],
            );
          }).toList(),

          const Divider(thickness: 0.5),

          // Footer
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "All ${reviews.length} reviews",
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ],
      ),
    );
  }
}
