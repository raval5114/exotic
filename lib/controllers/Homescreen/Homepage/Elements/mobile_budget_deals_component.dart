import 'package:exotic/controllers/Homescreen/Homepage/Elements/src/mobile_budget_deals_card.dart';
import 'package:exotic/data/models/Homepage/elements/mobile_budget_deals.dart';
import 'package:flutter/material.dart';

class MobileBudgetDealsComponent extends StatelessWidget {
  final MobileBudgetDealsElement element;

  const MobileBudgetDealsComponent({super.key, required this.element});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Section Title
        Text(
          element.config.sectionTitle.isNotEmpty
              ? element.config.sectionTitle
              : element.title,
          style: const TextStyle(
            fontFamily: 'Roboto',
            fontSize: 20,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
          ),
        ),

        /// Grid Deals
        GridView.builder(
          itemCount: element.items.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 10,
            childAspectRatio: 1,
          ),
          itemBuilder: (context, index) {
            final deal = element.items[index];
            return BudgetDealCard(deal: deal);
          },
        ),
      ],
    );
  }
}
