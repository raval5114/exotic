import 'package:exotic/controllers/Homescreen/Homepage/Elements/src/mobile_budget_deals_card.dart';
import 'package:exotic/data/models/Homepage/elements/mobile_budget_deals.dart';
import 'package:flutter/material.dart';

class MobileBudgetDealsComponent extends StatelessWidget {
  final MobileBudgetDealsElement element;

  const MobileBudgetDealsComponent({super.key, required this.element});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9), // Light mint green
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Section Title
          Text(
            element.config.sectionTitle.isNotEmpty
                ? element.config.sectionTitle
                : "Spotlight's on",
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontSize: 22,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.2,
              color: Colors.black,
            ),
          ),

          /// Grid Deals
          GridView.builder(
            itemCount: element.items.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.9,
            ),
            itemBuilder: (context, index) {
              final deal = element.items[index];
              return BudgetDealCard(deal: deal);
            },
          ),
        ],
      ),
    );
  }
}
