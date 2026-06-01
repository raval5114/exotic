import 'package:go_router/go_router.dart';
import 'package:exotic/controllers/Products/productShellController.dart';
import 'package:exotic/data/blocs/products/bloc/fetch_products_bloc.dart';
import 'package:exotic/data/blocs/products/bloc/fetch_products_event.dart';
import 'package:exotic/data/models/Homepage/elements/Items/ProductItem.dart';
import 'package:exotic/data/models/Homepage/elements/configs/mobile_suggestion.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                config.sectionTitle.isNotEmpty ? config.sectionTitle : title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF111827),
                  fontFamily: 'Roboto',
                  letterSpacing: -0.3,
                ),
              ),
            ),
            if (config.viewAllLink.isNotEmpty)
              GestureDetector(
                onTap: () {
                  // TODO: Handle view all link
                },
                child: Row(
                  children: [
                    const Text(
                      "View All",
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF7C3AED),
                      ),
                    ),
                    const SizedBox(width: 2),
                    Container(
                      width: 20,
                      height: 20,
                      decoration: const BoxDecoration(
                        color: Color(0xFF7C3AED),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_forward_rounded,
                        size: 13,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),

        // Product cards slider
        SizedBox(
          height: 310,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: products.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              return MobileSuggestionCard(
                product: products[index],
                onTap: () {
                  context.read<FetchProductBloc>().add(
                    FetchingSingleProductEvent(
                      productid: products[index].productId.toString(),
                    ),
                  );
                  context.push('/dynamicRoute', extra: () => ProductsShell());
                },
              );
            },
          ),
        ),
      ],
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
        width: 168,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.withOpacity(0.10)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 14,
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
                    height: 168,
                    width: 168,
                    child: Hero(
                      tag: "product_img_${product.productId}",
                      child: Image.network(
                        product.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, url, error) => const Center(
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
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                  ),

                // Rating Badge
                if (double.tryParse(product.rating.average) != null &&
                    double.parse(product.rating.average) > 0)
                  Positioned(
                    bottom: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.95),
                        borderRadius: BorderRadius.circular(6),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            product.rating.average,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(width: 2),
                          const Icon(
                            Icons.star_rounded,
                            size: 12,
                            color: Color(0xFF16A34A),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),

            // Content
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1F2937),
                      height: 1.25,
                      fontFamily: 'Roboto',
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Price row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        "₹${product.price.sellingPrice.toInt()}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF111827),
                          fontFamily: 'Roboto',
                        ),
                      ),
                      const SizedBox(width: 6),
                      if (product.price.mrpPrice > product.price.sellingPrice)
                        Text(
                          "₹${product.price.mrpPrice.toInt()}",
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black38,
                            decoration: TextDecoration.lineThrough,
                            fontFamily: 'Roboto',
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 5),

                  // Savings indicator
                  Text(
                    "Save ₹${(product.price.mrpPrice - product.price.sellingPrice).toInt()}",
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF16A34A),
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
