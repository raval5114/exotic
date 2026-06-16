import 'package:exotic/Test/HomepagesTesting/model/interactions/elements/exoticHomepageElement.dart';
import 'package:exotic/Test/HomepagesTesting/model/interactions/providers/interaction_provider.dart';
import 'package:exotic/data/models/Homepage/elements/Items/mobile_category_grid_items.dart';
import 'package:exotic/data/models/Homepage/elements/mobile_category_strip.dart';
import 'package:exotic/utils/image_formatter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MobileCategoryGridComponent extends StatelessWidget {
  final MobileCategoryGridElement element;
  final String tabName;
  //final String title;
  const MobileCategoryGridComponent({
    super.key,
    required this.element,
    required this.tabName,
    // required this.title,
  });

  @override
  Widget build(BuildContext context) {
    const double spacing = 10;
    const int rowCount = 2;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        if (element.title.isNotEmpty) ...[
          Text(
            element.title,
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Color(0xFF111827),
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 14),
        ],

        LayoutBuilder(
          builder: (context, constraints) {
            final totalWidth = constraints.maxWidth;

            // Dynamically size items to remove empty space on the right
            final int columns = (element.items.length / rowCount).ceil();
            final double itemsPerRow = columns <= 4 ? columns.toDouble() : 4.5;
            final availableWidth = totalWidth - (spacing * (itemsPerRow - 1));
            final itemWidth = availableWidth / itemsPerRow;
            const itemHeight = 88.0;

            return SizedBox(
              height: (itemHeight * rowCount) + spacing,
              child: GridView.builder(
                padding: EdgeInsets.zero,
                scrollDirection: Axis.horizontal,
                itemCount: element.items.length,
                physics: const BouncingScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: rowCount,
                  crossAxisSpacing: spacing,
                  mainAxisSpacing: spacing,
                  childAspectRatio: itemHeight / itemWidth,
                ),
                itemBuilder: (context, index) {
                  return _ScrollableCategoryItem(
                    item: element.items[index],
                    tab: tabName,
                    title: element.title,
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}

class _ScrollableCategoryItem extends StatelessWidget {
  final MobileCategoryGridItems item;
  final String tab;
  final String title;
  const _ScrollableCategoryItem({
    required this.item,
    required this.tab,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<InteractionTestProvider>().addInteraction(
          ExotichomepageElement(
            createdAt: DateTime.now().toString(),
            interactionId: 1,
            interactionType: "homepage-element",
            updatedAt: DateTime.now().toString(),
            elementName: title,
            elementType: "mobile-category-grid",
            tabBarName: tab,
          ),
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: const Color(0xFFF5F3FF),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF7C3AED).withOpacity(0.06),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.memory(
                base64ToBytes(item.img),
                fit: BoxFit.cover,
                errorBuilder:
                    (_, __, ___) => const Icon(
                      Icons.category_rounded,
                      size: 22,
                      color: Color(0xFF7C3AED),
                    ),
              ),
            ),
          ),
          const SizedBox(height: 7),
          Text(
            item.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Color(0xFF374151),
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
