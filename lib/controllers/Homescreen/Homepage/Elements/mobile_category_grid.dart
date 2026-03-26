import 'package:exotic/data/models/Homepage/elements/mobile_category_strip.dart';
import 'package:exotic/utils/image_formatter.dart';
import 'package:flutter/material.dart';

class MobileCategoryGridComponent extends StatelessWidget {
  final MobileCategoryGridElement element;

  const MobileCategoryGridComponent({super.key, required this.element});

  @override
  Widget build(BuildContext context) {
    const double horizontalPadding = 0;
    const double spacing = 5;
    const int itemsPerRow = 5;
    const int rowCount = 2;

    return LayoutBuilder(
      builder: (context, constraints) {
        final totalWidth = constraints.maxWidth;
        final availableWidth =
            totalWidth -
            (horizontalPadding * 2) -
            (spacing * (itemsPerRow - 1));

        final itemWidth = availableWidth / itemsPerRow;
        final itemHeight = itemWidth * 1.25; // controls vertical size

        return SizedBox(
          height: (itemHeight * rowCount) + spacing,
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
            scrollDirection: Axis.horizontal,
            itemCount: element.items.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: rowCount, // 2 rows
              crossAxisSpacing: spacing,
              mainAxisSpacing: spacing,
              childAspectRatio: itemWidth / itemHeight,
            ),
            itemBuilder: (context, index) {
              return _ScrollableCategoryItem(item: element.items[index]);
            },
          ),
        );
      },
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
        Expanded(
          flex: 4,
          child: Container(
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                )
              ]
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.memory(
                base64ToBytes(item.img),
                fit: BoxFit.cover,
                height: 2,
                errorBuilder:
                    (_, __, ___) =>
                        const Icon(Icons.image_not_supported, size: 18, color: Colors.grey),
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Expanded(
          flex: 1,
          child: Text(
            item.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontSize: 12,
              fontWeight: FontWeight.w500,
              height: 1.1,
            ),
          ),
        ),
      ],
    );
  }
}
