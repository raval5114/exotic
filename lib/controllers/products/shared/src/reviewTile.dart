import 'package:exotic/controllers/products/shared/src/productReview.dart';
import 'package:flutter/material.dart';

class ReviewTile extends StatelessWidget {
  final ProductReview review;

  const ReviewTile({required this.review});

  @override
  Widget build(BuildContext context) {
    int fullStars = review.rating.floor();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Row(
              children: List.generate(
                5,
                (index) => Icon(
                  Icons.star,
                  size: 16,
                  color:
                      index < fullStars ? Colors.green : Colors.grey.shade300,
                ),
              ),
            ),
            const SizedBox(width: 6),
            Text(
              review.rating.toStringAsFixed(1),
              style: const TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 6),
            const Icon(Icons.brightness_1, size: 6, color: Colors.black54),
            const SizedBox(width: 6),
            Text(review.reviewText, style: const TextStyle(fontSize: 14)),
          ],
        ),
        if (review.sizeInfo != null)
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(
              "Review for: ${review.sizeInfo}",
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Text(
            review.qualityText,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
          ),
        ),
      ],
    );
  }
}
