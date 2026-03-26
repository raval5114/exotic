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
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔥 Section Title
          Row(
            children: [
              if (config.sectionIcon.isNotEmpty)
                Image.network(config.sectionIcon, height: 26, width: 26),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  "${config.sectionTitle} ${config.charm}",
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: _hexToColor(config.sectionTitleColor),
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          /// 💖 Cards Slider
          SizedBox(
            height: 310,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              scrollDirection: Axis.horizontal,
              itemCount: element.items.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                final item = element.items[index];

                return CharmCard(
                  item: item,
                  borderColor: _hexToColor(config.borderColor),
                  stackedColor: _hexToColor(config.stackedBgColor),
                  textColor: _hexToColor(config.cardTextColor),
                  backgroud_color: _hexToColor(config.bgColor),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
