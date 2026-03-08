import 'package:exotic/data/models/Homepage/elements/Items/mobile_budget_deals_items.dart';
import 'package:exotic/utils/image_formatter.dart';
import 'package:flutter/material.dart';

class BudgetDealCard extends StatelessWidget {
  final MobileBudgetDealItem deal;

  const BudgetDealCard({required this.deal});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () {
        // TODO: navigate using deal.url
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            /// Background Image
            Positioned.fill(
              child: Image.memory(
                base64ToBytes(deal.img),
                fit: BoxFit.cover,
                errorBuilder:
                    (_, __, ___) =>
                        const Center(child: Icon(Icons.image_not_supported)),
              ),
            ),

            /// Soft Overlay for readability
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0.15),
                      Colors.black.withOpacity(0.05),
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
              ),
            ),

            /// Price Text
            Positioned(
              top: 16,
              left: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    deal.label.toUpperCase(), // e.g., UNDER
                    style: const TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "₹${deal.price}",
                    style: const TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                      color: Colors.white,
                    ),
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
