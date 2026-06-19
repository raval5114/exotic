import 'package:exotic/controllers/Products/productShellController.dart';
import 'package:exotic/data/blocs/cart/bloc/cart_bloc.dart';
import 'package:exotic/data/blocs/products/bloc/fetch_products_bloc.dart';
import 'package:exotic/data/blocs/products/bloc/fetch_products_event.dart';
import 'package:exotic/data/blocs/wishList/bloc/wishlist_bloc.dart';
import 'package:exotic/data/blocs/wishList/bloc/wishlist_event.dart';
import 'package:exotic/data/blocs/wishList/bloc/wishlist_state.dart';
import 'package:exotic/data/providers/user_provider.dart';
import 'package:exotic/data/providers/wishlist_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

// ─── Grid body ────────────────────────────────────────────────────────────────

class ProductGridController extends StatelessWidget {
  final List<Map<String, dynamic>> items;

  const ProductGridController({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No products found',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    return BlocListener<CartBloc, CartState>(
      listener: (context, state) {
        if (state is CartAddingSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Item added to cart successfully')),
          );
        } else if (state is CartErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errMsg ?? 'Failed to add item')),
          );
        }
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          final itemWidth = (constraints.maxWidth - 36) / 2;
          final aspect = itemWidth / (itemWidth + 145);
          final clampedAspect =
              aspect < 0.5 ? 0.5 : (aspect > 0.8 ? 0.8 : aspect);

          return GridView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: items.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: clampedAspect,
            ),
            itemBuilder: (context, index) {
              return _ProductGridCard(item: items[index]);
            },
          );
        },
      ),
    );
  }
}

// ─── Individual card ──────────────────────────────────────────────────────────

class _ProductGridCard extends StatefulWidget {
  final Map<String, dynamic> item;
  const _ProductGridCard({required this.item});

  @override
  State<_ProductGridCard> createState() => _ProductGridCardState();
}

class _ProductGridCardState extends State<_ProductGridCard> {
  bool _isAdding = false;
  bool _isWishlisting = false;
  bool _isWishlisted = false;

  @override
  void initState() {
    super.initState();
    final pId = _pId;
    if (pId != null) {
      _isWishlisted = context.read<WishlistProvider>().isWishlisted(pId);
    }
  }

  // ── helpers ──────────────────────────────────────────────────────────────

  int? get _pId {
    final raw = widget.item['pId'] ?? widget.item['p_id'];
    if (raw == null) return null;
    return int.tryParse(raw.toString());
  }

  String get _imageUrl {
    final path = (widget.item['imgages'] ?? '').toString();
    if (path.isEmpty) return '';
    if (path.startsWith('http')) return path;
    return 'https://xotic.in/UploadImages/Variant/$path';
  }

  String get _productName =>
      (widget.item['productName'] ?? 'Unknown').toString();

  double get _sellingPrice =>
      (widget.item['discountedPrice'] as num?)?.toDouble() ?? 0.0;

  double get _mrpPrice =>
      (widget.item['initialPrice'] as num?)?.toDouble() ?? 0.0;

  int get _discount => (widget.item['discount'] as num?)?.toInt() ?? 0;

  bool get _isFreeDelivery => widget.item['isFreeDelivery'] == true;

  // ── tap → product detail ──────────────────────────────────────────────────

  void _onTap() {
    final id = _pId;
    if (id == null) return;
    context.read<FetchProductBloc>().add(
      FetchingSingleProductEvent(productid: id.toString()),
    );
    context.push('/dynamicRoute', extra: () => ProductsShell());
  }

  // ── wishlist ──────────────────────────────────────────────────────────────

  void _toggleWishlist() {
    if (_isWishlisting) return;
    final user = context.read<UserProvider>().user;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please login first to use wishlist')),
      );
      return;
    }
    final id = _pId;
    if (id == null) return;

    setState(() => _isWishlisting = true);

    if (_isWishlisted) {
      final provider = context.read<WishlistProvider>();
      try {
        final target = provider.wishlist.firstWhere((e) => e.productId == id);
        context.read<WishlistBloc>().add(
          RemoveWishlistEvent(wishlistid: target.wishlistId),
        );
      } catch (_) {
        setState(() => _isWishlisting = false);
      }
    } else {
      context.read<WishlistBloc>().add(
        AddWishlistEvent(cid: int.parse(user.customerId.toString()), pid: id),
      );
    }
  }

  // ── add to cart ───────────────────────────────────────────────────────────

  void _addToCart() {
    if (_isAdding) return;
    final user = context.read<UserProvider>().user;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please login first to add to cart')),
      );
      return;
    }
    final id = _pId;
    if (id == null) return;

    setState(() => _isAdding = true);
    context.read<CartBloc>().add(
      CartAddingEvent(
        cid: user.customerId.toString(),
        pid: id.toString(),
        quantity: '1',
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<CartBloc, CartState>(
          listener: (context, state) {
            if (_isAdding &&
                (state is CartAddingSuccessState || state is CartErrorState)) {
              setState(() => _isAdding = false);
            }
          },
        ),
        BlocListener<WishlistBloc, WishlistState>(
          listener: (context, state) {
            if (state is WishlistSuccessState &&
                state.wishlist != null &&
                context.mounted) {
              context.read<WishlistProvider>().setWishlist(state.wishlist!);
            }

            if (_isWishlisting) {
              if (state is WishlistActionSuccessState) {
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
                final id = _pId;
                if (id != null) {
                  context.read<WishlistProvider>().removeByProduct(id);
                }
                setState(() {
                  _isWishlisting = false;
                  _isWishlisted = false;
                });
              } else if (state is WishlistFailureState) {
                setState(() => _isWishlisting = false);
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
              // ── Image ─────────────────────────────────────────────────
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
                              _imageUrl.isNotEmpty
                                  ? Image.network(
                                    _imageUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (_, __, ___) => const Center(
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

                    // Discount badge (top-left)
                    if (_discount > 0)
                      Positioned(
                        top: 0,
                        left: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: const BoxDecoration(
                            color: Color(0xFF009688),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12),
                              bottomRight: Radius.circular(8),
                            ),
                          ),
                          child: Text(
                            '$_discount% OFF',
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

                    // Wishlist heart (top-right)
                    Positioned(
                      top: 6,
                      right: 6,
                      child: InkWell(
                        onTap: _toggleWishlist,
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

              // ── Info ──────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _productName,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (_discount > 0) ...[
                          const Icon(
                            Icons.arrow_downward,
                            size: 12,
                            color: Colors.green,
                          ),
                          Text(
                            '$_discount%',
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
                          '₹$_sellingPrice',
                          style: Theme.of(
                            context,
                          ).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(width: 4),
                        if (_mrpPrice > _sellingPrice)
                          Flexible(
                            child: Text(
                              '₹$_mrpPrice',
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

                    // Static 4-star rating row (mirrors ProductViewerCard)
                    Row(
                      children: [
                        ...List.generate(
                          4,
                          (_) => const Icon(
                            Icons.star,
                            size: 10,
                            color: Colors.green,
                          ),
                        ),
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
                      _isFreeDelivery ? 'Free delivery' : 'Paid delivery',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color:
                            _isFreeDelivery
                                ? Colors.grey.shade700
                                : Colors.orange,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),

                    // Add to Cart button
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
                        onPressed: _isAdding ? null : _addToCart,
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
                                  'Add to Cart',
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
