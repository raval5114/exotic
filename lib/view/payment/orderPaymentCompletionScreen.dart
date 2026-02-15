import 'package:exotic/utils/newProductList.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class OrderPaymentCompletionScreen extends StatelessWidget {
  const OrderPaymentCompletionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.close),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: InkWell(
              onTap: () => context.push('/homescreen'),
              child: Icon(Icons.search),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: InkWell(
              onTap: () => context.push('/cart'),
              child: Icon(Icons.shopping_cart),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            OrderPaymentCompletionComponent(deliveryDate: DateTime.now()),
            //Order
            OrderPaymentAddressCard(
              name: products[0]['delivery']['name'],
              pincode: products[0]['delivery']['pincode'],
              addressLine: products[0]['delivery']['addressLine'],
            ),
            Placeholder(fallbackHeight: 320),
            ListTile(
              leading: Icon(Icons.share, color: Colors.blue),
              title: Text("Share Order Details"),
              trailing: Icon(Icons.arrow_back),
            ),
            ElevatedButton(
              onPressed: () {
                debugPrint("");
              },
              child: Text(
                "Continue Shopping",
                style: GoogleFonts.roboto(
                  fontSize: 15,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OrderPaymentCompletionComponent extends StatelessWidget {
  final DateTime deliveryDate;
  const OrderPaymentCompletionComponent({
    super.key,
    required this.deliveryDate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Thanks for shopping with us !",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  "Delivery by $deliveryDate",
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () {
                    // Handle navigation to order tracking
                  },
                  child: const Text(
                    "Track & manage order",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.green.shade50,
            ),
            padding: const EdgeInsets.all(10),
            child: const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 36,
            ),
          ),
        ],
      ),
    );
  }
}

class OrderPaymentAddressCard extends StatelessWidget {
  final String name;
  final String pincode;
  final String addressLine;
  final VoidCallback? onChange;
  final VoidCallback? onChangeOrAddNumber;

  const OrderPaymentAddressCard({
    super.key,
    required this.name,
    required this.pincode,
    required this.addressLine,
    this.onChange,
    this.onChangeOrAddNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Address details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Text(addressLine),
                Text('Pincode: $pincode'),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: onChangeOrAddNumber,
                  child: const Text(
                    'Change or Add Number',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 14,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Change button
          TextButton(
            style: TextButton.styleFrom(
              shape: BeveledRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              side: BorderSide(),
            ),
            onPressed: onChange,
            child: Text(
              "Change",
              style: GoogleFonts.roboto(
                fontSize: 16,
                color: Colors.blue,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
