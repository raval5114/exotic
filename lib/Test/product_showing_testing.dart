import 'package:go_router/go_router.dart';
import 'package:exotic/data/blocs/products/bloc/fetch_products_bloc.dart';
import 'package:exotic/data/blocs/products/bloc/fetch_products_event.dart';
import 'package:exotic/data/blocs/products/bloc/fetch_products_state.dart';
import 'package:exotic/data/models/product_orignal.dart';
import 'package:exotic/data/providers/product_provider.dart';
import 'package:exotic/view/products/productScreen.dart';
import 'package:exotic/view/widgets/product_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:exotic/controllers/searchProduct/searchQuerySectionComponent.dart';
import 'package:shimmer/shimmer.dart';

class ProductTileShimmer extends StatelessWidget {
  const ProductTileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Image shimmer
          Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              width: 80,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(width: 12),

          /// Text shimmer
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _line(width: double.infinity, height: 14),
                const SizedBox(height: 8),
                _line(width: 140, height: 12),
                const SizedBox(height: 8),
                _line(width: 100, height: 12),
                const SizedBox(height: 12),
                _line(width: 80, height: 14),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _line({required double width, required double height}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(width: width, height: height, color: Colors.white),
    );
  }
}

class SearchProductTesting extends StatelessWidget {
  const SearchProductTesting({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Theme.of(context).colorScheme.onSecondaryContainer,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          height: 39,
          child: Row(
            children: [
              Image.asset(
                'assets/icons/homescreen_searchbar_camera_icon.jpg',
                width: 20,
              ),
              const SizedBox(width: 8),
              Searchquerysectioncomponent(),
              const SizedBox(width: 8),
              Image.asset(
                'assets/icons/homescreen_searchbar_mic_icon.jpg',
                width: 20,
              ),
              const SizedBox(width: 8),
              Image.asset(
                'assets/icons/homescreen_searchbar_search_icon.jpg',
                width: 20,
              ),
            ],
          ),
        ),
      ),

      /// AUTOFILL RESULTS HERE
      body: ProductListViewBuilder(),
    );
  }
}

class ProductListViewBuilder extends StatefulWidget {
  const ProductListViewBuilder({super.key});

  @override
  State<ProductListViewBuilder> createState() => _ProductListViewBuilderState();
}

class _ProductListViewBuilderState extends State<ProductListViewBuilder> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<FetchProductBloc>().add(FetchProductsRequested());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FetchProductBloc, FetchProductState>(
      listener: (context, state) {
        if (state is FetchProductFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error), backgroundColor: Colors.red),
          );
        }
      },
      child: BlocBuilder<FetchProductBloc, FetchProductState>(
        builder: (context, state) {
          /// LOADING STATE
          if (state is FetchProductLoading) {
            return ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 6,
              itemBuilder: (_, __) => const ProductTileShimmer(),
            );
          }

          ///
          /// SUCCESS STATE
          ///
          if (state is FetchProductSuccess) {
            if (state.products.isEmpty) {
              return const Center(child: Text('No products available'));
            }

            return ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: state.products.length,
              itemBuilder: (context, index) {
                final product = state.products[index];

                return InkWell(
                  onTap: () {
                    context.read<ProductProvider>().setProduct(
                      ProductModel.fromJson(product),
                    );
                    context.push('/dynamicRoute', extra: () => ProductScreen());
                  },
                  child: ProductTile(product: ProductModel.fromJson(product)),
                );
              },
            );
          }

          /// INITIAL / FALLBACK
          return const SizedBox();
        },
      ),
    );
  }
}
