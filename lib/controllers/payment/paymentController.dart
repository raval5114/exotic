import 'package:exotic/controllers/Homescreen/Cart/shared/src/cartTile.dart';
import 'package:exotic/controllers/payment/src/deliveryConformation.dart';
import 'package:exotic/controllers/payment/src/orderStatusCompletion.dart';
import 'package:exotic/controllers/payment/src/paymentTile.dart';
import 'package:exotic/data/models/product_orignal.dart';
import 'package:exotic/data/providers/address_provider.dart';
import 'package:exotic/data/providers/user_provider.dart';
import 'package:exotic/data/theme/app_theme.dart';
import 'package:exotic/utils/newProductList.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaymentController extends StatefulWidget {
  final ProductModel productData;
  const PaymentController({super.key, required this.productData});

  @override
  State<PaymentController> createState() => _PaymentControllerState();
}

class _PaymentControllerState extends State<PaymentController> {
  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<AppTheme>()!;
    final theme = Theme.of(context);
    final user = context.read<UserProvider>().user!;
    final address = context.read<AddressProvider>().defaultAddress;

    return SingleChildScrollView(
      child: Column(
        children: [
          // ── Step progress ─────────────────────────────────────────────────
          Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(
              vertical: t.spaceLG,
              horizontal: t.spaceXS,
            ),
            child: OrderStatusCompletion(completionStatus: 2),
          ),

          SizedBox(height: t.spaceSM),

          // ── Delivery address card ─────────────────────────────────────────
          DeliveryAddressConfirmationWidget(
            name: '${user.firstName} ${user.lastName}',
            address: '$address',
            phoneNumber: '${user.phone}',
            onChange: () {},
          ),

          SizedBox(height: t.spaceSM),

          // ── Product tile ──────────────────────────────────────────────────
          PaymentTile(
            productName: products[1]['productName'],
            category: 'Category',
            sellerName: products[1]['sellerName'] ?? 'Seller',
            discount: products[1]['discount'],
            discountedPrice: (products[1]['discountedPrice'] as num).toDouble(),
            intialPrice: (products[1]['initialPrice'] as num).toDouble(),
            image: products[1]['imgages'][0],
            qty: 2,
            deliveryBy: DateTime.now().add(const Duration(days: 3)),
            isFreeDelivery: true,
          ),

          SizedBox(height: t.spaceSM),

          // ── Terms & Conditions ────────────────────────────────────────────
          Container(
            margin: EdgeInsets.symmetric(horizontal: t.spaceXS),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(t.radiusMD),
              border: Border.all(color: Colors.grey.withOpacity(0.1)),
            ),
            padding: EdgeInsets.all(t.spaceLG),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  size: 16,
                  color: Colors.black38,
                ),
                SizedBox(width: t.spaceSM),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.black54,
                        height: 1.5,
                      ),
                      children: [
                        const TextSpan(
                          text:
                              'By continuing, you confirm that you are above 18 years of age and agree to Exotic\'s ',
                        ),
                        TextSpan(
                          text: 'Terms of Use',
                          style: TextStyle(
                            color: t.brandSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                          recognizer: TapGestureRecognizer()..onTap = () {},
                        ),
                        const TextSpan(text: ' and '),
                        TextSpan(
                          text: 'Privacy Policy',
                          style: TextStyle(
                            color: t.brandSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                          recognizer: TapGestureRecognizer()..onTap = () {},
                        ),
                        const TextSpan(text: '.'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Bottom padding so content clears the bottom sheet
          const SizedBox(height: 120),
        ],
      ),
    );
  }
}
