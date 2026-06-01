import 'package:exotic/data/models/Homepage/elements/Items/mobile_featured_items.dart';
import 'package:exotic/utils/image_formatter.dart';
import 'package:flutter/material.dart';

class FeaturedCard extends StatelessWidget {
  final MobileFeaturedSliderCard item;

  const FeaturedCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: SizedBox(
        width: 148,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Image Card with Offer Strip
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                children: [
                  SizedBox(
                    height: 148,
                    width: 148,
                    child: Image.memory(
                      base64ToBytes(item.img),
                      fit: BoxFit.cover,
                    ),
                  ),

                  /// Offer strip (Gradient overlay at bottom)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 7),
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF7C3AED), Color(0xFFAB47BC)],
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

            const SizedBox(height: 10),

            /// Title
            Text(
              item.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1F2937),
                height: 1.25,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
