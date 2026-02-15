import 'package:exotic/data/models/Homepage/elements/Items/GridItem.dart';
import 'package:exotic/data/models/Homepage/elements/Product_grid.dart';
import 'package:flutter/material.dart';

class ProductGridWidget extends StatelessWidget {
  final ProductGrid grid;

  const ProductGridWidget({super.key, required this.grid});

  @override
  Widget build(BuildContext context) {
    if (grid.items.isEmpty) return const SizedBox();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Header(title: grid.title, viewAllLink: grid.config.viewAllLink),

          const SizedBox(height: 12),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: grid.items.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.65,
            ),
            itemBuilder: (context, index) {
              return _ProductCard(item: grid.items[index]);
            },
          ),
        ],
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Griditem item;

  const _ProductCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () {
        // TODO: open item.link_url
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🖼 Image Container
          Container(
            height: 110,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(14),
            ),
            padding: const EdgeInsets.all(10),
            child: Image.network(item.image_url, fit: BoxFit.contain),
          ),

          const SizedBox(height: 8),

          // 🏷 Title
          Text(
            item.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          ),

          const SizedBox(height: 4),

          // 💰 Subtitle (price / info)
          if (item.subtitle.isNotEmpty)
            Text(
              item.subtitle,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final String title;
  final String viewAllLink;

  const _Header({required this.title, required this.viewAllLink});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),

          if (viewAllLink.isNotEmpty)
            InkWell(
              onTap: () {
                // TODO: navigate to viewAllLink
              },
              child: const Icon(Icons.chevron_right, size: 26),
            ),
        ],
      ),
    );
  }
}
