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
        /// Section Title (optional)
        if (item.sectionTitle.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              item.sectionTitle,
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

        const SizedBox(height: 12),

        /// Only Image Banner
        GestureDetector(
          onTap: () {
            // Navigate using item.linkUrl
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.memory(
              base64ToBytes(item.fullImg),
              height: _parseHeight(item.bannerHeight),
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }
}
