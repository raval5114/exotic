import 'dart:convert';

import 'package:exotic/controllers/products/shared/src/ProductPricingSection.dart';
import 'package:exotic/controllers/products/shared/src/productImageCarousel.dart';
import 'package:exotic/controllers/products/shared/src/productRating.dart';
import 'package:exotic/controllers/products/shared/src/productSizeChart.dart';
import 'package:flutter/material.dart';

class ProductsdescriptionComponent extends StatefulWidget {
  final String productName;
  final String imgages;
  final double ratings;
  final String discount;
  final String discountedPrice;
  final String initialPrice;
  final bool isFreeDelivery;
  final Map<String, dynamic> sizeChart;
  const ProductsdescriptionComponent({
    super.key,
    required this.productName,
    required this.ratings,
    required this.discount,
    required this.discountedPrice,
    required this.initialPrice,
    required this.isFreeDelivery,
    required this.sizeChart,
    required this.imgages,
  });

  @override
  State<ProductsdescriptionComponent> createState() =>
      _ProductsdescriptionComponentState();
}

class _ProductsdescriptionComponentState
    extends State<ProductsdescriptionComponent> {
  List<String> parseImageList(String? rawString) {
    if (rawString == null || rawString.trim().isEmpty) {
      return [];
    }

    try {
      final decoded = jsonDecode(rawString);
      return List<String>.from(decoded);
    } catch (e) {
      debugPrint("Image parse error: $e");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> imagesList = parseImageList(widget.imgages);

    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(12),
      margin: EdgeInsets.only(bottom: 2),
      child: Column(
        children: [
          ProductCarousel(
            imageMaps:
                imagesList.map((e) => ProductImage.fromString(e)).toList(),
            height: 287,
          ),
          SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.productName,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                RatingDisplay(rating: widget.ratings, iconSize: 25),
              ],
            ),
          ),
          ProductPricingSection(
            discount: widget.discount,
            initialPrice: widget.initialPrice,
            discountedPrice: widget.discountedPrice,
          ),
          if (widget.isFreeDelivery)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: SizedBox(
                width: double.infinity,
                child: Text(
                  "Free Delivery",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ),
          SizedBox(height: 12),
          SizeSelector(productData: widget.sizeChart),
        ],
      ),
    );
  }
}
