import 'package:go_router/go_router.dart';
import 'package:exotic/controllers/searchProduct/searchProductGridComponent.dart';
import 'package:flutter/material.dart';

class SearchedProductScreen extends StatelessWidget {
  const SearchedProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Premium off-white background
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
        title: const Text(
          "Search Results",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 20,
            letterSpacing: 0.5,
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
      body: const SafeArea(child: SearchProductGridComponent()),
    );
  }
}
