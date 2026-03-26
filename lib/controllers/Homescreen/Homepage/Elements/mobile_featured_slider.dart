import 'package:exotic/controllers/Homescreen/Homepage/Elements/src/mobile_featured_card.dart';
import 'package:exotic/data/models/Homepage/elements/mobile_feature_slider.dart';
import 'package:flutter/material.dart';

class MobileFeaturedSliderWidget extends StatelessWidget {
  final MobileFeaturedSliderElement element;

  const MobileFeaturedSliderWidget({super.key, required this.element});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔥 Section Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              element.config.sectionTitle,
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          const SizedBox(height: 16),

          /// 🎯 Horizontal Cards
          SizedBox(
            height: 180,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: element.items.length,
              separatorBuilder: (_, __) => const SizedBox(width: 14),
              itemBuilder: (context, index) {
                //debugPrint(element.items[index].img);
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
