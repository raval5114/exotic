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

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    config.sectionTitle.isNotEmpty ? config.sectionTitle : title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                      fontFamily: 'Roboto',
                      letterSpacing: -0.2,
                    ),
                  ),
                ),
                if (config.viewAllLink.isNotEmpty)
                  GestureDetector(
                    onTap: () {
                      // TODO: Handle view all link
                    },
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_forward_rounded,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 310, // Increased height for more details
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: products.length,
              separatorBuilder: (_, __) => const SizedBox(width: 14),
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
        width: 170,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.withOpacity(0.12)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
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
                    height: 170,
                    width: 170,
                    child: Hero(
                      tag: "product_img_${product.productId}",
                      child: Image.network(
                        product.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (context, url, error) => const Center(
                              child: Icon(
                                Icons.broken_image_rounded,
                                color: Colors.grey,
                                size: 32,
                              ),
                            ),
                      ),
                    ),
                  ),
                ),
                // Rating Badge
                if (double.tryParse(product.rating.average) != null && double.parse(product.rating.average) > 0)
                  Positioned(
                    bottom: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(4),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                          )
                        ]
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            product.rating.average,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(width: 2),
                          const Icon(Icons.star_rounded, size: 12, color: Colors.green),
                        ],
                      ),
                    ),
                  ),
                // Discount Badge
                if (product.price.discountPercentage > 0)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE94A75),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        "${product.price.discountPercentage}% OFF",
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
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
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                      height: 1.2,
                      fontFamily: 'Roboto',
                    ),
                  ),
                  const SizedBox(height: 8),

                  Row(
                    children: [
                      Text(
                        "₹${product.price.sellingPrice.toInt()}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Colors.black,
                          fontFamily: 'Roboto',
                        ),
                      ),
                      const SizedBox(width: 6),
                      if (product.price.mrpPrice > product.price.sellingPrice)
                        Text(
                          "₹${product.price.mrpPrice}",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[400],
                            decoration: TextDecoration.lineThrough,
                            fontFamily: 'Roboto',
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Buy at ₹${(product.price.sellingPrice * 0.95).toInt()}", // Simulation of extra discount labell
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF2E7D32),
                      fontFamily: 'Roboto',
                    ),
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
