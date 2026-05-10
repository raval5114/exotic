import 'package:exotic/data/models/Homepage/elements/mobile_category_strip.dart';
import 'package:exotic/utils/image_formatter.dart';
import 'package:flutter/material.dart';

class MobileCategoryGridComponent extends StatelessWidget {
  final MobileCategoryGridElement element;

  const MobileCategoryGridComponent({super.key, required this.element});

  @override
  Widget build(BuildContext context) {
    const double horizontalPadding = 12;
    const double spacing = 10;
    const int rowCount = 2;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final totalWidth = constraints.maxWidth;
              
              // Dynamically size items to remove empty space on the right
              final int columns = (element.items.length / rowCount).ceil();
              final double itemsPerRow = columns <= 4 ? columns.toDouble() : 4.5;
              final availableWidth = totalWidth - (horizontalPadding * 2) - (spacing * (itemsPerRow - 1));
              final itemWidth = availableWidth / itemsPerRow;
              final itemHeight = 84.0; // Fit content completely tightly

              return SizedBox(
                height: (itemHeight * rowCount) + spacing,
                child: GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
                  scrollDirection: Axis.horizontal,
                  itemCount: element.items.length,
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: rowCount, // 2 rows
                    crossAxisSpacing: spacing,
                    mainAxisSpacing: spacing,
                    childAspectRatio: itemHeight / itemWidth, // crossAxis/mainAxis for horizontal list
                  ),
                  itemBuilder: (context, index) {
                    return _ScrollableCategoryItem(item: element.items[index]);
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ScrollableCategoryItem extends StatelessWidget {
  final dynamic item;

  const _ScrollableCategoryItem({required this.item});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: const Color(0xFFF5F5F5), // subtle off-white background
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
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
                  (_, __, ___) =>
                      const Icon(Icons.category_rounded, size: 24, color: Colors.grey),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          item.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: 'Roboto',
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
            height: 1.1,
          ),
        ),
      ],
    );
  }
}
