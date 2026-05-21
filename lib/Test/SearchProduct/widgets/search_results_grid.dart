import 'package:go_router/go_router.dart';
import 'package:exotic/controllers/Products/productShellController.dart';
import 'package:exotic/data/blocs/products/bloc/fetch_products_bloc.dart';
import 'package:exotic/data/blocs/products/bloc/fetch_products_event.dart';
import 'package:exotic/view/widgets/searched_items_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:exotic/data/providers/search_product_provider.dart';
import 'package:exotic/data/domains/ads/widgets/ad_block.dart';

class SearchedItemsWidget extends StatelessWidget {
  final List<SearchedItems> items;
  final Filters? filters;
  final bool isLoading;

  const SearchedItemsWidget({
    Key? key,
    required this.items,
    this.filters,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Premium Sponsored Ad Block Placement for search keywords
        const AdBlock(page: 'search', position: 'top', limit: 2),
        if (filters != null) _buildFilters(context),
        if (items.isEmpty)
          const Expanded(child: Center(child: Text('No products found.')))
        else
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Automatically determine aspect ratio based on available width
                // A standard 2-column grid will give approx (constraints.maxWidth - 36) / 2 width per item
                final itemWidth = (constraints.maxWidth - 36) / 2;
                // Assume fixed vertical size for text components (~100 to 110px) + width for image
                final aspect = itemWidth / (itemWidth + 110);

                return GridView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: items.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio:
                        aspect < 0.5 ? 0.5 : (aspect > 0.8 ? 0.8 : aspect),
                  ),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return _buildProductCard(item, context);
                  },
                );
              },
            ),
          ),
      ],
    );
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
                    const Text(
                      'Filters',
                      style: TextStyle(
                        fontSize: 18,
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
                                label: Text(cat.name ?? ''),
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
                                label: Text(brand.name ?? ''),
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
    void onTap() {
      print('working');
      context.read<FetchProductBloc>().add(
        FetchingSingleProductEvent(productid: item.id.toString()),
      );
      context.push('/dynamicRoute', extra: () => ProductsShell(),
      );
    }

    final imagePath = item.image ?? '';
    final imageUrl = imagePath.isNotEmpty ? "$imagePath" : "";

    // Fallbacks and tag selection matching the image style
    String? tag;
    Color? tagColor;

    // Just a sample logic to show tags like 'BESTSELLER' or 'TRENDING' based on score
    if (item.relevanceScore != null && item.relevanceScore! >= 50) {
      tag = "BESTSELLER";
      tagColor = const Color(0xFF009688); // Teal
    } else if (item.stock?.status != "in_stock") {
      tag = "SOLD OUT";
      tagColor = Colors.grey.shade700;
    } else if ((item.price?.discountPercentage ?? 0) > 55) {
      tag = "TRENDING";
      tagColor = Colors.blue.shade600;
    }

    return InkWell(
      onTap: () => onTap(),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image and Tags Stack, using Expanded to occupy remaining height
            Expanded(
              child: Stack(
                children: [
                  // Image
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                        bottomLeft: Radius.circular(8),
                        bottomRight: Radius.circular(8),
                      ),
                      child: Container(
                        color: Colors.grey.shade100,
                        child:
                            imageUrl.isNotEmpty
                                ? Image.network(
                                  imageUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder:
                                      (context, _, __) => const Center(
                                        child: Icon(
                                          Icons.broken_image,
                                          color: Colors.grey,
                                          size: 40,
                                        ),
                                      ),
                                )
                                : const Center(
                                  child: Icon(
                                    Icons.image,
                                    size: 40,
                                    color: Colors.grey,
                                  ),
                                ),
                      ),
                    ),
                  ),
                  // Tag
                  if (tag != null)
                    Positioned(
                      top: 0,
                      left: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: tagColor,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            bottomRight: Radius.circular(8),
                          ),
                        ),
                        child: Text(
                          tag,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  // Favorite Icon
                  Positioned(
                    top: 6,
                    right: 6,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.85),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.favorite_border,
                        size: 16,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Product Details (Fixed bottom text area)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Brand or Name
                  Text(
                    item.brand ?? item.name?.split(' ').first ?? 'Unknown',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  // Only show name if we used brand for title
                  if (item.brand != null && item.name != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      item.name!,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: 4),
                  // Price Row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (item.price?.discountPercentage != null &&
                          item.price!.discountPercentage! > 0) ...[
                        const Icon(
                          Icons.arrow_downward,
                          size: 12,
                          color: Colors.green,
                        ),
                        Text(
                          '${item.price!.discountPercentage}%',
                          style: const TextStyle(
                            color: Colors.green,
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(width: 4),
                      ],
                      Text(
                        '₹${item.price?.selling ?? 0}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(width: 4),
                      if (item.price?.mrp != null &&
                          item.price?.mrp != item.price?.selling)
                        Flexible(
                          child: Text(
                            '₹${item.price!.mrp}',
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.grey,
                              decoration: TextDecoration.lineThrough,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  // Rating row (hardcoded as per image design requirements if not available)
                  Row(
                    children: [
                      const Icon(Icons.star, size: 10, color: Colors.green),
                      const Icon(Icons.star, size: 10, color: Colors.green),
                      const Icon(Icons.star, size: 10, color: Colors.green),
                      const Icon(Icons.star, size: 10, color: Colors.green),
                      const Icon(
                        Icons.star_border,
                        size: 10,
                        color: Colors.green,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '(200)',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  // Delivery Status
                  Text(
                    item.stock?.status == 'in_stock'
                        ? 'Free delivery'
                        : 'Out of stock',
                    style: TextStyle(
                      fontSize: 11,
                      color:
                          item.stock?.status == 'in_stock'
                              ? Colors.grey.shade700
                              : Colors.red,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
