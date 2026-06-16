import 'package:go_router/go_router.dart';
import 'package:exotic/controllers/payment/src/orderPaymentOptionsTile.dart';
import 'package:exotic/data/theme/app_theme.dart';
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
    final t = Theme.of(context).extension<AppTheme>()!;
    final theme = Theme.of(context);

    void onSubmittingCOD() {
      final random = Random();
      final orderId = 100000 + random.nextInt(900000);
      final user = context.read<UserProvider>().user;
      final userId =
          user != null && user.customerId != 0 ? user.customerId : null;
      context.read<AdProvider>().attributeOrder(
            orderId: orderId,
            totalValue: 500.0,
            userId: userId,
          );
      context.go('/dynamicRoute', extra: () => const OrderPaymentSuccessfullScreen());
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Section header ──────────────────────────────────────────────────
        Padding(
          padding: EdgeInsets.fromLTRB(
            t.spaceLG,
            t.spaceLG,
            t.spaceLG,
            t.spaceSM,
          ),
          child: Row(
            children: [
              Icon(Icons.payment_rounded, size: 18, color: t.brandPrimary),
              SizedBox(width: t.spaceSM),
              Text(
                'Choose Payment Method',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),

        // ── Payment option tiles ─────────────────────────────────────────────
        OrderPaymentOptionsTileExpandable(
          title: 'UPI',
          subtitle: 'Google Pay, PhonePe, Paytm & more',
          leading: const Icon(Icons.account_balance_wallet_outlined),
          expandedChild: Padding(
            padding: EdgeInsets.symmetric(vertical: t.spaceXS),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Enter UPI ID',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: Colors.black54,
                  ),
                ),
                SizedBox(height: t.spaceXS),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'yourname@upi',
                    hintStyle: theme.textTheme.bodySmall
                        ?.copyWith(color: Colors.black38),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(t.radiusSM),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(t.radiusSM),
                      borderSide: BorderSide(color: t.brandPrimary, width: 1.5),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: t.spaceMD,
                      vertical: t.spaceSM,
                    ),
                    isDense: true,
                    suffixIcon: Icon(
                      Icons.qr_code_scanner_rounded,
                      color: t.brandPrimary,
                      size: 20,
                    ),
                  ),
                ),
                SizedBox(height: t.spaceMD),
                _PayButton(t: t, theme: theme, onTap: onSubmittingCOD),
              ],
            ),
          ),
        ),

        OrderPaymentOptionsTileExpandable(
          title: 'Credit / Debit / ATM Card',
          subtitle: '5% unlimited cashback on Exotic Axis Bank card',
          leading: const Icon(Icons.credit_card_outlined),
          expandedChild: Padding(
            padding: EdgeInsets.symmetric(vertical: t.spaceXS),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _CardField(
                  t: t,
                  theme: theme,
                  hint: 'Card Number',
                  icon: Icons.credit_card_rounded,
                ),
                SizedBox(height: t.spaceSM),
                Row(
                  children: [
                    Expanded(
                      child: _CardField(
                        t: t,
                        theme: theme,
                        hint: 'MM / YY',
                        icon: Icons.calendar_today_outlined,
                      ),
                    ),
                    SizedBox(width: t.spaceSM),
                    Expanded(
                      child: _CardField(
                        t: t,
                        theme: theme,
                        hint: 'CVV',
                        icon: Icons.lock_outline_rounded,
                        obscure: true,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: t.spaceMD),
                _PayButton(t: t, theme: theme, onTap: onSubmittingCOD),
              ],
            ),
          ),
        ),

        OrderPaymentOptionsTileExpandable(
          title: 'Net Banking',
          subtitle: 'All major banks supported',
          leading: const Icon(Icons.account_balance_outlined),
          expandedChild: _CardField(
            t: t,
            theme: theme,
            hint: 'Select your bank',
            icon: Icons.search_rounded,
          ),
        ),

        OrderPaymentOptionsTileExpandable(
          title: 'Cash On Delivery',
          subtitle: 'Pay when your order arrives',
          leading: const Icon(Icons.money_outlined),
          expandedChild: Padding(
            padding: EdgeInsets.symmetric(vertical: t.spaceXS),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(t.spaceMD),
                  decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(t.radiusSM),
                    border: Border.all(
                      color: Colors.amber.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.info_outline_rounded,
                        size: 16,
                        color: Colors.amber,
                      ),
                      SizedBox(width: t.spaceXS),
                      Expanded(
                        child: Text(
                          'A nominal fee of ₹7 is charged for handling costs.',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: Colors.amber.shade800,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: t.spaceMD),
                _PayButton(
                  t: t,
                  theme: theme,
                  onTap: onSubmittingCOD,
                  label: 'Confirm Order',
                ),
              ],
            ),
          ),
        ),

        OrderPaymentOptionsTileExpandable(
          title: 'Gift Card',
          subtitle: 'Redeem your Exotic gift card',
          leading: const Icon(Icons.card_giftcard_outlined),
          expandedChild: _CardField(
            t: t,
            theme: theme,
            hint: 'Enter gift card code',
            icon: Icons.confirmation_number_outlined,
          ),
        ),

        OrderPaymentOptionsTileExpandable(
          title: 'EMI',
          subtitle: 'Available on select cards',
          leading: const Icon(Icons.access_time_rounded),
          enabled: false,
        ),

        OrderPaymentOptionsTileExpandable(
          title: 'Wallet',
          subtitle: 'Coming soon',
          leading: const Icon(Icons.wallet_outlined),
          enabled: false,
        ),

        SizedBox(height: t.spaceSM),
      ],
    );
  }
}

// ─── Shared Pay Button ────────────────────────────────────────────────────────
class _PayButton extends StatelessWidget {
  final AppTheme t;
  final ThemeData theme;
  final VoidCallback onTap;
  final String label;

  const _PayButton({
    required this.t,
    required this.theme,
    required this.onTap,
    this.label = 'Pay Now',
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: t.brandPrimary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(t.radiusMD),
          ),
        ),
        onPressed: onTap,
        child: Text(
          label,
          style: theme.textTheme.labelLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
          ),
        ),
      ),
    );
  }
}

// ─── Reusable text field ──────────────────────────────────────────────────────
class _CardField extends StatelessWidget {
  final AppTheme t;
  final ThemeData theme;
  final String hint;
  final IconData icon;
  final bool obscure;

  const _CardField({
    required this.t,
    required this.theme,
    required this.hint,
    required this.icon,
    this.obscure = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscure,
      style: theme.textTheme.bodySmall?.copyWith(color: Colors.black87),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: theme.textTheme.bodySmall?.copyWith(color: Colors.black38),
        prefixIcon: Icon(icon, size: 18, color: Colors.black38),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(t.radiusSM),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(t.radiusSM),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(t.radiusSM),
          borderSide: BorderSide(color: t.brandPrimary, width: 1.5),
        ),
        filled: true,
        fillColor: const Color(0xFFFAFAFA),
        contentPadding: EdgeInsets.symmetric(
          horizontal: t.spaceMD,
          vertical: t.spaceSM,
        ),
        isDense: true,
      ),
    );
  }
}
