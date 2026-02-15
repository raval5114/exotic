import 'package:exotic/controllers/searchProduct/src/popularSearchTile.dart';
import 'package:exotic/data/blocs/searchProduct/bloc/search_product_bloc.dart';
import 'package:exotic/data/models/metaData.dart';
import 'package:exotic/data/providers/meta_data_provider.dart';
import 'package:exotic/utils/searchProduct.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
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
    final width = MediaQuery.of(context).size.width;
    final horizontalPadding = width * 0.04;
    List<Map<String, dynamic>> data = popularProducts;
    // List<PopularProductsModel> data =
    //     context.read<MetaDataProvider>().metaData!.popularProducts;
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 2),
        padding: EdgeInsets.all(horizontalPadding),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Popular Search",
              style: GoogleFonts.roboto(
                fontWeight: FontWeight.w500,
                fontSize: width * 0.045,
              ),
            ),
            const SizedBox(height: 12),
            GridView.builder(
              itemCount: data.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(), // important
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: (width ~/ 120).clamp(2, 4),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 3 / 4,
              ),
              itemBuilder:
                  (context, index) => SearchProductPopularProductTile(
                    imagePath: data[index]['imagePath'],
                    name: data[index]['name'],
                    categorie: data[index]['categorie'],
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
