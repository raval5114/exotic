import 'package:exotic/data/blocs/searchProduct/bloc/search_product_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

class SearchProductPopularProduct extends StatefulWidget {
  const SearchProductPopularProduct({super.key});

  @override
  State<SearchProductPopularProduct> createState() =>
      _SearchProductPopularProductState();
}

class _SearchProductPopularProductState
    extends State<SearchProductPopularProduct> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchProductBloc, SearchProductState>(
      buildWhen:
          (previous, current) =>
              current is SearchProductMetaDataState ||
              current is SearchProductInitial ||
              current is SearchProductLoadingState,
      builder: (context, state) {
        if (state is SearchProductLoadingState) {
          return _buildShimmer(context);
        }

        final List<Map<String, dynamic>> data =
            state is SearchProductMetaDataState ? state.popularProducts : [];

        if (data.isEmpty) return const SizedBox.shrink();

        final width = MediaQuery.of(context).size.width;
        final horizontalPadding = width * 0.04;

        return Container(
          margin: const EdgeInsets.symmetric(vertical: 2),
          padding: EdgeInsets.all(horizontalPadding),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Popular Products",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              GridView.builder(
                itemCount: data.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.7,
                ),
                itemBuilder: (context, index) {
                  final product = data[index];
                  return Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300, width: 1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Center(
                            child: Image.network(
                              product['imagePath'] ?? "",
                              fit: BoxFit.contain,
                              errorBuilder: (_, __, ___) => const Icon(Icons.inventory_2_outlined, color: Colors.grey),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          product['name'] ?? "",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          product['categorie'] ?? "",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildShimmer(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final horizontalPadding = width * 0.04;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      padding: EdgeInsets.all(horizontalPadding),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              width: 140,
              height: 20,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          const SizedBox(height: 12),
          GridView.builder(
            itemCount: 4,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: (width ~/ 120).clamp(2, 4),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 3 / 4,
            ),
            itemBuilder: (context, index) => Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
