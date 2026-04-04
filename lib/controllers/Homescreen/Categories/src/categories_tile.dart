import 'package:exotic/data/models/categories.dart';
import 'package:exotic/utils/cachedImage.dart';
import 'package:flutter/material.dart';

class CategoryTile extends StatelessWidget {
  final String title;
  final List<Category> products;
  const CategoryTile({super.key, required this.title, required this.products});

  @override
  Widget build(BuildContext context) {
    // ✅ If no products, return nothing
    if (products.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),

          // Static 2x3 grid layout (6 items max)
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            childAspectRatio: 0.75,
            children: List.generate(products.length.clamp(0, 6), (index) {
              final product = products[index];
              return Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: SizedBox(
                      width: 64,
                      height: 64,
                      child: AppCachedImage(
                        imageUrl: "${product.photo}",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  SizedBox(
                    width: 80, // adjust for your design
                    child: Text(
                      product.name,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}
