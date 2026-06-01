import 'package:exotic/controllers/Homescreen/Homepage/Elements/src/mobile_featured_card.dart';
import 'package:exotic/data/models/Homepage/elements/mobile_feature_slider.dart';
import 'package:flutter/material.dart';

class MobileFeaturedSliderWidget extends StatelessWidget {
  final MobileFeaturedSliderElement element;

  const MobileFeaturedSliderWidget({super.key, required this.element});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Section Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              element.config.sectionTitle,
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Color(0xFF111827),
                letterSpacing: -0.3,
              ),
            ),
            const Text(
              "See All →",
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF7C3AED),
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        /// Horizontal Cards
        SizedBox(
          height: 185,
          child: ListView.separated(
            padding: EdgeInsets.zero,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: element.items.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final item = element.items[index];
              return FeaturedCard(item: item);
            },
          ),
        ),
      ],
    );
  }
}
