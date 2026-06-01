import 'package:exotic/data/models/Homepage/elements/mobile_offer_strip.dart';
import 'package:exotic/utils/image_formatter.dart';
import 'package:flutter/material.dart';

class OfferStripCard extends StatelessWidget {
  final MobileOfferItem item;

  const OfferStripCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        debugPrint("Offer strip card tapped");
      },
      child: SizedBox(
        width: 134,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Card with image + badge + offer strip
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Stack(
                children: [
                  /// Main Image
                  Container(
                    height: 148,
                    width: 134,
                    color: const Color(0xFFF5F3FF),
                    child: Image.memory(
                      base64ToBytes(item.image),
                      fit: BoxFit.fill,
                    ),
                  ),

                  /// Badge (e.g. "AD", "NEW", etc.)
                  if (item.badge.isNotEmpty)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          item.badge,
                          style: const TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 9,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),

                  /// Offer Strip (Brand gradient)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF7C3AED), Color(0xFFE94A75)],
                        ),
                      ),
                      child: Text(
                        item.offer,
                        style: const TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            /// Caption
            Text(
              item.caption,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1F2937),
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
