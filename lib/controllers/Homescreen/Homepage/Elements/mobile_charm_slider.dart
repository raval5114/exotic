import 'package:exotic/controllers/Homescreen/Homepage/Elements/src/mobile_charm_card.dart';
import 'package:exotic/data/models/Homepage/elements/mobile_charm_slider.dart';
import 'package:flutter/material.dart';

class MobileCharmSliderWidget extends StatelessWidget {
  final MobileCharmSliderElement element;
  final String tabName;
  const MobileCharmSliderWidget({
    super.key,
    required this.element,
    required this.tabName,
  });

  Color _hexToColor(String hex) {
    if (hex.isEmpty) return Colors.transparent;
    hex = hex.replaceAll("#", "");
    if (hex.length == 6) hex = "FF$hex";
    return Color(int.parse(hex, radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    final config = element.config;
    final bgColor = _hexToColor(config.bgColor);
    final titleColor = _hexToColor(config.sectionTitleColor);

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        color: bgColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Section Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
              child: Row(
                children: [
                  if (config.sectionIcon.isNotEmpty) ...[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        config.sectionIcon,
                        height: 28,
                        width: 28,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                      ),
                    ),
                    const SizedBox(width: 10),
                  ],
                  Expanded(
                    child: Text(
                      "${config.sectionTitle} ${config.charm}",
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color:
                            titleColor.opacity > 0
                                ? titleColor
                                : const Color(0xFF111827),
                        letterSpacing: -0.3,
                      ),
                    ),
                  ),
                  // "See All" link
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
            ),

            const SizedBox(height: 8),

            /// Cards Slider
            SizedBox(
              height: 280,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: element.items.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final item = element.items[index];
                  return CharmCard(
                    item: item,
                    config: config,
                    title: element.title,
                    tabName: tabName,
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
