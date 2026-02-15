import 'package:flutter/material.dart';
import 'package:exotic/data/models/Homepage/elements/Items/VerticalGridItem2.dart';

class ProductGridVertical2Widget extends StatefulWidget {
  final List<ProductGridVertical2Item> products;

  const ProductGridVertical2Widget({super.key, required this.products});

  @override
  State<ProductGridVertical2Widget> createState() =>
      _ProductGridVertical2WidgetState();
}

class _ProductGridVertical2WidgetState
    extends State<ProductGridVertical2Widget> {
  int selectedIndex = 0;

  ProductGridVertical2Item get selectedProduct =>
      widget.products[selectedIndex];

  @override
  Widget build(BuildContext context) {
    if (widget.products.isEmpty) return const SizedBox();

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SelectedProductView(product: selectedProduct),
            const SizedBox(height: 12),
            _ProductThumbnailList(
              products: widget.products,
              selectedIndex: selectedIndex,
              onTap: (index) {
                setState(() => selectedIndex = index);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _SelectedProductView extends StatelessWidget {
  final ProductGridVertical2Item product;

  const _SelectedProductView({required this.product});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// IMAGE
        AspectRatio(
          aspectRatio: 1,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(product.imageUrl, fit: BoxFit.cover),
          ),
        ),

        const SizedBox(height: 12),

        /// TITLE
        Text(
          product.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),

        const SizedBox(height: 6),

        /// DESCRIPTION
        Text(
          product.shortDescription,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: Colors.grey.shade600),
        ),

        const SizedBox(height: 8),

        /// RATING
        Row(
          children: [
            const Icon(Icons.star, color: Colors.amber, size: 16),
            const SizedBox(width: 4),
            Text(
              product.rating.average.toStringAsFixed(1),
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(width: 4),
            Text(
              '(${product.rating.count})',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        ),

        const SizedBox(height: 8),

        /// PRICE
        Row(
          children: [
            Text(
              '₹${product.price.sellingPrice.toStringAsFixed(0)}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 8),
            Text(
              '₹${product.price.mrpPrice.toStringAsFixed(0)}',
              style: const TextStyle(
                decoration: TextDecoration.lineThrough,
                color: Colors.grey,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.blueAccent.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${product.price.discountPercentage}% off',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        /// SEE MORE
        GestureDetector(
          onTap: () {
            // navigate using product.url
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
    );
  }
}

class _ProductThumbnailList extends StatelessWidget {
  final List<ProductGridVertical2Item> products;
  final int selectedIndex;
  final Function(int) onTap;

  const _ProductThumbnailList({
    required this.products,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: products.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final product = products[index];
          final isSelected = index == selectedIndex;

          return GestureDetector(
            onTap: () => onTap(index),
            child: Container(
              width: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isSelected ? Colors.purple : Colors.transparent,
                  width: 2,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(product.imageUrl, fit: BoxFit.cover),
              ),
            ),
          );
        },
      ),
    );
  }
}
