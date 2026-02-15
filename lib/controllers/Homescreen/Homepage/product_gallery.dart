import 'package:exotic/controllers/products/productShellController.dart';
import 'package:exotic/data/blocs/products/bloc/fetch_products_bloc.dart';
import 'package:exotic/data/blocs/products/bloc/fetch_products_event.dart';
import 'package:exotic/data/models/Homepage/elements/Items/ProductItem.dart';
import 'package:exotic/data/models/Homepage/elements/configs/ProductGalleryConfig.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductGalleryWidget extends StatelessWidget {
  final String title;
  final ProductGalleryConfig config;
  final List<ProductItem> products; // your product model list

  const ProductGalleryWidget({
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
        _Header(
          title: config.galleryTitle.isNotEmpty ? config.galleryTitle : title,
          viewMoreUrl: config.viewMoreUrl,
        ),

        const SizedBox(height: 12),

        SizedBox(
          height: 260,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: products.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              return ProductCard(
                product: products[index],
                fields: config.fields,
                ontTap: () {
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
    );
  }
}

class _Header extends StatelessWidget {
  final String title;
  final String viewMoreUrl;
  const _Header({required this.title, required this.viewMoreUrl});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),

          if (viewMoreUrl.isNotEmpty)
            InkWell(
              onTap: () {
                // TODO: open viewMoreUrl
              },
              child: const Text(
                "View More",
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.blue,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final ProductItem product;
  final GalleryFields fields;
  final VoidCallback ontTap;

  const ProductCard({
    required this.product,
    required this.fields,
    required this.ontTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontTap,
      child: Container(
        width: 160,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🖼 Image
            if (fields.image)
              Expanded(
                child: Image.network(product.imageUrl, fit: BoxFit.contain),
              ),

            const SizedBox(height: 6),

            // 🏷 Name
            if (fields.name)
              Text(
                product.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),

            const SizedBox(height: 4),

            // 💰 Price row
            if (fields.price || fields.mrp)
              Row(
                children: [
                  if (fields.price)
                    Text(
                      "₹${product.price.sellingPrice}",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                  const SizedBox(width: 6),

                  if (fields.mrp)
                    Text(
                      "₹${product.price.mrpPrice}",
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.grey,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                ],
              ),

            // 🔥 Discount
            if (fields.discount)
              Text(
                "${product.price.discountPercentage}% OFF",
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.green,
                  fontWeight: FontWeight.w600,
                ),
              ),

            // ⭐ Rating
            if (fields.rating && int.parse(product.rating.average) > 0)
              Row(
                children: [
                  const Icon(Icons.star, size: 14, color: Colors.orange),
                  const SizedBox(width: 4),
                  Text(
                    product.rating.average.toString(),
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
