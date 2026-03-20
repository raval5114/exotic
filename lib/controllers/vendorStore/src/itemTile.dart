import 'package:exotic/data/models/product_orignal.dart';
import 'package:exotic/view/products/productScreen.dart';
import 'package:flutter/material.dart';

class ItemTile extends StatelessWidget {
  final ProductModel product;
  final String imagepath;
  final String itemName;
  final String discountedPrice;
  final String initialPrice;
  final String discountedPercentage;
  final String ratings;
  final int averageRatings;
  final String bottomStatus;

  const ItemTile({
    super.key,
    required this.imagepath,
    required this.itemName,
    required this.discountedPrice,
    required this.initialPrice,
    required this.discountedPercentage,
    required this.ratings,
    required this.averageRatings,
    required this.bottomStatus,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap:
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProductScreen()),
          ),
      child: Container(
        width: 160,
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image section
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              child: Stack(
                children: [
                  const SizedBox(
                    width: double.infinity,
                    height: 150,
                    child: Placeholder(), // Replace with image later
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Icon(
                      Icons.favorite_border,
                      color: Colors.grey.shade600,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),

            // Product details
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    itemName,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        "↓$discountedPercentage",
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          color: Colors.green,
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "₹$discountedPrice",
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "₹$initialPrice",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      ..._buildRatingStars(double.tryParse(ratings) ?? 0),
                      const SizedBox(width: 4),
                      Text(
                        "($averageRatings)",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  if (bottomStatus.isNotEmpty)
                    Text(
                      bottomStatus,
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                        color: Colors.black,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildRatingStars(double rating) {
    List<Widget> stars = [];
    for (int i = 1; i <= 5; i++) {
      if (rating >= i) {
        stars.add(const Icon(Icons.star, size: 14, color: Colors.green));
      } else if (rating >= i - 0.5) {
        stars.add(const Icon(Icons.star_half, size: 14, color: Colors.green));
      } else {
        stars.add(const Icon(Icons.star_border, size: 14, color: Colors.green));
      }
    }
    return stars;
  }
}
