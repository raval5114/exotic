import 'package:go_router/go_router.dart';
import 'package:exotic/controllers/payment/src/orderPaymentOptionsTile.dart';
import 'package:exotic/view/payment/orderPaymentSuccessfullScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:exotic/data/providers/ad_provider.dart';
import 'package:exotic/data/providers/user_provider.dart';
import 'dart:math';

class OrderPaymentOptions extends StatelessWidget {
  const OrderPaymentOptions({super.key});

  @override
  Widget build(BuildContext context) {
    void onSubmittingCOD() {
      // Generate a mock Order ID for tracking the conversion ROI
      final random = Random();
      final orderId = 100000 + random.nextInt(900000);
      
      final user = context.read<UserProvider>().user;
      final userId = user != null && user.customerId != 0 ? user.customerId : null;
      
      // Perform Ad attribution conversion tracking
      context.read<AdProvider>().attributeOrder(
        orderId: orderId,
        totalValue: 500.0, // Order Total
        userId: userId,
      );
      
      context.go('/dynamicRoute', extra: () => const OrderPaymentSuccessfullScreen());
    }

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(5),
      child: Column(
        children: [
          OrderPaymentOptionsTileExpandable(
            title: 'UPI',
            subtitle: 'Pay by any UPI app',
            leading: const Icon(Icons.account_balance_wallet),
            expandedChild: Text('UPI payment form goes here...'),
          ),
          OrderPaymentOptionsTileExpandable(
            title: 'Credit / Debit / ATM Card',
            subtitle: '5% Unlimited Cashback on Xotic Axis Bank Credit Card',
            leading: const Icon(Icons.credit_card),
            expandedChild: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Card Details Form Placeholder'),
                const SizedBox(height: 8),
                TextField(decoration: InputDecoration(hintText: 'Card Number')),
              ],
            ),
          ),
          const OrderPaymentOptionsTileExpandable(
            title: 'Net Banking',
            leading: Icon(Icons.currency_exchange),
            expandedChild: TextField(
              decoration: InputDecoration(hintText: 'Enter Card no:'),
            ),
          ),
          OrderPaymentOptionsTileExpandable(
            title: 'Cash On Delivery',
            leading: Icon(Icons.currency_rupee_outlined),
            expandedChild: Container(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  Text(
                    "Due to handling costs, a nominal fees of ₹7 will be charged",
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w400,
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Theme.of(context).colorScheme.onSecondaryContainer,
                    ),
                    onPressed: onSubmittingCOD,
                    child: Text(
                      "Place Order",
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const OrderPaymentOptionsTileExpandable(
            title: 'Have a Xotic Gift Card ?',
            leading: Icon(Icons.card_giftcard),
            expandedChild: TextField(
              decoration: InputDecoration(hintText: 'Enter Gift Card Code'),
            ),
          ),
          const OrderPaymentOptionsTileExpandable(
            title: 'Emi',
            leading: Icon(Icons.payments),
            enabled: false,
          ),
          const OrderPaymentOptionsTileExpandable(
            title: 'Wallet',
            leading: Icon(Icons.wallet),
            enabled: false,
          ),
        ],
      ),
    );
  }
}
