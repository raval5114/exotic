import 'package:exotic/controllers/Homescreen/Categories/src/categories_tile.dart';
import 'package:exotic/data/providers/categories_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SubCategoriesBuilder extends StatefulWidget {
  const SubCategoriesBuilder({super.key});

  @override
  State<SubCategoriesBuilder> createState() => _SubCategoriesBuilderState();
}

class _SubCategoriesBuilderState extends State<SubCategoriesBuilder> {
  @override
  Widget build(BuildContext context) {
    return Consumer<CategoriesProvider>(
      builder: (context, provider, child) {
        final currentCategory = provider.currentCategory;

        if (currentCategory == null) {
          return const Center(child: Text("No category selected"));
        }

        // Get subcategories for selected category
        final subcategories = provider.getChildren(currentCategory.id);

        // Filter out subcategories with no children
        final validSubcategories =
            subcategories
                .where((subcat) => provider.getChildren(subcat.id).isNotEmpty)
                .toList();

        if (validSubcategories.isEmpty) {
          return const Center(child: Text("No subcategories available"));
        }

        return ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: validSubcategories.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final subcat = validSubcategories[index];
            final products = provider.getChildren(subcat.id);

            return CategoryTile(
              id: int.parse(subcat.catIds!),
              title: subcat.name,
              products: products,
            );
          },
        );
      },
    );
  }
}
