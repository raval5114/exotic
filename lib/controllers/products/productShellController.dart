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
import 'package:flutter_bloc/flutter_bloc.dart';

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
            const SnackBar(content: Text("Item added to cart successfully")),
          );
        }
        if (state is CartErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errMsg ?? "Failed to add item")),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is CartLoadingState;

        return Scaffold(
          backgroundColor: Colors.grey[300],

          /// ⬇️ CHILD GOES HERE
          body: BlocConsumer<FetchProductBloc, FetchProductState>(
            listener: (context, state) {
              if (state is FetchProductFailure) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.error)));
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
                return Center(child: Text(state.error));
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
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      centerTitle: true,
      title: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Theme.of(context).colorScheme.onSecondaryContainer,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.only(top: 20, bottom: 20, right: 20),
        width: 259,
        height: 39,
        child: const TextField(
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'Search',
          ),
        ),
      ),
      actions: [
        InkWell(
          onTap: () => context.push('/dynamicRoute', extra: () => CartScreen()),
          child: Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(
              Icons.shopping_cart_outlined,
              size: 28,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }

  Widget _bottomBar(BuildContext context, bool isLoading) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
      color: Colors.white,
      child: Row(
        children: [
          Builder(
            builder: (context) {
              final productProvider = context.watch<ProductProvider>();
              final product = productProvider.product;

              if (product == null || product.pId == null) {
                return const Icon(
                  Icons.favorite_border,
                  color: Colors.grey,
                  size: 30,
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
                    context.read<WishlistProvider>().removeByProduct(productId);
                  }
                },
                builder: (context, state) {
                  final bool isWishlisting = state is WishlistLoadingState;

                  return InkWell(
                    onTap: () {
                      if (isWishlisting) return;

                      final user = context.read<UserProvider>().user;
                      if (user == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Please login first")),
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
                    child:
                        isWishlisting
                            ? const SizedBox(
                              width: 30,
                              height: 30,
                              child: Padding(
                                padding: EdgeInsets.all(4.0),
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            )
                            : Icon(
                              isWishlisted
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: isWishlisted ? Colors.red : Colors.black,
                              size: 30,
                            ),
                  );
                },
              );
            },
          ),
          const SizedBox(width: 10),
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF875AFF),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: isLoading ? null : () => _addToCart(context),
              child: Text(
                isLoading ? "Adding..." : "Add to cart",
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'Roboto',
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0060FF),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
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
              child: const Text(
                "Buy Now",
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Roboto',
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
