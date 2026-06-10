import 'package:exotic/data/models/Interaction/abtract/interaction_shell.dart';
import 'package:exotic/data/models/categories.dart';
import 'package:exotic/data/providers/interaction_provider.dart';
import 'package:exotic/utils/cachedImage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CategoryTile extends StatelessWidget {
  final int id;
  final String title;
  final List<Category> products;
  const CategoryTile({
    super.key,
    required this.id,
    required this.title,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    // If no products, return nothing
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

          Wrap(
            spacing: 12,
            runSpacing: 20,
            children: List.generate(products.length.clamp(0, 6), (index) {
              final product = products[index];
              return InkWell(
                onTap: () {
                  context.read<InteractionProvider>().addInteraction(
                    interactionType: InteractionType.categoryChildItem,
                    pageName: 'category-child-item:${product.name}',
                  );
                  context.push(
                    "/ProductsViewer",
                    extra: {
                      "url": "/search_products.php?category_id=${product.id}",
                      "title": product.name,
                    },
                  );
                },
                child: SizedBox(
                  width: 66,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: AppCachedImage(
                            imageUrl: "${product.photo}",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        product.name,
                        textAlign: TextAlign.center,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 9.5,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
