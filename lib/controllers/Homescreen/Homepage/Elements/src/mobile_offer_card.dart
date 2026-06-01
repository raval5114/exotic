import 'package:exotic/data/models/Homepage/elements/Items/mobile_grid_offer_items.dart';
import 'package:exotic/utils/image_formatter.dart';
import 'package:flutter/material.dart';

class OfferGridCard extends StatelessWidget {
  final MobileGridOfferItem item;

  const OfferGridCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Image
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                color: const Color(0xFFF5F3FF),
                child: Image.memory(
                  base64ToBytes(item.img),
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Center(
                    child: Icon(
                      Icons.broken_image,
                      color: Colors.grey,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 7),

          /// Label
          Text(
            item.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontSize: 11,
              color: Colors.black54,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 2),

          /// Offer text
          Text(
            item.offer,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontSize: 13,
              fontWeight: FontWeight.w900,
              color: Color(0xFF111827),
            ),
          ),
        ],
      ),
    );
  }
}
