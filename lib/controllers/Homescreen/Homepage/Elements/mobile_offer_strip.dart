import 'package:exotic/controllers/Homescreen/Homepage/Elements/src/mobile_offer_strip.dart';
import 'package:exotic/data/models/Homepage/elements/mobile_offer_strip.dart';
import 'package:flutter/material.dart';

class MobileOfferStripWidget extends StatelessWidget {
  final MobileOfferStripElement element;

  const MobileOfferStripWidget({super.key, required this.element});

  Color _hexToColor(String hex) {
    if (hex.isEmpty) return Colors.transparent;
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) {
      hex = 'FF$hex'; // default opacity
    }
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
          /// Section Title (optional)
          if (element.config.title.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: Text(
                element.config.title,
                style: const TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                  letterSpacing: -0.2,
                ),
              ),
            ),

          /// Horizontal Cards
          SizedBox(
            height: 170, // Increased height for better fit
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
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
