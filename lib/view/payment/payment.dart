import 'package:exotic/data/providers/product_provider.dart';
import 'package:exotic/data/theme/app_theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:exotic/controllers/payment/paymentController.dart';
import 'package:exotic/view/payment/orderPaymentScreen.dart';
import 'package:flutter/material.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<AppTheme>()!;
    final theme = Theme.of(context);
    final product = context.read<ProductProvider>().product!;
    final mrpPrice = product.pMrpPrice ?? '0';
    final sellingPrice = product.pSellingPrice ?? '0';

    // Parse discount percentage
    final mrp = double.tryParse(mrpPrice) ?? 0;
    final sell = double.tryParse(sellingPrice) ?? 0;
    final discountPct = mrp > 0 ? (((mrp - sell) / mrp) * 100).round() : 0;

    return Scaffold(
      backgroundColor: const Color(0xFFF1F3F6),
      appBar: AppBar(
        backgroundColor: t.brandPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        toolbarHeight: 60,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: 20,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Step 2 of 3',
              style: theme.textTheme.labelSmall?.copyWith(
                color: Colors.white60,
                letterSpacing: 0.4,
              ),
            ),
            Text(
              'Order Summary',
              style: theme.textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: t.spaceMD),
            child: Row(
              children: [
                Icon(
                  Icons.lock_outline_rounded,
                  color: Colors.white60,
                  size: 14,
                ),
                SizedBox(width: t.spaceXS),
                Text(
                  '100% Secure',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: Colors.white60,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: PaymentController(productData: product),
      bottomSheet: _BottomBar(
        mrpPrice: mrpPrice,
        sellingPrice: sellingPrice,
        discountPct: discountPct,
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  final String mrpPrice;
  final String sellingPrice;
  final int discountPct;

  const _BottomBar({
    required this.mrpPrice,
    required this.sellingPrice,
    required this.discountPct,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<AppTheme>()!;
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: t.spaceLG, vertical: t.spaceMD),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey.withOpacity(0.12), width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 24,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // ── Price column ────────────────────────────────────────────────
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '₹$sellingPrice',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: Colors.black87,
                          height: 1,
                        ),
                      ),
                      SizedBox(width: t.spaceSM),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: t.spaceSM,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF16A34A).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(t.radiusSM),
                        ),
                        child: Text(
                          '$discountPct% off',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: const Color(0xFF16A34A),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2),
                  Text(
                    'MRP ₹$mrpPrice',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.black38,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(width: t.spaceMD),

            // ── Place Order CTA ─────────────────────────────────────────────
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: t.brandPrimary,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: EdgeInsets.symmetric(
                  horizontal: t.spaceXL,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(t.radiusMD),
                ),
              ),
              onPressed: () {
                context.push(
                  '/dynamicRoute',
                  extra: () => OrderPaymentScreen(),
                );
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Place Order',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.3,
                    ),
                  ),
                  SizedBox(width: t.spaceXS),
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 14,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
