import 'package:exotic/controllers/Homescreen/Homepage/Elements/src/mobile_featured_card.dart';
import 'package:exotic/data/models/Homepage/elements/mobile_feature_slider.dart';
import 'package:flutter/material.dart';

class MobileFeaturedSliderWidget extends StatelessWidget {
  final MobileFeaturedSliderElement element;

  const MobileFeaturedSliderWidget({super.key, required this.element});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔥 Section Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              element.config.sectionTitle,
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Colors.black,
                letterSpacing: -0.2,
              ),
            ),
          ),

          const SizedBox(height: 20),

          /// 🎯 Horizontal Cards
          SizedBox(
            height: 170,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: element.items.length,
              separatorBuilder: (_, __) => const SizedBox(width: 14),
              itemBuilder: (context, index) {
                final item = element.items[index];
                return FeaturedCard(item: item);
              },
            ),
          ),
        ],
      ),
    );
  }
}
