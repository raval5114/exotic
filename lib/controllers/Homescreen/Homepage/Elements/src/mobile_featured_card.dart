import 'package:exotic/data/models/Homepage/elements/Items/mobile_featured_items.dart';
import 'package:flutter/material.dart';

class FeaturedCard extends StatelessWidget {
  final MobileFeaturedSliderCard item;

  const FeaturedCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Image Card with Offer Strip
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                SizedBox(
                  height: 150,
                  width: 150,
                  child: Image.network(item.img, fit: BoxFit.cover),
                ),

                /// Offer strip
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    alignment: Alignment.center,
                    color: const Color(0xFF7C4DFF), // purple tone
                    child: Text(
                      item.offer,
                      style: const TextStyle(
                        fontFamily: 'Roboto',
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          /// Title
          Text(
            item.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontSize: 14,
              fontWeight: FontWeight.w500,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
