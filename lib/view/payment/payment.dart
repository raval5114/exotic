import 'package:exotic/controllers/payment/paymentController.dart';
import 'package:exotic/view/payment/orderPaymentScreen.dart';
import 'package:flutter/material.dart';

class PaymentScreen extends StatelessWidget {
  final String discountedPrice;
  final String intialPrice;
  final Map<String, dynamic> productData;
  const PaymentScreen({
    super.key,
    required this.productData,
    required this.discountedPrice,
    required this.intialPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5,
              offset: Offset(0, -1),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  "₹$intialPrice",
                  style: TextStyle(
                    color: Colors.grey,
                    decoration: TextDecoration.lineThrough,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  "₹${discountedPrice}",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(Icons.info_outline, size: 16, color: Colors.grey),
              ],
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              onPressed: () {
                // TODO: Place order logic
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => OrderPaymentScreen()),
                );
              },
              child: const Text(
                "Place Order",
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
          ],
        ),
      ),

      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(
          "Order Summary",
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 15,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      body: PaymentController(productData: productData),
    );
  }
}
