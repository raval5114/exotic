import 'package:exotic/utils/image_formatter.dart';
import 'package:flutter/material.dart';
import 'package:exotic/data/models/Homepage/elements/mobile_sponsored_banner.dart';

class MobileSponsoredBannerWidget extends StatelessWidget {
  final MobileSponsoredBanner element;

  const MobileSponsoredBannerWidget({super.key, required this.element});

  double _parseHeight(String height) {
    final parsed = double.tryParse(height);
    return parsed ?? 160;
  }

  @override
  Widget build(BuildContext context) {
    final item = element.item;
    final double bannerHeight = _parseHeight(item.bannerHeight);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Section Title
        if (item.sectionTitle.isNotEmpty || element.title.isNotEmpty) ...[
          Text(
            item.sectionTitle.isNotEmpty ? item.sectionTitle : element.title,
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontSize: 18,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.3,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 12),
        ],

        /// Sponsored Banner with overlay
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () {
                debugPrint("Sponsored Banner tapped");
              },
              child: Stack(
                children: [
                  Image.memory(
                    base64ToBytes(item.fullImg),
                    height: bannerHeight,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  // Gradient overlay for better readability
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.15),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // AD Badge
                  Positioned(
                    bottom: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.45),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: const Text(
                        "AD",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
