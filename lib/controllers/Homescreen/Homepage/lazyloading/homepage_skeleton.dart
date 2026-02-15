import 'package:exotic/controllers/Homescreen/Homepage/lazyloading/bannerShimmer.dart';
import 'package:exotic/controllers/Homescreen/Homepage/lazyloading/product_grid_shimmer.dart';
import 'package:exotic/controllers/Homescreen/Homepage/lazyloading/vertical_product_shimmer.dart';
import 'package:flutter/material.dart';

class HomepageSkeleton extends StatelessWidget {
  const HomepageSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: const [
          BannerShimmer(),
          SizedBox(height: 16),
          ProductGridShimmer(),
          SizedBox(height: 16),
          VerticalProductShimmer(),
          SizedBox(height: 16),
          ProductGridShimmer(),
        ],
      ),
    );
  }
}
