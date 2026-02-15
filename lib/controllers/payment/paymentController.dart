import 'package:exotic/controllers/Homescreen/Cart/shared/cartItemsDetails.dart';
import 'package:exotic/controllers/Homescreen/Cart/shared/src/cartTile.dart';
import 'package:exotic/controllers/payment/src/deliveryConformation.dart';
import 'package:exotic/controllers/payment/src/orderStatusCompletion.dart';
import 'package:exotic/controllers/payment/src/paymentTile.dart';
import 'package:exotic/utils/newProductList.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class PaymentController extends StatefulWidget {
  final Map<String, dynamic> productData;
  const PaymentController({super.key, required this.productData});

  @override
  State<PaymentController> createState() => _PaymentControllerState();
}

class _PaymentControllerState extends State<PaymentController> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            color: Colors.white,
            child: OrderStatusCompletion(completionStatus: 3),
          ),
          DeliveryAddressConfirmationWidget(
            name: products[1]['delivery']['name'],
            address: products[1]['delivery']['addressLine'],
            phoneNumber: "1234567890",
            onChange: () {},
          ),
          PaymentTile(
            productName: products[1]['productName'],
            category: "category",
            sellerName: products[1]['sellerName'],
            discount: products[1]['discount'],
            discountedPrice: products[1]['discountedPrice'],
            intialPrice: products[1]['initialPrice'],
            image: products[1]['imgages'][0],
            qty: 2,
            deliveryBy: DateTime.now(),
            isFreeDelivery: true,
          ),
          //CartPriceingComponent(cartItems: []),
          Container(
            color: Colors.grey.shade200,
            padding: const EdgeInsets.all(15),
            child: RichText(
              text: TextSpan(
                style: const TextStyle(color: Colors.grey, fontSize: 14),
                children: [
                  const TextSpan(
                    text:
                        "By continuing with the order, you confirm that you are above 18 years of age, and you agree to the Flipkart's ",
                  ),
                  TextSpan(
                    text: "Terms of Use",
                    style: const TextStyle(color: Colors.blue),
                    recognizer:
                        TapGestureRecognizer()
                          ..onTap = () {
                            // Open Terms of Use link
                          },
                  ),
                  const TextSpan(text: " and "),
                  TextSpan(
                    text: "Privacy Policy",
                    style: const TextStyle(color: Colors.blue),
                    recognizer:
                        TapGestureRecognizer()
                          ..onTap = () {
                            // Open Privacy Policy link
                          },
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 120),
        ],
      ),
    );
  }
}
