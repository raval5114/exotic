import 'package:exotic/controllers/products/productShellController.dart';
import 'package:exotic/controllers/searchProduct/searchProductDiscoverProduct.dart';
import 'package:exotic/controllers/searchProduct/searchProductPopularProduct.dart';
import 'package:exotic/controllers/searchProduct/searchProductRecentSearch.dart';
import 'package:exotic/controllers/searchProduct/searchQuerySectionComponent.dart';
import 'package:exotic/data/blocs/products/bloc/fetch_products_bloc.dart';
import 'package:exotic/data/blocs/products/bloc/fetch_products_event.dart';
import 'package:exotic/data/blocs/searchProduct/bloc/search_product_bloc.dart';
import 'package:exotic/utils/searchProduct.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

class SearchProductComponent extends StatefulWidget {
  const SearchProductComponent({super.key});

  @override
  State<SearchProductComponent> createState() => _SearchProductComponentState();
}

class _SearchProductComponentState extends State<SearchProductComponent> {
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    /// Load discovery data ONLY ONCE
    context.read<SearchProductBloc>().add(SearchProductMetaDataEvent());
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(
          0xFFB3D9FF,
        ), // Matches the light blue in the image
        elevation: 0,
        title: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
            Expanded(
              child: Container(
                height: 45,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade200, width: 1),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: Colors.blue, size: 22),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Searchquerysectioncomponent(
                        controller: controller,
                      ),
                    ),
                    const Icon(Icons.mic_none, color: Colors.blue, size: 22),
                    const SizedBox(width: 12),
                    const Icon(
                      Icons.camera_alt_outlined,
                      color: Colors.blue,
                      size: 22,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          /// 1️⃣ BASE LAYER: Discovery Sections (Always stays mounted to keep scroll position)
          SingleChildScrollView(
            child: Column(
              children: const [
                SearchProductRecentSearch(),
                Divider(thickness: 8, color: Color(0xFFEEEEEE)),
                SearchProductPopularProduct(),
                Divider(thickness: 8, color: Color(0xFFEEEEEE)),
                SearchProductDiscoverProduct(),
              ],
            ),
          ),

          /// 2️⃣ OVERLAY LAYER: Search Results
          BlocBuilder<SearchProductBloc, SearchProductState>(
            builder: (context, state) {
              if (state is SearchProductLoadingState) {
                return Container(color: Colors.white, child: _shimmerLoading());
              }

              if (state is SearchProductQueryResultState) {
                return Container(
                  color: Colors.white,
                  child: SingleChildScrollView(
                    child: _searchResultsList(state.queryResult),
                  ),
                );
              }

              if (state is SearchErrorState) {
                return Container(
                  color: Colors.white,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        'Error: ${state.errMsg}',
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                );
              }

              // Hide overlay when field is empty (Initial state)
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }

  Widget _searchResultsList(Map<String, dynamic> response) {
    final products =
        (response['results']?['products'] as List?)
            ?.cast<Map<String, dynamic>>() ??
        [];
    final total = response['results']?['total'];

    if (products.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(40),
        child: Center(child: Text("No products found")),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (total != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              "Showing $total results",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: products.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final product = products[index];

            return ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 4,
              ),
              leading: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child:
                    (product['image'] != null &&
                            product['image'].toString().isNotEmpty)
                        ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            product['image'],
                            fit: BoxFit.cover,
                            errorBuilder:
                                (_, __, ___) => const Icon(
                                  Icons.inventory_2_outlined,
                                  size: 20,
                                  color: Colors.grey,
                                ),
                          ),
                        )
                        : const Icon(
                          Icons.search,
                          size: 20,
                          color: Colors.grey,
                        ),
              ),
              title: Text(
                product['name'] ?? 'Unknown',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              subtitle: Row(
                children: [
                  Text(
                    product['category'] ?? 'Product',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  if (product['price'] != null &&
                      product['price']['selling'] != null) ...[
                    const SizedBox(width: 8),
                    Text("•", style: TextStyle(color: Colors.grey.shade500)),
                    const SizedBox(width: 8),
                    Text(
                      "₹${product['price']['selling']}",
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ],
              ),
              trailing: Icon(
                Icons.call_made,
                size: 18,
                color: Colors.grey.shade300,
              ),
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();

                // Store in Recent Searches
                final currentItem = {
                  'name': product['name'] ?? 'Unknown',
                  'imagePath': product['image'],
                  'isProduct': true,
                };

                recentSearchData.removeWhere(
                  (item) => item['name'] == currentItem['name'],
                );
                recentSearchData.insert(0, currentItem);
                if (recentSearchData.length > 10) {
                  recentSearchData = recentSearchData.sublist(0, 10);
                }

                controller.clear();

                context.read<FetchProductBloc>().add(
                  FetchingSingleProductEvent(
                    productid: product['id'].toString(),
                  ),
                );

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProductsShell()),
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget _shimmerLoading() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 8,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade200,
          highlightColor: Colors.grey.shade100,
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 4,
            ),
            leading: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            title: Container(
              height: 15,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            subtitle: Row(
              children: [
                Container(
                  height: 12,
                  width: 60,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 8),
                Text("•", style: TextStyle(color: Colors.grey.shade500)),
                const SizedBox(width: 8),
                Container(
                  height: 12,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
