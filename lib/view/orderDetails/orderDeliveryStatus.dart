import 'package:exotic/controllers/orderDetails/animatedDeliveyStatusComponent.dart';
import 'package:exotic/controllers/orderDetails/orderDetailsDeliveryStatusComponent.dart';
import 'package:exotic/controllers/orderDetails/src/deliveyStatusStep.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OrderDeliveryStatusPage extends StatelessWidget {
  final List<DeliveryStatusStep> steps;

  const OrderDeliveryStatusPage({super.key, required this.steps});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
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
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: AnimatedDeliveryTimeline(steps: steps),
      ),
    );
  }
}
