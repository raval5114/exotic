import 'package:exotic/data/models/Homepage/elements/Items/mobile_featured_items.dart';
import 'package:exotic/utils/image_formatter.dart';
import 'package:flutter/material.dart';

class FeaturedCard extends StatelessWidget {
  final MobileFeaturedSliderCard item;

  const FeaturedCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140, // Slightly more compact
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Image Card with Offer Strip
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                children: [
                  SizedBox(
                    height: 140,
                    width: 140,
                    child: Image.memory(
                      base64ToBytes(item.img),
                      fit: BoxFit.cover,
                    ),
                  ),

                  /// Offer strip (Gradient)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF8E24AA), Color(0xFFAB47BC)], // gradient purple
                        ),
                      ),
                      child: Text(
                        item.offer,
                        style: const TextStyle(
                          fontFamily: 'Roboto',
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          /// Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              item.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
                height: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
