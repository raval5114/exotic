import 'package:exotic/controllers/products/productScreenComponent.dart';
import 'package:exotic/data/blocs/cart/bloc/cart_bloc.dart';
import 'package:exotic/data/blocs/wishList/bloc/wishlist_bloc.dart';
import 'package:exotic/data/blocs/wishList/bloc/wishlist_event.dart';
import 'package:exotic/data/blocs/wishList/bloc/wishlist_state.dart';
import 'package:exotic/data/models/product_orignal.dart';
import 'package:exotic/data/providers/product_provider.dart';
import 'package:exotic/data/providers/user_provider.dart';
import 'package:exotic/view/homescreen/sections/cart.dart';
import 'package:exotic/view/payment/payment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ProductsScreenController extends StatefulWidget {
  const ProductsScreenController({super.key});

  @override
  State<ProductsScreenController> createState() =>
      _ProductsScreenControllerState();
}

class _ProductsScreenControllerState extends State<ProductsScreenController> {
  /// ---------------- ADD TO CART EVENT ----------------
  void _addToCart(BuildContext context) {
    final productProvider = context.read<ProductProvider>();
    final ProductModel product = productProvider.product!;
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
        final bool isLoading = state is CartLoadingState;
        return Scaffold(
          backgroundColor: Colors.grey[300],
          bottomSheet: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
            color: Colors.white,
            child: Row(
              children: [
                BlocBuilder<WishlistBloc, WishlistState>(
                  builder: (context, state) {
                    final bool isWishlisted =
                        state is WishlistActionSuccessState;
                    return InkWell(
                      onTap: () {
                        context.read<WishlistBloc>().add(
                          AddWishlistEvent(
                            cid: context.read<UserProvider>().user!.customerId,
                            pid: int.parse(
                              context.read<ProductProvider>().product!.pId!,
                            ),
                          ),
                        );
                      },
                      child: Icon(
                        isWishlisted ? Icons.favorite : Icons.favorite_border,
                        color: isWishlisted ? Colors.red : Colors.black,
                        size: 30,
                      ),
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
                      style: GoogleFonts.roboto(
                        color: Colors.white,
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => PaymentScreen(
                                productData: {},
                                discountedPrice: '10000',
                                intialPrice: '13000',
                              ),
                        ),
                      );
                    },
                    child: Text(
                      "Buy Now",
                      style: GoogleFonts.roboto(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          appBar: AppBar(
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
                onTap:
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CartScreen()),
                    ),
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
          ),
          body: const ProductScreenComponent(),
        );
      },
    );
  }
}
