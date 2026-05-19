import 'package:exotic/controllers/Products/productShellController.dart';
import 'package:exotic/data/blocs/cart/bloc/cart_bloc.dart';
import 'package:exotic/data/blocs/products/bloc/fetch_products_bloc.dart';
import 'package:exotic/data/blocs/products/bloc/fetch_products_event.dart';
import 'package:exotic/data/blocs/wishList/bloc/wishlist_bloc.dart';
import 'package:exotic/data/blocs/wishList/bloc/wishlist_event.dart';
import 'package:exotic/data/blocs/wishList/bloc/wishlist_state.dart';
import 'package:exotic/data/providers/user_provider.dart';
import 'package:exotic/view/widgets/searched_items_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:exotic/data/providers/wishlist_provider.dart';

class ProductViewerCard extends StatefulWidget {
  final SearchedItems item;
  const ProductViewerCard({Key? key, required this.item}) : super(key: key);

  @override
  State<ProductViewerCard> createState() => ProductViewerCardState();
}

class ProductViewerCardState extends State<ProductViewerCard> {
  bool _isAdding = false;
  bool _isWishlisting = false;
  bool _isWishlisted = false;

  @override
  void initState() {
    super.initState();
    final provider = context.read<WishlistProvider>();
    _isWishlisted = provider.isWishlisted(
      int.tryParse(widget.item.id.toString()) ?? 0,
    );
  }

