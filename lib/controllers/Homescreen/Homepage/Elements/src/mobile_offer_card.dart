import 'package:exotic/data/models/Homepage/elements/Items/mobile_grid_offer_items.dart';
import 'package:exotic/utils/image_formatter.dart';
import 'package:flutter/material.dart';

class OfferGridCard extends StatelessWidget {
  final MobileGridOfferItem item;

  const OfferGridCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Image
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.memory(
              base64ToBytes(item.img),
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        ),

        const SizedBox(height: 8),

        /// Label
        Text(
          item.label,
          style: const TextStyle(
            fontFamily: 'Roboto',
            fontSize: 13,
            color: Colors.black54,
            fontWeight: FontWeight.w400,
          ),
        ),

        const SizedBox(height: 4),

        /// Offer
        Text(
          item.offer,
          style: const TextStyle(
            fontFamily: 'Roboto',
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
