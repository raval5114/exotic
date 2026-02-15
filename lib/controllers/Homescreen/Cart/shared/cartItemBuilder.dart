import 'dart:async';

import 'package:exotic/controllers/Homescreen/Cart/shared/src/cartTile.dart';
import 'package:exotic/data/blocs/cart/bloc/cart_bloc.dart';
import 'package:exotic/data/models/cart.dart';
import 'package:exotic/data/providers/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartItemBuilder extends StatefulWidget {
  const CartItemBuilder({super.key});

  @override
  State<CartItemBuilder> createState() => _CartItemBuilderState();
}

class _CartItemBuilderState extends State<CartItemBuilder> {
  // =========================
  // DEBOUNCE HANDLER
  // =========================
  Timer? _debounceTimer;

  static const Duration _debounceDuration = Duration(milliseconds: 500);

  void _debounce(VoidCallback action) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(_debounceDuration, action);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }

  // =========================
  // EVENT HANDLERS
  // =========================

  void onRemove(String cartId) {
    context.read<CartBloc>().add(CartDeletingEvent(cartid: cartId));
  }

  void onAdd(int cartId) {
    // Optimistic UI update
    context.read<CartProvider>().addQuantity(cartId);

    _debounce(() {
      context.read<CartBloc>().add(
        CartUpdateEvent(cartid: cartId.toString(), action: ActionType.increase),
      );
    });
  }

  void onMinus(int cartId) {
    // Prevent negative quantity
    final product = context.read<CartProvider>().cartProducts.firstWhere(
      (e) => e.cartId == cartId,
    );

    if (product.quantity <= 1) return;

    // Optimistic UI update
    context.read<CartProvider>().minusQuantity(cartId);

    _debounce(() {
      context.read<CartBloc>().add(
        CartUpdateEvent(cartid: cartId.toString(), action: ActionType.decrease),
      );
    });
  }

  void buyThisNow(Cart product) {
    // TODO
  }

  void saveForLater(Cart product) {
    // TODO
  }

  // =========================
  // BLOC LISTENER
  // =========================

  void _cartBlocListener(BuildContext context, CartState state) {
    if (state is CartErrorState) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Failed to update cart")));
    }
  }

  // =========================
  // UI
  // =========================

  @override
  Widget build(BuildContext context) {
    final List<Cart> products = context.watch<CartProvider>().cartProducts;

    if (products.isEmpty) {
      return const Center(child: Text("No items available in cart"));
    }

    return BlocListener<CartBloc, CartState>(
      listener: _cartBlocListener,
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];

          return InkWell(
            onTap: () {},
            child: CartTile(
              productName: product.name,
              category: product.sku,
              sellerName: 'Exotic Seller',
              itemsForOff: 0,
              priceForOff: 0,
              discount: product.discount,
              discountedPrice: product.finalPrice,
              intialPrice: product.mrp.toDouble(),
              image: product.image,
              quantity: product.quantity,
              deliveryBy: DateTime.now(),
              isFreeDelivery: product.freeShipping == 1,

              // ---------- Actions ----------
              onRemove: () => onRemove(product.cartId.toString()),
              buyThisNow: () => buyThisNow(product),
              saveForLater: () => saveForLater(product),
              onAdd: () => onAdd(product.cartId),
              onMinus: () => onMinus(product.cartId),
            ),
          );
        },
      ),
    );
  }
}
