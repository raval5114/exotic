import 'package:exotic/controllers/Homescreen/Cart/shared/cartBottomNavbarComponent.dart';
import 'package:exotic/controllers/Homescreen/Cart/shared/cartItemBuilder.dart';
import 'package:exotic/controllers/Homescreen/Cart/shared/cartItemsDetails.dart';
import 'package:exotic/controllers/Homescreen/widgets/homepageItemShowingSection.dart';
import 'package:exotic/controllers/src/appbar.dart';
import 'package:exotic/data/blocs/cart/bloc/cart_bloc.dart';
import 'package:exotic/data/models/cart.dart';
import 'package:exotic/data/providers/cart_provider.dart';
import 'package:exotic/data/providers/user_provider.dart';
import 'package:exotic/controllers/src/ad_blocks/widgets/ad_block.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

class CartComponent extends StatefulWidget {
  const CartComponent({super.key});

  @override
  State<CartComponent> createState() => _CartComponentState();
}

class _CartComponentState extends State<CartComponent> {
  String? cid;
  @override
  void initState() {
    super.initState();
    cid = context.read<UserProvider>().user!.customerId.toString();
    debugPrint(
      "Cid:${context.read<UserProvider>().user!.customerId.toString() ?? ""}",
    );
    context.read<CartBloc>().add(CartFetchingEvent(cid: cid!));
  }

  Widget emptyCartWidget({required VoidCallback onShopNow}) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const AnimatedEmptyCartIcon(),
            const SizedBox(height: 32),
            const Text(
              "Your Cart is Empty",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Color(0xFF2D2D2D),
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              "Looks like you haven't added anything to your cart yet.\nExplore our amazing products and shop now!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onShopNow,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF9747FF),
                foregroundColor: Colors.white,
                elevation: 6,
                shadowColor: const Color(0xFF9747FF).withOpacity(0.4),
                padding: const EdgeInsets.symmetric(
                  horizontal: 34,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                "Explore Products",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartShimmer() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        child: Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 3,
              itemBuilder: (context, index) {
                return Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool isloaded = false;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CartBloc, CartState>(
      listener: (context, state) {
        // TODO: implement listener
        if (state is CartFetchingSuccessState) {
          final Map<String, dynamic> data = state.data;

          final List<Cart> products =
              (data['data']['cart_items'] as List)
                  .map((e) => Cart.fromJson(e as Map<String, dynamic>))
                  .toList();

          context.read<CartProvider>().updateFromApi(
            products: products,
            totalMrp:
                (data['data']['summary']['total_mrp'] as num?)?.toInt() ?? 0,
            totalDiscount:
                (data['data']['summary']['total_discount'] as num?)
                    ?.toDouble() ??
                0.0,
            platformFee:
                (data['data']['summary']['platform_fee'] as num?)?.toInt() ?? 0,
            grandTotal:
                (data['data']['summary']['grand_total'] as num?)?.toDouble() ??
                0.0,
          );
          print("done");
        }
        if (state is CartDeletationSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Item deleted from cart successfully"),
            ),
          );
          context.read<CartProvider>().removeCart(state.CartId);
        }
      },
      builder: (context, state) {
        bool isLoading = state is CartLoadingState || state is CartInitial;
        bool isCartEmpty = context.watch<CartProvider>().cartProducts.isEmpty;

        Widget bodyContent;
        if (isLoading && isCartEmpty) {
          bodyContent = _buildCartShimmer();
        } else if (isCartEmpty) {
          bodyContent = emptyCartWidget(
            onShopNow: () {
              context.go('/home');
            },
          );
        } else {
          bodyContent = SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              child: Column(
                children: [
                  // Dynamic Top Ad Placement
                  const AdBlock(page: 'cart', position: 'top', limit: 2),
                  const SizedBox(height: 12),

                  CartItemBuilder(),
                  const SizedBox(height: 12),

                  // Dynamic Middle Ad Placement
                  const AdBlock(page: 'cart', position: 'middle', limit: 2),
                  const SizedBox(height: 12),

                  CartPriceingComponent(),
                  const SizedBox(height: 12),

                  HomePageItemShowingSection(
                    title: "Recently Viewed",
                    itemList: const [
                      {
                        'productName': 'ESSPY Wall Mounted Toothbrush Holder',
                        'discountedPrice': 129,
                        'initialPrice': 249,
                        'discountPercentage': 48,
                        'rating': 4.1,
                        'reviews': 128,
                        'isFreeShipping': true,
                      },
                      {
                        'productName': 'XEAMUZY Travel Soap Holder Portable',
                        'discountedPrice': 99,
                        'initialPrice': 199,
                        'discountPercentage': 50,
                        'rating': 4.5,
                        'reviews': 432,
                        'isFreeShipping': true,
                      },
                      {
                        'productName': 'Luxury Cotton Bath Towel Set 400 GSM',
                        'discountedPrice': 499,
                        'initialPrice': 999,
                        'discountPercentage': 50,
                        'rating': 4.8,
                        'reviews': 1054,
                        'isFreeShipping': false,
                      },
                      {
                        'productName': 'Anti-slip Bathroom Mat Super Absorbent',
                        'discountedPrice': 299,
                        'initialPrice': 599,
                        'discountPercentage': 50,
                        'rating': 4.3,
                        'reviews': 89,
                        'isFreeShipping': true,
                      },
                    ],
                    frontItemLength: 4,
                  ),
                  const SizedBox(height: 12),

                  // Dynamic Bottom Ad Placement
                  const AdBlock(page: 'cart', position: 'bottom', limit: 2),
                ],
              ),
            ),
          );
        }

        return Scaffold(
          appBar: ExoticAppBar(),
          backgroundColor: Colors.grey.shade50,
          body: bodyContent,
          bottomNavigationBar:
              context.watch<CartProvider>().cartProducts.isNotEmpty
                  ? const CartBottomNavigationBarComponent()
                  : const SizedBox.shrink(),
        );
      },
    );
  }
}

class AnimatedEmptyCartIcon extends StatefulWidget {
  const AnimatedEmptyCartIcon({super.key});

  @override
  State<AnimatedEmptyCartIcon> createState() => _AnimatedEmptyCartIconState();
}

class _AnimatedEmptyCartIconState extends State<AnimatedEmptyCartIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: -10, end: 10).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _animation.value),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF9747FF).withOpacity(0.08),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF9747FF).withOpacity(0.15),
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: const Icon(
              Icons.shopping_cart_outlined,
              size: 40,
              color: Color(0xFF9747FF),
            ),
          ),
        );
      },
    );
  }
}
