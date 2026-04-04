import 'package:exotic/controllers/Homescreen/Homepage/Elements/src/mobile_charm_card.dart';
import 'package:exotic/data/models/Homepage/elements/mobile_charm_slider.dart';
import 'package:flutter/material.dart';

class MobileCharmSliderWidget extends StatelessWidget {
  final MobileCharmSliderElement element;

  const MobileCharmSliderWidget({super.key, required this.element});

  Color _hexToColor(String hex) {
    if (hex.isEmpty) return Colors.transparent;
    hex = hex.replaceAll("#", "");
    if (hex.length == 6) hex = "FF$hex";
    return Color(int.parse(hex, radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    final config = element.config;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: _hexToColor(config.bgColor),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔥 Section Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Row(
              children: [
                if (config.sectionIcon.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      config.sectionIcon,
                      height: 30,
                      width: 30,
                    ),
                  ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    "${config.sectionTitle} ${config.charm}",
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: _hexToColor(config.sectionTitleColor),
                      letterSpacing: -0.2,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 0),

          /// 💖 Cards Slider
          SizedBox(
            height: 280,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: element.items.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final item = element.items[index];

                return CharmCard(item: item, config: config);
              },
            ),
          ),
        ],
      ),
    );
  }
}
