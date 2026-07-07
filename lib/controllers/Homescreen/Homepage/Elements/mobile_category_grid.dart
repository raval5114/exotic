import 'package:exotic/Test/HomepagesTesting/model/interactions/elements/exoticHomepageElement.dart';
import 'package:exotic/Test/HomepagesTesting/model/interactions/providers/interaction_provider.dart';
import 'package:exotic/data/models/Homepage/elements/Items/mobile_category_grid_items.dart';
import 'package:exotic/data/models/Homepage/elements/mobile_category_strip.dart';
import 'package:exotic/utils/image_formatter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class MobileCategoryGridComponent extends StatelessWidget {
  final MobileCategoryGridElement element;
  final String tabName;

  const MobileCategoryGridComponent({
    super.key,
    required this.element,
    required this.tabName,
  });

  @override
  Widget build(BuildContext context) {
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

        _buildScrollableGrid(context),
      ],
    );
  }

  /// Horizontally scrollable 2-row grid — items flow left→right,
  /// row 1 fills first, then row 2. Max 2 rows, unlimited columns.
  Widget _buildScrollableGrid(BuildContext context) {
    const double itemSpacing = 5.0;
    const double imageSize = 70.0;
    const double labelHeight = 18.0;
    const double itemHeight =
        imageSize + 4 + labelHeight; // image + gap + label
    const double itemWidth = 72.0;

    final items = element.items;
    final int total = items.length;

    // Split items: row1 gets ceil(total/2), row2 gets the rest
    // so they fill left-to-right
    final int row1Count = (total / 2).ceil();
    final int row2Count = total - row1Count;

    List<Widget> buildRow(int startIndex, int count) {
      return List.generate(count, (i) {
        final index = startIndex + i;
        return Padding(
          padding: EdgeInsets.only(right: i < count - 1 ? itemSpacing : 0),
          child: SizedBox(
            width: itemWidth,
            child: _ScrollableCategoryItem(
              item: items[index],
              tab: tabName,
              title: element.title,
            ),
          ),
        );
      });
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Row 1
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: buildRow(0, row1Count),
          ),
          if (row2Count > 0) ...[
            const SizedBox(height: itemSpacing),
            // Row 2
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: buildRow(row1Count, row2Count),
            ),
          ],
        ],
      ),
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
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          /// Image tile — fixed height with rounded corners
          SizedBox(
            height: 70,
            width: double.infinity,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(7),
              child: _buildImage(),
            ),
          ),

          const SizedBox(height: 4),

          /// Category label
          Text(
            item.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: Color(0xFF111827),
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage() {
    if (item.img.isEmpty) return _placeholder();

    try {
      final bytes = base64ToBytes(item.img);
      return Image.memory(
        bytes,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (_, __, ___) => _placeholder(),
      );
    } catch (_) {
      // If base64 decoding fails, try treating as a URL or asset
      final src = item.img;
      if (src.startsWith('http://') || src.startsWith('https://')) {
        return Image.network(
          src,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          errorBuilder: (_, __, ___) => _placeholder(),
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return _shimmerBox();
          },
        );
      }
      return Image.asset(
        src,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (_, __, ___) => _placeholder(),
      );
    }
  }

  Widget _placeholder() {
    return Container(
      color: const Color(0xFFF3F4F6),
      child: const Center(
        child: Icon(Icons.category_rounded, color: Color(0xFF9CA3AF), size: 26),
      ),
    );
  }

  Widget _shimmerBox() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade200,
      highlightColor: Colors.grey.shade50,
      child: Container(color: Colors.white),
    );
  }
}
