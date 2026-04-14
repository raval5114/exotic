import 'package:exotic/view/orderCancelationPages/orderCancelPageConfirmation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OrderCancelPage extends StatelessWidget {
  final Map<String, dynamic> product;

  const OrderCancelPage({super.key, required this.product});
  @override
  Widget build(BuildContext context) {
    final TextEditingController _controller = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Request Cancellation",
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 17,
            fontWeight: FontWeight.w400,
          ),
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
      backgroundColor: Colors.grey.shade200,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// PRODUCT BOX
            Container(
              margin: const EdgeInsets.symmetric(vertical: 5),
              padding: const EdgeInsets.symmetric(vertical: 23, horizontal: 17),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Left: Product Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product['productName'] ?? 'Product Name',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Qty: ${product['qty'] ?? "0"}",
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "₹${product['price'] ?? "0"}",
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// Right: Product Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      product['image'] ??
                          "assets/images/categories/categories_auto.png",
                      width: 65,
                      height: 65,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),

            /// REASON FOR CANCELLATION BOX
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Reason For Cancellation",
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Radio(
                        value: true,
                        groupValue: true,
                        onChanged: (_) {}, // Static selection for now
                        activeColor: Colors.blue,
                      ),
                      Expanded(
                        child: Text(
                          "Price of the product has now decreased",
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // TODO: Show reason selection modal
                        },
                        child: Text(
                          "Change",
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 6),
            CommentInputField(controller: _controller),
            SizedBox(height: 10),
            SubmitRequestButton(
              onPressed: () {
                if (_controller.text.toString() != null) {
                  context.push('/dynamicRoute', extra: () => CancellationConfirmedScreen(),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class SubmitRequestButton extends StatelessWidget {
  final VoidCallback onPressed;

  const SubmitRequestButton({Key? key, required this.onPressed})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 12.0,
      ), // Outer padding
      child: Container(
        color: Colors.white,
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF007BFF), // Bright blue
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          child: const Text('Submit Request', style: TextStyle(fontSize: 16)),
        ),
      ),
    );
  }
}

class CommentInputField extends StatelessWidget {
  final TextEditingController controller;

  CommentInputField({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 15),
      decoration: BoxDecoration(color: Colors.white),
      child: TextFormField(
        controller: controller,
        maxLines: null, // Allows multiline input
        decoration: InputDecoration(
          labelText: 'Comments*',
          labelStyle: TextStyle(color: Colors.grey),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.blue, width: 2.0),
          ),
          isDense: true, // Reduces vertical padding
          contentPadding: EdgeInsets.symmetric(vertical: 8),
        ),
        cursorColor: Colors.blue,
      ),
    );
  }
}
