
import 'package:exotic/controllers/Homescreen/Homepage/Elements/src/mobile_offer_card.dart';
import 'package:exotic/data/models/Homepage/elements/mobile_grid_offer.dart';
import 'package:flutter/material.dart';

class MobileGridOffersWidget extends StatelessWidget {
  final MobileGridOffersElement element;

  const MobileGridOffersWidget({super.key, required this.element});

  Color _hexToColor(String hex) {
    if (hex.isEmpty) return Colors.transparent;
    hex = hex.replaceAll("#", "");
    if (hex.length == 6) hex = "FF$hex";
    return Color(int.parse(hex, radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _hexToColor(element.config.bgColor),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// 🔥 Section Title
                Text(
                  element.config.title,
                  style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF1F2937), // Dark grey/blue color from image 2
                    letterSpacing: -0.2,
                  ),
                ),

                const SizedBox(height: 12),

          /// White Inner Container
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: element.items.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.70, // adjusted to reduce bottom empty space
              ),
              itemBuilder: (context, index) {
                final item = element.items[index];
                return OfferGridCard(item: item);
              },
            ),
          ),
        ],
      ),
          ),
          Positioned(
            top: 12,
            right: 12,
            child: Transform.rotate(
              angle: 0.15, // Rotate slightly
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF08A), // Light yellow sticky note
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                      offset: const Offset(2, 4),
                    ),
                  ],
                ),
                child: const Text(
                  "?",
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFFE11D48), // Red question mark
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
