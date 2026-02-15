import 'package:exotic/controllers/orderDetails/orderDetailsComponent.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class OrderdetailsPage extends StatelessWidget {
  final Map<String, dynamic> product;
  const OrderdetailsPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Order Details",
          style: GoogleFonts.roboto(fontSize: 17, fontWeight: FontWeight.w400),
        ),
        actions: [
          IconButton(
            tooltip: 'Search',
            icon: const Icon(Icons.search, color: Colors.black87),
            onPressed: () => context.push('/searchProductPage'),
          ),
          IconButton(
            tooltip: 'Cart',
            icon: const Icon(
              Icons.shopping_cart_outlined,
              color: Colors.black87,
            ),
            onPressed: () => context.push('/cart'),
          ),
        ],
      ),
      body: OrderdetailsController(product: product),
      backgroundColor: Colors.grey.shade300,
    );
  }
}
