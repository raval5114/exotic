import 'package:exotic/controllers/ProductViewer/productViewer.dart';
import 'package:exotic/controllers/searchProduct/searchQuerySectionComponent.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProductViewer extends StatelessWidget {
  final String url;
  final String title;
  const ProductViewer({super.key, required this.url, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 8,
        shadowColor: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 20,
            color: Colors.white,
          ),
          onPressed: () => context.pop(),
          splashRadius: 24,
        ),
        title: Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 16,
            letterSpacing: 0.3,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white, size: 22),
            onPressed: () => context.pop(),
            splashRadius: 24,
            tooltip: 'Search Again',
          ),
          const SizedBox(width: 4),
        ],
      ),

      body: ProductViewerComponent(url: url),
    );
  }
}
