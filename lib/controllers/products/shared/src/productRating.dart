import 'package:flutter/material.dart';

class RatingDisplay extends StatelessWidget {
  final double rating;
  final double iconSize;

  const RatingDisplay({super.key, required this.rating, this.iconSize = 18});

  @override
  Widget build(BuildContext context) {
    int fullStars = rating.floor();
    bool hasHalfStar = (rating - fullStars) >= 0.5;
    int totalStars = 5;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...List.generate(totalStars, (index) {
          if (index < fullStars) {
            return Icon(Icons.star, color: Colors.green, size: iconSize);
          } else if (index == fullStars && hasHalfStar) {
            return Icon(Icons.star_half, color: Colors.green, size: iconSize);
          } else {
            return Icon(Icons.star_border, color: Colors.green, size: iconSize);
          }
        }),
        const SizedBox(width: 6),
        Text(
          rating.toStringAsFixed(1),
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            fontFamily: 'Roboto',
            color: Colors.green,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
