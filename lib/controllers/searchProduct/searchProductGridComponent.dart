import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:exotic/data/providers/search_product_provider.dart';
import 'package:exotic/data/blocs/searchProduct/bloc/search_product_bloc.dart';
import 'package:exotic/Test/SearchProduct/widgets/search_results_grid.dart';

class SearchProductGridComponent extends StatefulWidget {
  const SearchProductGridComponent({super.key});

  @override
  State<SearchProductGridComponent> createState() =>
      _SearchProductGridComponentState();
}

class _SearchProductGridComponentState
    extends State<SearchProductGridComponent> {
  late final SearchProductProvider _provider;

  @override
  void initState() {
    super.initState();
    _provider = SearchProductProvider();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _provider,
      child: BlocConsumer<SearchProductBloc, SearchProductState>(
        listener: (context, state) {
          if (state is SearchProductSearchedDataState) {
            _provider.setSearchedItemsList(data: state.searchedProductData);
          }
        },
        builder: (context, state) {
          if (state is SearchProductLoadingState) {
            return const SearchedItemsWidget(items: [], isLoading: true);
          } else if (state is SearchProductSearchedDataState) {
            return Consumer<SearchProductProvider>(
              builder: (context, provider, child) {
                // Safeguard against uninitialized late variable since listener might trail slightly
                try {
                  final _ = provider.searchedItemsList;
                } catch (e) {
                  return const SearchedItemsWidget(items: [], isLoading: true);
                }

                return SearchedItemsWidget(
                  items: provider.filteredProductItems,
                  filters: provider.searchedItemsList.filters,
                  isLoading: provider.isLoading,
                );
              },
            );
          } else if (state is SearchErrorState) {
            return Center(child: Text(state.errMsg));
          }

          return const Center(child: Text("Search for a product"));
        },
      ),
    );
  }
}
