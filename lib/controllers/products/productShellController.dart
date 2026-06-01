import 'package:go_router/go_router.dart';
import 'package:exotic/controllers/products/productScreenComponent.dart';
import 'package:exotic/controllers/products/productScreenLoadingController.dart';
import 'package:exotic/data/blocs/cart/bloc/cart_bloc.dart';
import 'package:exotic/data/blocs/products/bloc/fetch_products_bloc.dart';
import 'package:exotic/data/blocs/products/bloc/fetch_products_state.dart';
import 'package:exotic/data/blocs/wishList/bloc/wishlist_bloc.dart';
import 'package:exotic/data/blocs/wishList/bloc/wishlist_event.dart';
import 'package:exotic/data/blocs/wishList/bloc/wishlist_state.dart';
import 'package:exotic/data/models/product_orignal.dart';
import 'package:exotic/data/providers/product_provider.dart';
import 'package:exotic/data/providers/user_provider.dart';
import 'package:exotic/data/providers/wishlist_provider.dart';
import 'package:exotic/view/homescreen/sections/cart.dart';
import 'package:exotic/view/payment/payment.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ─── Brand tokens ─────────────────────────────────────────────────────────────
const _kBrandPrimary = Color(0xFF7C3AED);
const _kBrandSecondary = Color(0xFF9747FF);
const _kBrandPink = Color(0xFFE94A75);

// ─── Spacing tokens ───────────────────────────────────────────────────────────
const _kSpaceXS = 4.0;
const _kSpaceSM = 8.0;
const _kSpaceMD = 12.0;
const _kSpaceLG = 16.0;
const _kSpaceXL = 20.0;
const _kSpaceXXL = 24.0;

// ─── Radius tokens ────────────────────────────────────────────────────────────
const _kRadiusSM = 8.0;
const _kRadiusMD = 12.0;
const _kRadiusLG = 16.0;

class ProductsShell extends StatefulWidget {
  const ProductsShell({super.key});

  @override
  State<ProductsShell> createState() => _ProductsShellState();
}

