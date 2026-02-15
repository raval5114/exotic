import 'package:exotic/controllers/payment/orderPaymentOptions.dart';
import 'package:exotic/controllers/payment/src/orderPaymentAmountShowing.dart';
import 'package:flutter/material.dart';

class OrderPaymentComponent extends StatefulWidget {
  const OrderPaymentComponent({super.key});

  @override
  State<OrderPaymentComponent> createState() => _OrderPaymentComponentState();
}

class _OrderPaymentComponentState extends State<OrderPaymentComponent> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          OrderPaymentAmountShowing(totalAmount: 500, cashbackAmount: 5),
          OrderPaymentOptions(),
          Container(
            color: Colors.grey[200], // light gray background
            width: double.infinity,
            height: 150, // adjust as needed
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Too many happy\ncustomers to count !',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 12),
                Icon(
                  Icons.sentiment_satisfied_alt,
                  color: Colors.grey,
                  size: 32,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
