import 'package:exotic/controllers/searchProduct/src/discoverTile.dart';
import 'package:exotic/utils/searchProduct.dart';
import 'package:flutter/material.dart';

class SearchProductDiscoverProduct extends StatelessWidget {
  const SearchProductDiscoverProduct({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final horizontalPadding = width * 0.04;

    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.all(horizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Discover More",
            style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w600,
              fontSize: width * 0.045,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children:
                discoverStrings
                    .map((item) => SearchProductDiscoverProductTile(item: item))
                    .toList(),
          ),
        ],
      ),
    );
  }
}
