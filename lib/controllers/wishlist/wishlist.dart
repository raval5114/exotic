import 'package:go_router/go_router.dart';
import 'package:exotic/controllers/wishlist/src/wishlist_emty.dart';
import 'package:exotic/data/blocs/wishList/bloc/wishlist_bloc.dart';
import 'package:exotic/data/blocs/wishList/bloc/wishlist_event.dart';
import 'package:exotic/data/blocs/wishList/bloc/wishlist_state.dart';
import 'package:exotic/data/providers/user_provider.dart';
import 'package:exotic/data/providers/wishlist_provider.dart';
import 'package:exotic/view/products/productScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WishlistComponent extends StatefulWidget {
  const WishlistComponent({super.key});

  @override
  State<WishlistComponent> createState() => _WishlistComponentState();
}

class _WishlistComponentState extends State<WishlistComponent> {
  Widget wishlistCard({
    required String title,
    required String subtitle,
    required String discount,
    required String mrp,
    required String finalPrice,
    required String image,
    required VoidCallback onRemove,
    required VoidCallback onAddToCart,
  }) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// IMAGE
            Container(
              height: 179,
              width: double.infinity,
              color: Colors.grey.shade200,
              child: Stack(
                children: [
                  Positioned(
                    top: 10,
                    right: 10,
                    child: GestureDetector(
                      onTap: onRemove,
                      child: const CircleAvatar(
                        radius: 10,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.close, size: 16, color: Colors.black),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Image.network(
                      image,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(
                          child: CircularProgressIndicator(strokeWidth: 1.5),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Icon(
                            Icons.image_not_supported,
                            size: 40,
                            color: Colors.grey,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 6),

            /// TITLE
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),

            /// SUBTITLE
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              child: Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 12,
                  color: Colors.grey.shade700,
                ),
              ),
            ),

            /// PRICE
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              child: Wrap(
                spacing: 4,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.arrow_downward,
                        size: 14,
                        color: Color(0xFF0FBF3E),
                      ),
                      Text(
                        "$discount%",
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          color: const Color(0xFF0FBF3E),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    finalPrice,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    mrp,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 12,
                      decoration: TextDecoration.lineThrough,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 6),

            /// ADD TO CART
            Center(
              child: SizedBox(
                width: 160,
                height: 32,
                child: OutlinedButton(
                  onPressed: onAddToCart,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF9747FF)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.zero,
                  ),
                  child: const Text(
                    "Add to Cart",
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 14,
                      color: Color(0xFF9747FF),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    context.read<WishlistBloc>().add(
      FetchWishlistEvent(context.read<UserProvider>().user!.customerId),
    );
  }

  @override
  Widget build(BuildContext context) {
    final wishlistProvider = context.watch<WishlistProvider>();

    return BlocConsumer<WishlistBloc, WishlistState>(
      listener: (context, state) {
        /// FETCH SUCCESS
        if (state is WishlistSuccessState && state.wishlist != null) {
          wishlistProvider.setWishlist(state.wishlist);
        }

        /// ADD TO CART SUCCESS
        if (state is WishlistAddedToCartState) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text("Item added to cart")));
        }

        /// ERROR
        if (state is WishlistFailureState) {
          print(state.error);
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.error)));
        }
        if (state is WishlistActionRemovedState) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text("Item Removed")));
          context.read<WishlistProvider>().removeByProduct(state.wishlistid);
        }
      },
      builder: (context, state) {
        /// LOADING
        if (state is WishlistLoadingState &&
            wishlistProvider.wishlist.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        /// EMPTY
        if (wishlistProvider.wishlist.isEmpty) {
          return EmptyWishlistWidget();
        }

        /// UI
        return SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Container(
                    margin: const EdgeInsets.only(left: 15),
                    child: Text(
                      "Your Wishlist",
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: wishlistProvider.wishlist.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisExtent: 340,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                          ),
                      itemBuilder: (context, index) {
                        final item = wishlistProvider.wishlist[index];

                        return InkWell(
                          onTap: () {
                            context.push('/dynamicRoute', extra: () => const ProductScreen(),
                            );
                          },
                          child: wishlistCard(
                            title: item.productName,
                            subtitle: item.brandName,

                            discount: item.discount.toString(),
                            mrp: "₹${item.mrp}",
                            finalPrice: "₹${item.finalPrice}",
                            image: item.image,
                            onRemove: () {
                              context.read<WishlistProvider>().removeByProduct(
                                item.productId,
                              );
                              context.read<WishlistBloc>().add(
                                RemoveWishlistEvent(
                                  wishlistid: item.wishlistId,
                                ),
                              );
                            },
                            onAddToCart: () {
                              context.read<WishlistBloc>().add(
                                AddWishlistItemToCartEvent(
                                  customerId:
                                      context
                                          .read<UserProvider>()
                                          .user!
                                          .customerId,
                                  productId: item.productId,
                                  variantId: item.variantId,
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
