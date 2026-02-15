import 'package:exotic/controllers/Homescreen/Cart/shared/cartBottomNavbarComponent.dart';
import 'package:exotic/controllers/Homescreen/Cart/shared/cartItemBuilder.dart';
import 'package:exotic/controllers/Homescreen/Cart/shared/cartItemsDetails.dart';
import 'package:exotic/controllers/Homescreen/widgets/homepageItemShowingSection.dart';
import 'package:exotic/controllers/src/appbar.dart';
import 'package:exotic/data/blocs/cart/bloc/cart_bloc.dart';
import 'package:exotic/data/models/cart.dart';
import 'package:exotic/data/models/product_orignal.dart';
import 'package:exotic/data/providers/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartScreenTesting extends StatelessWidget {
  const CartScreenTesting({super.key});

  @override
  Widget build(BuildContext context) {
    return CartScreenTestingComponent();
  }
}

class CartScreenTestingComponent extends StatefulWidget {
  const CartScreenTestingComponent({super.key});

  @override
  State<CartScreenTestingComponent> createState() =>
      _CartScreenTestingComponentState();
}

class _CartScreenTestingComponentState
    extends State<CartScreenTestingComponent> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<CartBloc>().add(CartFetchingEvent(cid: "5"));
  }

  Widget emptyCartWidget({
    required VoidCallback onShopNow,
    String title = "Your cart is empty!",
    String buttonText = "Shop now",
    String imageAsset = "assets/images/empty_cart.png",
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Cart Image / Icon
          Image.asset(imageAsset, height: 140, fit: BoxFit.contain),

          const SizedBox(height: 20),

          // Title
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),

          const SizedBox(height: 16),

          // Button
          ElevatedButton(
            onPressed: onShopNow,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              buttonText,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

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
            totalMrp: data['data']['summary']['total_mrp'],
            totalDiscount: data['data']['summary']['total_discount'],
            platformFee: data['data']['summary']['platform_fee'],
            grandTotal: data['data']['summary']['grand_total'],
          );
          print("done");
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: ExoticAppBar(),
          body:
              context.read<CartProvider>().cartProducts.isEmpty
                  ? emptyCartWidget(onShopNow: () {})
                  : SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: Column(
                        children: [
                          //CartItmeBuilder(),
                          CartPriceingComponent(),
                          HomePageItemShowingSection(
                            title: "Recently Viewed",
                            itemList: [],
                            frontItemLength: 4,
                          ),
                        ],
                      ),
                    ),
                  ),
          bottomNavigationBar:
              context.watch<CartProvider>().cartProducts.isNotEmpty
                  ? const CartBottomNavigationBarComponent()
                  : const SizedBox.shrink(),
        );
      },
    );
  }
}
