import 'dart:math';
import 'package:exotic/controllers/ProductViewer/src/ProductViewerCard.dart';
import 'package:go_router/go_router.dart';
import 'package:exotic/view/widgets/searched_items_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:exotic/data/providers/search_product_provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:exotic/data/blocs/cart/bloc/cart_bloc.dart';
import 'package:exotic/controllers/src/ad_blocks/widgets/ad_block.dart';

class ProductViewerItemsWidget extends StatelessWidget {
  final List<SearchedItems> items;
  final Filters? filters;
  final bool isLoading;

  const ProductViewerItemsWidget({
    Key? key,
    required this.items,
    this.filters,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SearchProductProvider>();

    if (isLoading) {
      return Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: GridView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: 8,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.7,
          ),
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
            );
          },
        ),
      );
    }

    // Apply filters locally to the items list
    var filteredItems = items;
    if (provider.selectedCategory != null) {
      filteredItems =
          filteredItems
              .where((item) => item.category == provider.selectedCategory)
              .toList();
    }
    if (provider.selectedBrand != null) {
      filteredItems =
          filteredItems
              .where((item) => item.brand == provider.selectedBrand)
              .toList();
    }

    return BlocListener<CartBloc, CartState>(
      listener: (context, state) {
        if (state is CartAddingSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Item added to cart successfully")),
          );
        } else if (state is CartErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errMsg ?? "Failed to add item")),
          );
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (filters != null) _buildFilters(context),
          if (filteredItems.isEmpty)
            const Expanded(
              child: Center(
                child: Text('No products found matching the filters.'),
              ),
            )
          else
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final itemWidth = (constraints.maxWidth - 36) / 2;
                  final aspect = itemWidth / (itemWidth + 145);
                  final clampedAspect =
                      aspect < 0.5 ? 0.5 : (aspect > 0.8 ? 0.8 : aspect);

                  return _buildGridWithAds(
                    context,
                    filteredItems,
                    clampedAspect,
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  /// Builds a [CustomScrollView] that mixes product grid chunks with full-width
  /// [AdBlock] widgets injected every 15–20 items (randomised per chunk).
  Widget _buildGridWithAds(
    BuildContext context,
    List<SearchedItems> items,
    double childAspectRatio,
  ) {
    final random = Random();

    // Randomised ad positions to cycle through for visual variety
    const adPositions = ['middle', 'bottom', 'sidebar'];
    int positionIndex = random.nextInt(adPositions.length);

    final slivers = <Widget>[];
    int cursor = 0;

    while (cursor < items.length) {
      // Random chunk size between 15 and 20 (inclusive)
      final chunkSize = 5 + random.nextInt(6); // 15..20
      final end = (cursor + chunkSize).clamp(0, items.length);
      final chunk = items.sublist(cursor, end);

      // ── Product grid sliver ──────────────────────────────────────────────
      slivers.add(
        SliverPadding(
          padding: EdgeInsets.fromLTRB(
            12,
            cursor == 0 ? 12 : 0, // only top-pad the very first chunk
            12,
            12,
          ),
          sliver: SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _buildProductCard(chunk[index], context),
              childCount: chunk.length,
            ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: childAspectRatio,
            ),
          ),
        ),
      );

      cursor = end;

      // ── Ad block sliver (only between chunks, not after the last one) ────
      if (cursor < items.length) {
        final position = adPositions[positionIndex % adPositions.length];
        positionIndex++;

        slivers.add(
          SliverToBoxAdapter(
            child: AdBlock(page: 'product', position: position, limit: 4),
          ),
        );
      }
    }

    return CustomScrollView(slivers: slivers);
  }

  Widget _buildFilters(BuildContext context) {
    final provider = context.watch<SearchProductProvider>();
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          // Filter Button
          ActionChip(
            avatar: const Icon(Icons.filter_list, size: 16),
            label: const Text('Filters'),
            onPressed: () {
              _showFilterBottomSheet(context, provider);
            },
          ),
          const SizedBox(width: 8),

          // Show APPLIED filters as chips that can be removed
          if (provider.selectedCategory != null)
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: InputChip(
                label: Text('Cat: ${provider.selectedCategory}'),
                onDeleted:
                    () => provider.setCategoryFilter(provider.selectedCategory),
              ),
            ),

          if (provider.selectedBrand != null)
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: InputChip(
                label: Text('Brand: ${provider.selectedBrand}'),
                onDeleted:
                    () => provider.setBrandFilter(provider.selectedBrand),
              ),
            ),
        ],
      ),
    );
  }

  void _showFilterBottomSheet(
    BuildContext context,
    SearchProductProvider provider,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext sheetContext) {
        return ChangeNotifierProvider.value(
          value: provider,
          child: Consumer<SearchProductProvider>(
            builder: (context, prov, child) {
              return Container(
                padding: const EdgeInsets.all(20),
                height: MediaQuery.of(context).size.height * 0.6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Filters',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Divider(),
                    if (filters?.categories != null &&
                        filters!.categories!.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      const Text(
                        'Categories',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8.0,
                        children:
                            filters!.categories!.map((cat) {
                              final isSelected =
                                  prov.selectedCategory == cat.name;
                              return ChoiceChip(
                                label: Text(
                                  '${cat.name ?? ''}${cat.count != null ? ' (${cat.count})' : ''}',
                                ),
                                selected: isSelected,
                                selectedColor: Colors.teal.shade100,
                                onSelected:
                                    (_) => prov.setCategoryFilter(cat.name),
                              );
                            }).toList(),
                      ),
                    ],
                    if (filters?.brands != null &&
                        filters!.brands!.isNotEmpty) ...[
                      const SizedBox(height: 20),
                      const Text(
                        'Brands',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8.0,
                        children:
                            filters!.brands!.map((brand) {
                              final isSelected =
                                  prov.selectedBrand == brand.name;
                              return ChoiceChip(
                                label: Text(
                                  '${brand.name ?? ''}${brand.count != null ? ' (${brand.count})' : ''}',
                                ),
                                selected: isSelected,
                                selectedColor: Colors.blue.shade100,
                                onSelected:
                                    (_) => prov.setBrandFilter(brand.name),
                              );
                            }).toList(),
                      ),
                    ],
                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black87,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        onPressed: () => context.pop(),
                        child: const Text(
                          'Apply',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildProductCard(SearchedItems item, BuildContext context) {
    return ProductViewerCard(item: item);
  }
}
