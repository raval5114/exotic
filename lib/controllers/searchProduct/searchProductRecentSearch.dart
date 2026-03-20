import 'package:exotic/controllers/searchProduct/src/recentSearchTile.dart';
import 'package:exotic/data/blocs/searchProduct/bloc/search_product_bloc.dart';
import 'package:exotic/data/models/metaData.dart';
import 'package:exotic/data/providers/meta_data_provider.dart';
import 'package:exotic/utils/searchProduct.dart';
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
    final width = MediaQuery.of(context).size.width;
    final avatarRadius = width * 0.09;
    final horizontalPadding = width * 0.04;
    final List<Map<String, dynamic>> data = recentSearchData;
    // final List<RecentSearchesModel> data =
    //     context.read<MetaDataProvider>().metaData!.recentSearches;
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(horizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Recent Searches",
            style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w500,
              fontSize: width * 0.045,
              color: Colors.black,
            ),
          ),
          SizedBox(height: width * 0.03),
          SizedBox(
            height: avatarRadius * 2 + 30,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: data.length,
              itemBuilder:
                  (context, index) => SearchProductRecentSearchTile(
                    name: data[index]['name'],
                    avatarRadius: avatarRadius,
                    width: width,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
