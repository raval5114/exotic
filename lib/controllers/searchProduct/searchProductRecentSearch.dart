import 'package:exotic/data/blocs/searchProduct/bloc/search_product_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

class SearchProductRecentSearch extends StatefulWidget {
  const SearchProductRecentSearch({super.key});

  @override
  State<SearchProductRecentSearch> createState() =>
      _SearchProductRecentSearchState();
}

class _SearchProductRecentSearchState extends State<SearchProductRecentSearch> {
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
            state is SearchProductMetaDataState ? state.recentSearchData : [];

        if (data.isEmpty) return const SizedBox.shrink();

        final width = MediaQuery.of(context).size.width;
        final avatarRadius = width * 0.09;
        final horizontalPadding = width * 0.04;

        return Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: horizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Recent Searches",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: avatarRadius * 2 + 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final item = data[index];
                    return Container(
                      width: avatarRadius * 2 + 16,
                      margin: const EdgeInsets.only(right: 8),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.grey.shade100, width: 1),
                            ),
                            child: CircleAvatar(
                              radius: avatarRadius,
                              backgroundColor: Colors.grey.shade50,
                              backgroundImage: item['imagePath'] != null
                                  ? NetworkImage(item['imagePath'])
                                  : null,
                              child: item['imagePath'] == null
                                  ? const Icon(Icons.search, color: Colors.grey)
                                  : null,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            item['name'] ?? "",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildShimmer(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final avatarRadius = width * 0.09;
    final horizontalPadding = width * 0.04;

    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(horizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              width: 150,
              height: 20,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          SizedBox(height: width * 0.03),
          SizedBox(
            height: avatarRadius * 2 + 30,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Column(
                    children: [
                      Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: CircleAvatar(
                          radius: avatarRadius,
                          backgroundColor: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          width: 50,
                          height: 10,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
