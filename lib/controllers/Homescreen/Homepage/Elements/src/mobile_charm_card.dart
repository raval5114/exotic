import 'package:exotic/data/models/Homepage/elements/configs/mobile_charm_slider_config.dart';
import 'package:exotic/utils/image_formatter.dart';
import 'package:flutter/material.dart';

class CharmCard extends StatelessWidget {
  final dynamic item;
  final MobileCharmSliderConfig config;

  const CharmCard({super.key, required this.item, required this.config});

  Color _hexToColor(String hex) {
    if (hex.isEmpty) return Colors.transparent;
    hex = hex.replaceAll("#", "");
    if (hex.length == 6) hex = "FF$hex";
    return Color(int.parse(hex, radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    final borderColor = _hexToColor(config.borderColor);
    final stackedColor = _hexToColor(config.stackedBgColor);
    final textColor = _hexToColor(config.cardTextColor);
    final backgroundColor = _hexToColor(config.bgColor);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          debugPrint("Charm item tapped: ${item.title}");
        },
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.bottomCenter,
          children: [
            // Rotated stacked background effect (Image 2 style)
            Transform.rotate(
              angle: -0.06, // Slight counter-clockwise rotation
              child: Container(
                width: 180,
                height: 260,
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: stackedColor.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
            ),
            // Main Card
            Container(
              width: 180,
              height: 260,
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: backgroundColor, // Should be pinkish based on config
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: borderColor, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Top decoration (Little hearts)
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Row(
                      children: List.generate(
                        3,
                        (index) => const Padding(
                          padding: EdgeInsets.only(right: 4),
                          child: Icon(
                            Icons.favorite,
                            color: Colors.redAccent,
                            size: 14,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Main content column
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 25), // Space for top hearts
                      // Image Section
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: borderColor.withOpacity(0.5),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.memory(
                                  base64ToBytes(item.img),
                                  width: double.infinity,
                                  height: double.infinity,
                                  fit: BoxFit.fill,
                                ),
                              ),
                              // Floating decorative hearts
                              Positioned(
                                top: 50,
                                left: -10,
                                child: Text(config.charm),
                              ),
                              const Positioned(
                                bottom: 50,
                                right: -10,
                                child: Icon(
                                  Icons.favorite,
                                  color: Colors.redAccent,
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Text Section
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            // Title
                            Expanded(
                              child: Text(
                                item.title.toUpperCase(),
                                maxLines: 2,
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                  height: 1.0,
                                  color: textColor,
                                  letterSpacing: -0.2,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            // Price
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "FROM",
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: textColor.withOpacity(0.8),
                                  ),
                                ),
                                Text(
                                  item.price,
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                    color: textColor,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
