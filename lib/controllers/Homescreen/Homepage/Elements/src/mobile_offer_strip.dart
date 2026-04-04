import 'package:exotic/data/models/Homepage/elements/mobile_offer_strip.dart';
import 'package:exotic/utils/image_formatter.dart';
import 'package:flutter/material.dart';

class OfferStripCard extends StatelessWidget {
  final MobileOfferItem item;

  const OfferStripCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        debugPrint("Working");
      },
      child: SizedBox(
        width: 120,
        height: 80,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Card Container
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
                    /// Main Image
                    Container(
                      height: 140,
                      width: 140,
                      color: const Color(0xFFF9F9F9),
                      child: Image.memory(
                        base64ToBytes(item.image),
                        fit: BoxFit.contain,
                      ),
                    ),

                    /// AD Badge
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
                            color: Colors.black.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            item.badge,
                            style: const TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 9,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),

                    /// Offer Strip (Gradient)
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFFE94A75), Color(0xFFFF5252)],
                          ),
                        ),
                        child: Text(
                          item.offer,
                          style: const TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            /// Caption
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                item.caption,
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
      ),
    );
  }
}
