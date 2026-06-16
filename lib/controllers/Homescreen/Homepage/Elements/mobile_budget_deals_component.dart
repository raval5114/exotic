import 'package:exotic/Test/HomepagesTesting/model/interactions/elements/exoticHomepageElement.dart';
import 'package:exotic/Test/HomepagesTesting/model/interactions/providers/interaction_provider.dart';
import 'package:exotic/controllers/Homescreen/Homepage/Elements/src/mobile_budget_deals_card.dart';
import 'package:exotic/data/models/Homepage/elements/mobile_budget_deals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MobileBudgetDealsComponent extends StatelessWidget {
  final MobileBudgetDealsElement element;
  final String tabName;
  const MobileBudgetDealsComponent({
    super.key,
    required this.element,
    required this.tabName,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Section Header Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    element.config.sectionTitle.isNotEmpty
                        ? element.config.sectionTitle
                        : "Spotlight's On",
                    style: const TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.3,
                      color: Color(0xFF111827),
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    "Curated picks just for you",
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Colors.black45,
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                // context.read<InteractionProvider>().addInteraction(
                //   interactionType: InteractionType.mobileBudgetDeals,
                //   pageName:
                //       "Homepage/budget-deals/${element.config.sectionTitle.trim()}",
                // );
                context.read<InteractionTestProvider>().addInteraction(
                  ExotichomepageElement(
                    createdAt: DateTime.now().toString(),
                    interactionId: 1,
                    interactionType: "homepage-element",
                    updatedAt: DateTime.now().toString(),
                    elementName: "${element.title}",
                    elementType: "mobile-budget-deals",
                    tabBarName: tabName,
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF7C3AED), width: 1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  "See All",
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF7C3AED),
                  ),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        /// Grid Deals
        GridView.builder(
          itemCount: element.items.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.88,
          ),
          itemBuilder: (context, index) {
            final deal = element.items[index];
            return BudgetDealCard(
              deal: deal,
              title: element.title,
              tabName: tabName,
            );
          },
        ),
      ],
    );
  }
}
