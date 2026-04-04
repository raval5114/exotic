import 'package:exotic/utils/image_formatter.dart';
import 'package:flutter/material.dart';
import 'package:exotic/data/models/Homepage/elements/mobile_sponsored_banner.dart';

class MobileSponsoredBannerWidget extends StatelessWidget {
  final MobileSponsoredBanner element;

  const MobileSponsoredBannerWidget({super.key, required this.element});

  double _parseHeight(String height) {
    final parsed = double.tryParse(height);
    return parsed ?? 150; // fallback height
  }

  @override
  Widget build(BuildContext context) {
    final item = element.item;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Section Title
        if (item.sectionTitle.isNotEmpty || element.title.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              item.sectionTitle.isNotEmpty ? item.sectionTitle : element.title,
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontSize: 20,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.2,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],

        /// Only Image Banner
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(24),
              onTap: () {
                // Navigate using item.linkUrl
                debugPrint("Sponsored Banner tapped");
              },
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Image.memory(
                      base64ToBytes(item.fullImg),
                      height: _parseHeight(item.bannerHeight),
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    bottom: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        "AD",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
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
