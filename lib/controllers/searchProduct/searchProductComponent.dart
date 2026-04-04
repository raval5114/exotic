import 'package:exotic/controllers/searchProduct/searchQuerySectionComponent.dart';
import 'package:exotic/data/blocs/searchProduct/bloc/search_product_bloc.dart';
import 'package:exotic/view/searchProduct/searchProductGrid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'package:exotic/data/providers/search_product_provider.dart';

class SearchProductComponent extends StatefulWidget {
  const SearchProductComponent({super.key});

  @override
  State<SearchProductComponent> createState() => _SearchProductComponentState();
}

class _SearchProductComponentState extends State<SearchProductComponent> {
  final TextEditingController controller = TextEditingController();
  final SearchProductProvider _searchProvider = SearchProductProvider();

  @override
  void initState() {
    super.initState();
    _searchProvider.fetchInitialData();
    controller.addListener(() {
      _searchProvider.searchLocal(controller.text);
    });

    /// Load discovery data ONLY ONCE
    context.read<SearchProductBloc>().add(SearchProductMetaDataEvent());
  }

  @override
  void dispose() {
    controller.dispose();
    _searchProvider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _searchProvider,
      child: Scaffold(
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
        body: Consumer<SearchProductProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (provider.errorMessage != null) {
              return Center(child: Text('Error: ${provider.errorMessage}'));
            }

            final suggestions = provider.filteredSuggestions;
            if (suggestions.isEmpty) {
              return const Center(child: Text('No results found'));
            }

            return ListView.separated(
              physics: const BouncingScrollPhysics(),
              itemCount: suggestions.length,
              separatorBuilder:
                  (_, __) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Divider(height: 1, color: Colors.grey.shade100),
                  ),
              itemBuilder: (context, index) {
                final item = suggestions[index];

                // Determine styling dynamically based on the suggestion type
                IconData fallbackIcon = Icons.search;
                Color iconColor = Colors.grey.shade500;
                Color bgColor = Colors.grey.shade100;

                if (item.type == 'popular') {
                  fallbackIcon = Icons.trending_up;
                  iconColor = Colors.orange.shade600;
                  bgColor = Colors.orange.shade50;
                } else if (item.type == 'category') {
                  fallbackIcon = Icons.category_outlined;
                  iconColor = Colors.blue.shade600;
                  bgColor = Colors.blue.shade50;
                } else if (item.type == 'brand') {
                  fallbackIcon = Icons.storefront_outlined;
                  iconColor = Colors.purple.shade600;
                  bgColor = Colors.purple.shade50;
                } else if (item.type == 'product') {
                  fallbackIcon = Icons.inventory_2_outlined;
                  iconColor = Colors.green.shade600;
                  bgColor = Colors.green.shade50;
                }

                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      // controller.text = item.title ?? '';
                      // FocusManager.instance.primaryFocus?.unfocus();
                      context.read<SearchProductBloc>().add(
                        SearchedProductDataCallingEvent(url: item.dataUrl!),
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SearchedProductScreen(),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      child: Row(
                        children: [
                          // LEADING ICON OR THUMBNAIL
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: bgColor,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade100),
                            ),
                            child:
                                item.image != null && item.image!.isNotEmpty
                                    ? ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.network(
                                        item.image!,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (_, __, ___) => Icon(
                                              fallbackIcon,
                                              color: iconColor,
                                            ),
                                      ),
                                    )
                                    : Icon(fallbackIcon, color: iconColor),
                          ),
                          const SizedBox(width: 16),

                          // CENTER TEXT CONTENT
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.title ?? '',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                    color: Colors.black87,
                                    letterSpacing: -0.2,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  item.subtitle ?? '',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color:
                                        item.type == 'product'
                                            ? Colors.green.shade700
                                            : Colors.grey.shade500,
                                    fontSize: 13,
                                    fontWeight:
                                        item.type == 'product'
                                            ? FontWeight.w600
                                            : FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),

                          // TRAILING ACTION INDICATOR
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color:
                                  item.type == 'product'
                                      ? Colors.blue.shade50
                                      : Colors.transparent,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              item.type == 'product'
                                  ? Icons.arrow_forward_ios
                                  : Icons.north_west,
                              size: item.type == 'product' ? 14 : 18,
                              color:
                                  item.type == 'product'
                                      ? Colors.blue.shade600
                                      : Colors.grey.shade400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