  void _onTap() {
    print('working');
    context.read<FetchProductBloc>().add(
      FetchingSingleProductEvent(productid: widget.item.id.toString()),
    );
    context.push('/dynamicRoute', extra: () => ProductsShell());
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;

    final imagePath = item.image ?? '';
    final imageUrl =
        imagePath.isNotEmpty
            ? (imagePath.startsWith('http')
                ? imagePath
                : "https://xotic.in/UploadImages/Variant/$imagePath")
            : "";

    String? tag;
    Color? tagColor;

    if (item.relevanceScore != null && item.relevanceScore! >= 50) {
      tag = "BESTSELLER";
      tagColor = const Color(0xFF009688); // Teal
    } else if (item.stock?.status != "in_stock") {
      tag = "SOLD OUT";
      tagColor = Colors.grey.shade700;
    } else if ((item.price?.discountPercentage ?? 0) > 55) {
      tag = "TRENDING";
      tagColor = Colors.blue.shade600;
    }

    return MultiBlocListener(
      listeners: [
        BlocListener<CartBloc, CartState>(
          listener: (context, state) {
            if (_isAdding &&
                (state is CartAddingSuccessState || state is CartErrorState)) {
              setState(() {
                _isAdding = false;
              });
            }
          },
        ),
        BlocListener<WishlistBloc, WishlistState>(
          listener: (context, state) {
            // Keep provider in sync globally
            if (state is WishlistSuccessState &&
                state.wishlist != null &&
                context.mounted) {
              context.read<WishlistProvider>().setWishlist(state.wishlist!);
            }

            if (_isWishlisting) {
              if (state is WishlistActionSuccessState) {
                // Manually refresh provider to get the new wishlistId for future removals
                context.read<WishlistBloc>().add(
                  FetchWishlistEvent(
                    context.read<UserProvider>().user!.customerId,
                  ),
                );

                setState(() {
                  _isWishlisting = false;
                  _isWishlisted = true;
                });
              } else if (state is WishlistActionRemovedState) {
                // Sync provider explicitly
                context.read<WishlistProvider>().removeByProduct(
                  int.tryParse(item.id.toString()) ?? 0,
                );
                setState(() {
                  _isWishlisting = false;
                  _isWishlisted = false;
                });
              } else if (state is WishlistFailureState) {
                setState(() {
                  _isWishlisting = false;
                });
              }
            }
          },
        ),
      ],
      child: InkWell(
        onTap: _onTap,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
                spreadRadius: 1,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                          bottomLeft: Radius.circular(8),
                          bottomRight: Radius.circular(8),
                        ),
                        child: Container(
                          color: Colors.grey.shade100,
                          child:
                              imageUrl.isNotEmpty
                                  ? Image.network(
                                    imageUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, _, __) => const Center(
                                          child: Icon(
                                            Icons.broken_image,
                                            color: Colors.grey,
                                            size: 40,
                                          ),
                                        ),
                                  )
                                  : const Center(
                                    child: Icon(
                                      Icons.image,
                                      size: 40,
                                      color: Colors.grey,
                                    ),
                                  ),
                        ),
                      ),
                    ),
                    if (tag != null)
                      Positioned(
                        top: 0,
                        left: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: tagColor,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              bottomRight: Radius.circular(8),
                            ),
                          ),
                          child: Text(
                            tag,
                            style: Theme.of(
                              context,
                            ).textTheme.labelSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                    Positioned(
                      top: 6,
                      right: 6,
                      child: InkWell(
                        onTap: () {
                          if (_isWishlisting) return;
                          setState(() {
                            _isWishlisting = true;
                          });
                          try {
                            final user = context.read<UserProvider>().user;
                            if (user == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Please login first to use wishlist",
                                  ),
                                ),
                              );
                              setState(() {
                                _isWishlisting = false;
                              });
                              return;
                            }
                            if (_isWishlisted) {
                              final provider = context.read<WishlistProvider>();
                              final targetId = int.parse(item.id.toString());
                              final target = provider.wishlist.firstWhere(
                                (e) => e.productId == targetId,
                              );

                              context.read<WishlistBloc>().add(
                                RemoveWishlistEvent(
                                  wishlistid: target.wishlistId,
                                ),
                              );
                            } else {
                              context.read<WishlistBloc>().add(
                                AddWishlistEvent(
                                  cid: int.parse(user.customerId.toString()),
                                  pid: int.parse(item.id.toString()),
                                ),
                              );
                            }
                          } catch (e) {
                            setState(() {
                              _isWishlisting = false;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "An error occurred with this item",
                                ),
                              ),
                            );
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.85),
                            shape: BoxShape.circle,
                          ),
                          child:
                              _isWishlisting
                                  ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                  : Icon(
                                    _isWishlisted
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    size: 16,
                                    color:
                                        _isWishlisted
                                            ? Colors.red
                                            : Colors.black87,
                                  ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      item.name ?? item.brand ?? 'Unknown',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (item.brand != null && item.brand!.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        item.brand!,
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall?.copyWith(color: Colors.grey),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    const SizedBox(height: 4),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (item.price?.discountPercentage != null &&
                            item.price!.discountPercentage! > 0) ...[
                          const Icon(
                            Icons.arrow_downward,
                            size: 12,
                            color: Colors.green,
                          ),
                          Text(
                            '${item.price!.discountPercentage}%',
                            style: Theme.of(
                              context,
                            ).textTheme.bodySmall?.copyWith(
                              color: Colors.green,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(width: 4),
                        ],
                        Text(
                          '₹${item.price?.selling ?? 0}',
                          style: Theme.of(
                            context,
                          ).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(width: 4),
                        if (item.price?.mrp != null &&
                            item.price?.mrp != item.price?.selling)
                          Flexible(
                            child: Text(
                              '₹${item.price!.mrp}',
                              style: Theme.of(
                                context,
                              ).textTheme.labelSmall?.copyWith(
                                color: Colors.grey,
                                decoration: TextDecoration.lineThrough,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star, size: 10, color: Colors.green),
                        const Icon(Icons.star, size: 10, color: Colors.green),
                        const Icon(Icons.star, size: 10, color: Colors.green),
                        const Icon(Icons.star, size: 10, color: Colors.green),
                        const Icon(
                          Icons.star_border,
                          size: 10,
                          color: Colors.green,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '(200)',
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(color: Colors.grey.shade500),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.stock?.status == 'in_stock'
                          ? 'Free delivery'
                          : 'Out of stock',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color:
                            item.stock?.status == 'in_stock'
                                ? Colors.grey.shade700
                                : Colors.red,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      height: 32,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF875AFF),
                          padding: const EdgeInsets.symmetric(vertical: 0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        onPressed:
                            _isAdding
                                ? null
                                : () {
                                  setState(() {
                                    _isAdding = true;
                                  });
                                  try {
                                    final user =
                                        context.read<UserProvider>().user;
                                    if (user == null) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            "Please login first to add to cart",
                                          ),
                                        ),
                                      );
                                      setState(() {
                                        _isAdding = false;
                                      });
                                      return;
                                    }
                                    context.read<CartBloc>().add(
                                      CartAddingEvent(
                                        cid: user.customerId.toString(),
                                        pid: item.id.toString(),
                                        quantity: "1",
                                      ),
                                    );
                                  } catch (e) {
                                    setState(() {
                                      _isAdding = false;
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          "An error occurred with this item",
                                        ),
                                      ),
                                    );
                                  }
                                },
                        child:
                            _isAdding
                                ? const SizedBox(
                                  height: 14,
                                  width: 14,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                                : Text(
                                  "Add to Cart",
                                  style: Theme.of(
                                    context,
                                  ).textTheme.bodySmall?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
