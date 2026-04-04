import 'package:exotic/Test/SearchProduct/utils/search_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/providers/search_product_provider.dart';
import 'widgets/search_results_grid.dart';

class SearchBarTesting extends StatefulWidget {
  const SearchBarTesting({super.key});

  @override
  State<SearchBarTesting> createState() => _SearchBarTestingState();
}

class _SearchBarTestingState extends State<SearchBarTesting> {
  late final SearchProductProvider _provider;

  @override
  void initState() {
    super.initState();
    _provider =
        SearchProductProvider()
          ..fetchInitialData()
          ..setSearchedItemsList(data: searchData);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _provider,
      child: Scaffold(
        appBar: AppBar(
          actions: const [],
          title: const Text("Search Bar Testing"),
        ),
        body: Consumer<SearchProductProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const SearchedItemsWidget(items: [], isLoading: true);
            }
            return SearchedItemsWidget(
              items: provider.filteredProductItems,
              filters: provider.searchedItemsList.filters,
              isLoading: provider.isLoading,
            );
          },
        ),
      ),
    );
  }
}

class SearchFieldComponent extends StatelessWidget {
  const SearchFieldComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (query) {
        context.read<SearchProductProvider>().searchLocal(query);
      },
      decoration: InputDecoration(
        hintText: 'Search...',
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
      ),
    );
  }
}
