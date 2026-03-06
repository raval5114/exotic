import 'package:exotic/controllers/Homescreen/Homepage/Elements/src/mobile_offer_strip.dart';
import 'package:exotic/data/models/Homepage/elements/mobile_offer_strip.dart';
import 'package:flutter/material.dart';

class MobileOfferStripWidget extends StatelessWidget {
  final MobileOfferStripElement element;

  const MobileOfferStripWidget({super.key, required this.element});

  Color _hexToColor(String hex) {
    if (hex.isEmpty) return Colors.transparent;
    hex = hex.replaceAll("#", "");
    if (hex.length == 6) hex = "FF$hex";
    return Color(int.parse(hex, radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: _hexToColor(element.config.bgColor),
      ),
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Section Title (optional)
          if (element.config.title.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                element.config.title,
                style: const TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),

          const SizedBox(height: 14),

          /// Horizontal Cards
          SizedBox(
            height: 180,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: element.items.length,
              separatorBuilder: (_, __) => const SizedBox(width: 14),
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