class _ProductsShellState extends State<ProductsShell> {
  void _addToCart(BuildContext context) {
    final productProvider = context.read<ProductProvider>();
    final product = productProvider.product!;

    String? pvId;
    if (product.pType == "1" && product.variants != null) {
      pvId = product.variants![productProvider.selectedIndex].pvid;
    }

    HapticFeedback.selectionClick();
    context.read<CartBloc>().add(
      CartAddingEvent(
        cid: context.read<UserProvider>().user!.customerId.toString(),
        pid: product.pId!,
        pvid: pvId,
        quantity: "1",
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CartBloc, CartState>(
      listener: (context, state) {
        if (state is CartAddingSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(
                    Icons.check_circle_outline_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                  const SizedBox(width: _kSpaceSM),
                  Text(
                    "Added to cart!",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              backgroundColor: const Color(0xFF16A34A),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(_kRadiusMD),
              ),
              margin: const EdgeInsets.all(_kSpaceLG),
              duration: const Duration(seconds: 2),
            ),
          );
        }
        if (state is CartErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.errMsg ?? "Failed to add item",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              backgroundColor: const Color(0xFFDC2626),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(_kRadiusMD),
              ),
              margin: const EdgeInsets.all(_kSpaceLG),
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is CartLoadingState;

        return Scaffold(
          backgroundColor: const Color(0xFFF1F3F6),
          body: BlocConsumer<FetchProductBloc, FetchProductState>(
            listener: (context, state) {
              if (state is FetchProductFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.error),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(_kRadiusMD),
                    ),
                    margin: const EdgeInsets.all(_kSpaceLG),
                  ),
                );
              }
            },
            builder: (context, state) {
              if (state is FetchProductLoading) {
                return ProductScreenLoadingController();
              }
              if (state is FetchSingleProductSuccess) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (context.mounted) {
                    context.read<ProductProvider>().setProduct(
                      ProductModel.fromJson(state.product['data']),
                    );
                  }
                });
                return ProductScreenComponent();
              }
              if (state is FetchProductFailure) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(_kSpaceXL),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.error_outline_rounded,
                          size: 48,
                          color: Color(0xFFDC2626),
                        ),
                        const SizedBox(height: _kSpaceMD),
                        Text(
                          state.error,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: Colors.black54),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
          bottomSheet: _bottomBar(context, isLoading),
          appBar: _appBar(context),
        );
      },
    );
  }

  PreferredSizeWidget _appBar(BuildContext context) {
    final theme = Theme.of(context);
    return AppBar(
      backgroundColor: _kBrandPrimary,
      elevation: 0,
      scrolledUnderElevation: 0,
      toolbarHeight: 60,
      leading: Padding(
        padding: const EdgeInsets.only(left: _kSpaceXS),
        child: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: 20,
          ),
          tooltip: 'Go back',
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      title: Container(
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.96),
          borderRadius: BorderRadius.circular(_kRadiusSM),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TextField(
          style: theme.textTheme.bodyMedium?.copyWith(color: Colors.black87),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'Search products...',
            hintStyle: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.black38,
            ),
            prefixIcon: const Icon(
              Icons.search_rounded,
              color: Colors.black38,
              size: 20,
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 10),
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: _kSpaceMD),
          child: InkWell(
            onTap:
                () => context.push('/dynamicRoute', extra: () => CartScreen()),
            borderRadius: BorderRadius.circular(_kRadiusSM),
            splashColor: Colors.white.withOpacity(0.15),
            highlightColor: Colors.white.withOpacity(0.08),
            child: Container(
              padding: const EdgeInsets.all(_kSpaceSM),
              child: const Icon(
                Icons.shopping_cart_outlined,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _bottomBar(BuildContext context, bool isLoading) {
    final theme = Theme.of(context);
    return Container(
      // Consistent horizontal & vertical padding per 8-pt grid
      padding: const EdgeInsets.symmetric(
        horizontal: _kSpaceLG,
        vertical: _kSpaceMD,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey.withOpacity(0.12), width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // ── Wishlist icon ──────────────────────────────────────────────
            Builder(
              builder: (context) {
                final productProvider = context.watch<ProductProvider>();
                final product = productProvider.product;

                if (product == null || product.pId == null) {
                  return _WishlistIconButton(
                    isWishlisted: false,
                    isLoading: false,
                    onTap: () {},
                  );
                }

                final wishlistProvider = context.watch<WishlistProvider>();
                final productId = int.tryParse(product.pId!) ?? 0;
                final isWishlisted = wishlistProvider.isWishlisted(productId);

                return BlocConsumer<WishlistBloc, WishlistState>(
                  listener: (context, state) {
                    if (state is WishlistSuccessState &&
                        state.wishlist != null &&
                        context.mounted) {
                      context.read<WishlistProvider>().setWishlist(
                        state.wishlist!,
                      );
                    }
                    if (state is WishlistActionSuccessState) {
                      context.read<WishlistBloc>().add(
                        FetchWishlistEvent(
                          context.read<UserProvider>().user!.customerId,
                        ),
                      );
                    }
                    if (state is WishlistActionRemovedState) {
                      context.read<WishlistProvider>().removeByProduct(
                        productId,
                      );
                    }
                  },
                  builder: (context, state) {
                    final isWishlisting = state is WishlistLoadingState;
                    return _WishlistIconButton(
                      isWishlisted: isWishlisted,
                      isLoading: isWishlisting,
                      onTap: () {
                        if (isWishlisting) return;
                        final user = context.read<UserProvider>().user;
                        if (user == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Please login first",
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(_kRadiusMD),
                              ),
                              margin: const EdgeInsets.all(_kSpaceLG),
                            ),
                          );
                          return;
                        }
                        if (isWishlisted) {
                          final target = wishlistProvider.wishlist.firstWhere(
                            (e) => e.productId == productId,
                          );
                          context.read<WishlistBloc>().add(
                            RemoveWishlistEvent(wishlistid: target.wishlistId),
                          );
                        } else {
                          context.read<WishlistBloc>().add(
                            AddWishlistEvent(
                              cid: user.customerId,
                              pid: productId,
                            ),
                          );
                        }
                      },
                    );
                  },
                );
              },
            ),

            const SizedBox(width: _kSpaceMD),

            // ── Add to Cart ────────────────────────────────────────────────
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _kBrandPrimary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  // Use the 8-pt grid: 14px top/bottom padding
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(_kRadiusMD),
                  ),
                ),
                onPressed: isLoading ? null : () => _addToCart(context),
                child:
                    isLoading
                        ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                        : Text(
                          "Add to Cart",
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.3,
                          ),
                        ),
              ),
            ),

            const SizedBox(width: _kSpaceSM + 2),

            // ── Buy Now ────────────────────────────────────────────────────
            Expanded(
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: _kBrandSecondary,
                  side: const BorderSide(color: _kBrandSecondary, width: 1.5),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(_kRadiusMD),
                  ),
                ),
                onPressed: () {
                  context.push(
                    '/dynamicRoute',
                    extra:
                        () => PaymentScreen(
                          productData: {},
                          discountedPrice: '10000',
                          intialPrice: '13000',
                        ),
                  );
                },
                child: Text(
                  "Buy Now",
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: _kBrandSecondary,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Reusable wishlist icon button ────────────────────────────────────────────
class _WishlistIconButton extends StatelessWidget {
  final bool isWishlisted;
  final bool isLoading;
  final VoidCallback onTap;

  const _WishlistIconButton({
    required this.isWishlisted,
    required this.isLoading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: isWishlisted ? 'Remove from wishlist' : 'Add to wishlist',
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color:
                isWishlisted
                    ? _kBrandPink.withOpacity(0.08)
                    : Colors.grey.withOpacity(0.08),
            borderRadius: BorderRadius.circular(_kRadiusMD),
            border: Border.all(
              color:
                  isWishlisted
                      ? _kBrandPink.withOpacity(0.3)
                      : Colors.grey.withOpacity(0.2),
              width: 1.2,
            ),
          ),
          child:
              isLoading
                  ? const Center(
                    child: SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: _kBrandPink,
                      ),
                    ),
                  )
                  : AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    transitionBuilder:
                        (child, animation) =>
                            ScaleTransition(scale: animation, child: child),
                    child: Icon(
                      isWishlisted
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      key: ValueKey(isWishlisted),
                      color: isWishlisted ? _kBrandPink : Colors.black54,
                      size: 22,
                    ),
                  ),
        ),
      ),
    );
  }
}
