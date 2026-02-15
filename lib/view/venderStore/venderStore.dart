import 'package:exotic/controllers/src/appbar.dart';
import 'package:exotic/controllers/vendorStore/vendorStore.dart';
import 'package:flutter/material.dart';

class VenderStore extends StatelessWidget {
  final String venderName;
  final String ratings;
  final String followings;
  final List<Map<String, dynamic>> products;
  final String raters;
  const VenderStore({
    super.key,
    required this.venderName,
    required this.ratings,
    required this.followings,
    required this.products,
    required this.raters,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ExoticAppBar(),
      body: VenderStoreComponent(
        venderName: venderName,
        ratings: ratings,
        followings: followings,
        products: products,
        raters: raters,
      ),
    );
  }
}
