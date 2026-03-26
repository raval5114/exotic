import 'package:cached_network_image/cached_network_image.dart';
import 'package:exotic/controllers/Products/productShellController.dart';
import 'package:exotic/data/blocs/products/bloc/fetch_products_bloc.dart';
import 'package:exotic/data/blocs/products/bloc/fetch_products_event.dart';
import 'package:exotic/data/models/Homepage/elements/Items/ProductItem.dart';
import 'package:exotic/data/models/Homepage/elements/configs/mobile_suggestion.dart';
import 'package:exotic/utils/image_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

class MobileSuggestionProducts extends StatelessWidget {
  final String title;
  final MobileSuggestionConfig config;
  final List<ProductItem> products;

  const MobileSuggestionProducts({
    super.key,
    required this.title,
    required this.config,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) return const SizedBox();

    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                config.sectionTitle.isNotEmpty ? config.sectionTitle : title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                  fontFamily:
                      'Roboto', // Falling back to system Roboto or assets if available
                ),
              ),
              if (config.viewAllLink.isNotEmpty)
                InkWell(
                  onTap: () {
                    // TODO: Handle view all link
                  },
                  child: const Row(
                    children: [
                      Text(
                        "View All",
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFFE94A75), // Brand Color Pink/Red
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Roboto',
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward_rounded,
                        size: 14,
                        color: Color(0xFFE94A75),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 220,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              itemCount: products.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                return MobileSuggestionCard(
                  product: products[index],
                  onTap: () {
                    context.read<FetchProductBloc>().add(
                      FetchingSingleProductEvent(
                        productid: products[index].productId.toString(),
                      ),
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProductsShell()),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class MobileSuggestionCard extends StatelessWidget {
  final ProductItem product;
  final VoidCallback onTap;

  const MobileSuggestionCard({required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(bottom: 0), // reduce space below card
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min, // prevents extra vertical space
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Stack
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  child: SizedBox(
                    height: 140, // slightly reduced height
                    width: 160,
                    child: Image.network(
                      product.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (context, url, error) => const Center(
                            child: Icon(
                              Icons.broken_image_rounded,
                              color: Colors.grey,
                            ),
                          ),
                    ),
                  ),
                ),
                if (product.price.discountPercentage > 0)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE94A75),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        "${product.price.discountPercentage}% OFF",
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          fontFamily: 'Roboto',
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(8), // balanced padding
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                      height: 1.2,
                      fontFamily: 'Roboto',
                    ),
                  ),
                  const SizedBox(height: 4), // reduced spacing

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "₹${product.price.sellingPrice}",
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                          fontFamily: 'Roboto',
                        ),
                      ),
                      const SizedBox(width: 6),
                      if (product.price.mrpPrice > product.price.sellingPrice)
                        Text(
                          "₹${product.price.mrpPrice}",
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[500],
                            decoration: TextDecoration.lineThrough,
                            decorationColor: Colors.grey[500],
                            fontFamily: 'Roboto',
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
