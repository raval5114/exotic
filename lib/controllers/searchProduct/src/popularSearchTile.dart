import 'package:flutter/material.dart';

class SearchProductPopularProductTile extends StatelessWidget {
  final String imagePath;
  final String name;
  final String categorie;
  const SearchProductPopularProductTile({
    super.key,
    required this.imagePath,
    required this.name,
    required this.categorie,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final iconSize = width * 0.15;

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_bag,
            size: iconSize,
            color: Theme.of(context).colorScheme.secondary,
          ),
          const SizedBox(height: 12),
          Text(
            "${name}",
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            "$categorie",
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w300,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
