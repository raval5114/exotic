import 'package:exotic/controllers/payment/orderPaymentController.dart';
import 'package:exotic/data/theme/app_theme.dart';
import 'package:flutter/material.dart';

class OrderPaymentScreen extends StatelessWidget {
  const OrderPaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<AppTheme>()!;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF1F3F6),
      appBar: AppBar(
        backgroundColor: t.brandPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        toolbarHeight: 60,
        automaticallyImplyLeading: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Step 3 of 3',
              style: theme.textTheme.labelSmall?.copyWith(
                color: Colors.white60,
                letterSpacing: 0.4,
              ),
            ),
            Text(
              'Payment',
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
                const Icon(
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
      body: const OrderPaymentComponent(),
    );
  }
}
