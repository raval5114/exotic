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
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: const Color(0xFFF5F5F5),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.memory(
                base64ToBytes(item.img),
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Center(child: Icon(Icons.broken_image, color: Colors.grey, size: 24)),
              ),
            ),
          ),
        ),

        const SizedBox(height: 10),

        /// Label
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            item.label.toUpperCase(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 11,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
        ),

        const SizedBox(height: 2),

        /// Offer
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            item.offer,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
