import 'package:exotic/data/models/Interaction/interactions.dart';
import 'package:exotic/data/providers/interaction_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:exotic/data/blocs/productViewer/bloc/product_viewer_bloc.dart';
import 'package:exotic/data/domains/productViewer/productViewer.dart';
import 'package:exotic/view/widgets/searched_items_widget.dart' as models;
import 'package:exotic/controllers/ProductViewer/src/ProductViewerItemsWidget.dart';
import 'package:shimmer/shimmer.dart';

class ProductViewerComponent extends StatefulWidget {
  final String url;
  final String pageName;
  const ProductViewerComponent({
    super.key,
    required this.url,
    required this.pageName,
  });

  @override
  State<ProductViewerComponent> createState() => _ProductViewerComponentState();
}

class _ProductViewerComponentState extends State<ProductViewerComponent> {
  late ProductViewerBloc _productViewerBloc;

  @override
  void initState() {
    super.initState();

    _productViewerBloc = ProductViewerBloc(ProductViewerRepo());
    _productViewerBloc.add(FetchProductDetailsEvent(url: widget.url));
  }

  @override
  void dispose() {
    _productViewerBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _productViewerBloc,
      child: BlocBuilder<ProductViewerBloc, ProductViewerState>(
        builder: (context, state) {
          if (state is ProductViewerLoadingState ||
              state is ProductViewerInitial) {
            context.read<InteractionProvider>().addInteraction(
              interactionType: InteractionType.productGridView,
              pageName: widget.pageName,
            );
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

          if (state is ProductViewerEmptyState) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.search_off_rounded,
                    color: Colors.grey,
                    size: 64,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "No product Found",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            );
          }

          if (state is ProductViewerErrorState) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline_rounded,
                      color: Colors.redAccent,
                      size: 64,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      "Oops! Something went wrong.",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      state.errMsg,
                      textAlign: TextAlign.center,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        _productViewerBloc.add(
                          FetchProductDetailsEvent(url: widget.url),
                        );
                      },
                      icon: const Icon(Icons.refresh_rounded),
                      label: const Text("Retry"),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is ProductViewerLoadedState) {
            try {
              final parsedData = models.SearchedItemsList.fromJson(
                state.productDetails,
              );
              return ProductViewerItemsWidget(
                items: parsedData.items,
                filters: parsedData.filters,
              );
            } catch (e) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Text(
                      "Data parsed failed: $e\n\nRaw Data:\n${state.productDetails.toString()}",
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ),
              );
            }
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
