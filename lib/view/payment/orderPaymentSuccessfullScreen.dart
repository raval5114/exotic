import 'package:go_router/go_router.dart';
import 'package:exotic/view/payment/orderPaymentCompletionScreen.dart';
import 'package:flutter/material.dart';

class OrderPaymentSuccessfullScreen extends StatefulWidget {
  const OrderPaymentSuccessfullScreen({super.key});

  @override
  State<OrderPaymentSuccessfullScreen> createState() =>
      _OrderPaymentSuccessfullScreenState();
}

class _OrderPaymentSuccessfullScreenState
    extends State<OrderPaymentSuccessfullScreen>
    with TickerProviderStateMixin {
  late final AnimationController _starController;
  late final Animation<double> _starAnimation;

  @override
  void initState() {
    super.initState();
    _starController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _starAnimation = CurvedAnimation(
      parent: _starController,
      curve: Curves.easeOutBack,
    );

    // Start animation on load
    _starController.forward();
    Future.delayed(Duration(seconds: 3), () {
      context.go('/dynamicRoute', extra: () => OrderPaymentCompletionScreen(),
      );
    });
  }

  @override
  void dispose() {
    _starController.dispose();
    super.dispose();
  }

  Widget animatedStar({
    required double top,
    required double left,
    required double size,
  }) {
    return Positioned(
      top: top,
      left: left,
      child: ScaleTransition(
        scale: _starAnimation,
        child: Icon(Icons.star, color: Colors.green, size: size),
      ),
    );
  }

  Widget animatedStarRight({
    required double top,
    required double right,
    required double size,
  }) {
    return Positioned(
      top: top,
      right: right,
      child: ScaleTransition(
        scale: _starAnimation,
        child: Icon(Icons.star, color: Colors.green, size: size),
      ),
    );
  }

  Widget animatedStarBottom({
    required double bottom,
    required double right,
    required double size,
  }) {
    return Positioned(
      bottom: bottom,
      right: right,
      child: ScaleTransition(
        scale: _starAnimation,
        child: Icon(Icons.star, color: Colors.green, size: size),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green.withOpacity(0.1),
                    ),
                  ),
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green.withOpacity(0.2),
                    ),
                  ),
                  Container(
                    width: 60,
                    height: 60,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),

                  // Animated Stars
                  animatedStar(top: 30, left: 30, size: 15),
                  animatedStarBottom(bottom: 25, right: 35, size: 15),
                  animatedStarRight(top: 40, right: 40, size: 10),
                ],
              ),
              const SizedBox(height: 40),
              const Text(
                'Order Placed',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'You saved ₹1234',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.green,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.local_offer, color: Colors.amber, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Scratch for coupon !',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
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
