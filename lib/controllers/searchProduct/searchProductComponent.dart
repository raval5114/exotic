import 'package:exotic/controllers/searchProduct/searchProductDiscoverProduct.dart';
import 'package:exotic/controllers/searchProduct/searchProductPopularProduct.dart';
import 'package:exotic/controllers/searchProduct/searchProductRecentSearch.dart';
import 'package:exotic/controllers/searchProduct/searchQuerySectionComponent.dart';
import 'package:flutter/material.dart';

class SearchProductComponent extends StatefulWidget {
  const SearchProductComponent({super.key});

  @override
  State<SearchProductComponent> createState() => _SearchProductComponentState();
}

class _SearchProductComponentState extends State<SearchProductComponent> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        title: Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Theme.of(context).colorScheme.onSecondaryContainer,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Image.asset(
                'assets/icons/homescreen_searchbar_camera_icon.jpg',
                width: 20,
                height: 20,
              ),
              const SizedBox(width: 8),

              /// SEARCH QUERY COMPONENT
              Expanded(child: Searchquerysectioncomponent()),

              const SizedBox(width: 8),
              Image.asset(
                'assets/icons/homescreen_searchbar_mic_icon.jpg',
                width: 20,
                height: 20,
              ),
              const SizedBox(width: 8),
              Image.asset(
                'assets/icons/homescreen_searchbar_search_icon.jpg',
                width: 20,
                height: 20,
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.grey.shade300,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SearchProductRecentSearch(),
            SearchProductPopularProduct(),
            SearchProductDiscoverProduct(),
          ],
        ),
      ),
    );
  }
}
