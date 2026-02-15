import 'package:exotic/data/models/Homepage/elements/Items/VerticalGridItem.dart';
import 'package:flutter/material.dart';
import 'package:exotic/data/models/Homepage/elements/product_grid_vertical.dart';

class ProductGridVerticalWidget extends StatefulWidget {
  final ProductGridVertical element;

  const ProductGridVerticalWidget({super.key, required this.element});

  @override
  State<ProductGridVerticalWidget> createState() =>
      _ProductGridVerticalWidgetState();
}

class _ProductGridVerticalWidgetState extends State<ProductGridVerticalWidget> {
  int selectedProductIndex = 0;
  int selectedImageIndex = 0;

  ProductGridVerticalItem get selectedItem =>
      widget.element.items[selectedProductIndex];

  @override
  Widget build(BuildContext context) {
    if (widget.element.items.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// TITLE + VIEW ALL
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.element.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (widget.element.config.viewAllLink.isNotEmpty)
                Text(
                  'View All →',
                  style: TextStyle(
                    color: Colors.purple.shade600,
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),
        ),

        /// SELECTED PRODUCT
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: _SelectedVerticalProduct(
            item: selectedItem,
            selectedImageIndex: selectedImageIndex,
            onImageChange: (index) {
              setState(() => selectedImageIndex = index);
            },
          ),
        ),

        const SizedBox(height: 12),

        /// ALL PRODUCTS LIST
        _VerticalProductSelector(
          items: widget.element.items,
          selectedIndex: selectedProductIndex,
          onSelect: (index) {
            setState(() {
              selectedProductIndex = index;
              selectedImageIndex = 0;
            });
          },
        ),
      ],
    );
  }
}

class _SelectedVerticalProduct extends StatelessWidget {
  final ProductGridVerticalItem item;
  final int selectedImageIndex;
  final ValueChanged<int> onImageChange;

  const _SelectedVerticalProduct({
    required this.item,
    required this.selectedImageIndex,
    required this.onImageChange,
  });

  @override
  Widget build(BuildContext context) {
    final images = [item.imageUrl, ...item.additionalImages];

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// MAIN IMAGE
            AspectRatio(
              aspectRatio: 1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  images[selectedImageIndex],
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(height: 8),

            /// IMAGE THUMBNAILS
            SizedBox(
              height: 60,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: images.length,
                separatorBuilder: (_, __) => const SizedBox(width: 6),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => onImageChange(index),
                    child: Container(
                      width: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color:
                              selectedImageIndex == index
                                  ? Colors.blueAccent
                                  : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Image.network(images[index], fit: BoxFit.cover),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 12),

            /// TITLE
            Text(
              item.title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),

            if (item.subtitle.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                item.subtitle,
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ],

            const SizedBox(height: 8),

            /// RATING
            Row(
              children: List.generate(
                5,
                (i) => Icon(
                  Icons.star,
                  size: 16,
                  color: i < item.rating ? Colors.amber : Colors.grey.shade300,
                ),
              ),
            ),

            const SizedBox(height: 8),

            /// PRICE ROW
            Row(
              children: [
                Text(
                  '₹${item.price}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '₹${item.originalPrice}% off',
                  style: const TextStyle(
                    decoration: TextDecoration.lineThrough,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    item.discount,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),

            if (item.notes.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                item.notes,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
            ],

            const SizedBox(height: 12),

            /// SEE MORE
            GestureDetector(
              onTap: () {
                // open item.linkUrl
              },
              child: const Text(
                'SEE MORE  →',
                style: TextStyle(
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VerticalProductSelector extends StatelessWidget {
  final List<ProductGridVerticalItem> items;
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  const _VerticalProductSelector({
    required this.items,
    required this.selectedIndex,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final isSelected = index == selectedIndex;

          return GestureDetector(
            onTap: () => onSelect(index),
            child: Container(
              width: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? Colors.blueAccent : Colors.transparent,
                  width: 2,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(items[index].imageUrl, fit: BoxFit.cover),
              ),
            ),
          );
        },
      ),
    );
  }
}
