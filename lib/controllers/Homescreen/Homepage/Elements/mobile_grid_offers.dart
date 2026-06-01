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
    final bgColor = _hexToColor(element.config.bgColor);

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        color: bgColor,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Section Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      element.config.title,
                      style: const TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF1F2937),
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      "Handpicked deals for you",
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 12,
                        color: Colors.black45,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                // Decorative sticky-note element
                Transform.rotate(
                  angle: 0.15,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF08A),
                      borderRadius: BorderRadius.circular(6),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 6,
                          offset: const Offset(2, 3),
                        ),
                      ],
                    ),
                    child: const Text(
                      "🔥",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            /// White Inner Grid Container
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
                  childAspectRatio: 0.72,
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
    );
  }
}
