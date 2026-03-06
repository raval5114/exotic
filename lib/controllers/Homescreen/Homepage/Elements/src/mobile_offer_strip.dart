import 'package:exotic/data/models/Homepage/elements/mobile_offer_strip.dart';
import 'package:exotic/utils/image_formatter.dart';
import 'package:flutter/material.dart';

class OfferStripCard extends StatelessWidget {
  final MobileOfferItem item;

  const OfferStripCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Card Container
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Stack(
              children: [
                /// Main Image
                Container(
                  height: 150,
                  width: 150,
                  color: Colors.grey.shade100,
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
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        item.badge,
                        style: const TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 10,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),

                /// Offer Strip
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFF3D57),
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(18),
                      ),
                    ),
                    child: Text(
                      item.offer,
                      style: const TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          /// Caption
          Text(
            item.caption,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
