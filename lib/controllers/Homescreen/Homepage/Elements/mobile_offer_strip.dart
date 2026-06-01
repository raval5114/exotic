import 'package:exotic/controllers/Homescreen/Homepage/Elements/src/mobile_offer_strip.dart';
import 'package:exotic/data/models/Homepage/elements/mobile_offer_strip.dart';
import 'package:flutter/material.dart';

class MobileOfferStripWidget extends StatelessWidget {
  final MobileOfferStripElement element;

  const MobileOfferStripWidget({super.key, required this.element});

  Color _hexToColor(String hex) {
    if (hex.isEmpty) return Colors.transparent;
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) hex = 'FF$hex';
    return Color(int.parse(hex, radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _hexToColor(element.config.bgColor),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Section Header
          if (element.config.title.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    element.config.title,
                    style: const TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF111827),
                      letterSpacing: -0.3,
                    ),
                  ),
                  const Text(
                    "View All →",
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
          ],

          /// Horizontal Cards
          SizedBox(
            height: 185,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: element.items.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final item = element.items[index];
                return OfferStripCard(item: item);
              },
            ),
          ),
        ],
      ),
    );
  }
}
