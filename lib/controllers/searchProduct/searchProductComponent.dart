import 'package:exotic/Test/HomepagesTesting/model/interactions/elements/exoticPage.dart';
import 'package:exotic/Test/HomepagesTesting/model/interactions/providers/interaction_provider.dart';
import 'package:exotic/controllers/products/productShellController.dart';
import 'package:exotic/data/blocs/products/bloc/fetch_products_bloc.dart';
import 'package:exotic/data/blocs/products/bloc/fetch_products_event.dart';
import 'package:exotic/data/models/Interaction/interactions.dart';
import 'package:exotic/data/providers/interaction_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:exotic/controllers/searchProduct/searchQuerySectionComponent.dart';
import 'package:exotic/data/blocs/searchProduct/bloc/search_product_bloc.dart';
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

  //bool _isLoggedIn = false;
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
    // context.read<InteractionProvider>().addInteraction(
    //   interactionType: InteractionType.searchPage,
    //   pageName: 'Search Product Page',
    // );
    context.read<InteractionTestProvider>().addInteraction(
      Exoticpage(
        tabBarName: '',
        pageName: 'Search-Product',
        isTabBar: false,
        createdAt: DateTime.now().toString(),
        interactionId: 05,
        interactionType: 'page',
        updatedAt: DateTime.now().toString(),
      ),
    );
    return ChangeNotifierProvider.value(
      value: _searchProvider,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Theme.of(context).colorScheme.secondary,
          elevation: 0,
          title: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => context.pop(),
              ),
              Expanded(
                child: Container(
                  height: 45,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withOpacity(0.4),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.search,
                        color: Theme.of(context).colorScheme.primary,
                        size: 22,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Searchquerysectioncomponent(
                          controller: controller,
                        ),
                      ),
                      Icon(
                        Icons.mic_none,
                        color: Theme.of(context).colorScheme.primary,
                        size: 22,
                      ),
                      const SizedBox(width: 12),
                      Icon(
                        Icons.camera_alt_outlined,
                        color: Theme.of(context).colorScheme.primary,
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
                if (item.type == 'popular') {
                  fallbackIcon = Icons.trending_up;
                  iconColor = Colors.grey.shade600;
                } else if (item.type == 'category') {
                  fallbackIcon = Icons.search;
                  iconColor = Colors.grey.shade500;
                } else if (item.type == 'brand') {
                  fallbackIcon = Icons.search;
                  iconColor = Colors.grey.shade500;
                } else if (item.type == 'product') {
                  fallbackIcon = Icons.search;
                  iconColor = Colors.grey.shade500;
                }

                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      if (item.type == 'product') {
                        context.read<FetchProductBloc>().add(
                          FetchingSingleProductEvent(
                            productid: item.id.toString(),
                          ),
                        );
                        context.push(
                          '/dynamicRoute',
                          extra: () => ProductsShell(),
                        );
                      } else {
                        context.push(
                          "/ProductsViewer",
                          extra: {
                            "url": "${item.dataUrl}",
                            "title": item.title,
                          },
                        );
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      child: Row(
                        children: [
                          // LEADING ICON OR THUMBNAIL
                          if (item.image != null && item.image!.isNotEmpty)
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: Colors.grey.shade200),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: Image.network(
                                  item.image!,
                                  fit: BoxFit.cover,
                                  errorBuilder:
                                      (_, __, ___) => Icon(
                                        fallbackIcon,
                                        color: iconColor,
                                        size: 20,
                                      ),
                                ),
                              ),
                            )
                          else
                            Icon(fallbackIcon, color: iconColor, size: 22),

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
                                  style: Theme.of(
                                    context,
                                  ).textTheme.bodyMedium?.copyWith(
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black87,
                                  ),
                                ),
                                if (item.subtitle != null &&
                                    item.subtitle!.isNotEmpty) ...[
                                  const SizedBox(height: 2),
                                  Text(
                                    item.subtitle!,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall?.copyWith(
                                      fontFamily: 'Roboto',
                                      color: Colors.grey.shade600,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),

                          // TRAILING ACTION INDICATOR
                          Icon(
                            item.type == 'product'
                                ? Icons.arrow_forward_ios
                                : Icons.north_west,
                            size: item.type == 'product' ? 14 : 18,
                            color: Colors.grey.shade400,
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
