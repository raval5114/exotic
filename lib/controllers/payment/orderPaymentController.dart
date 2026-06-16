import 'package:exotic/controllers/payment/orderPaymentOptions.dart';
import 'package:exotic/controllers/payment/src/orderPaymentAmountShowing.dart';
import 'package:exotic/controllers/src/ad_blocks/widgets/ad_block.dart';
import 'package:exotic/data/theme/app_theme.dart';
import 'package:flutter/material.dart';

class OrderPaymentComponent extends StatefulWidget {
  const OrderPaymentComponent({super.key});

  @override
  State<OrderPaymentComponent> createState() => _OrderPaymentComponentState();
}

class _OrderPaymentComponentState extends State<OrderPaymentComponent> {
  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<AppTheme>()!;
    final theme = Theme.of(context);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AdBlock(page: 'checkout', position: 'top', limit: 2),

          SizedBox(height: t.spaceSM),

          // ── Total amount + cashback ──────────────────────────────────────
          OrderPaymentAmountShowing(totalAmount: 500, cashbackAmount: 25),

          SizedBox(height: t.spaceSM),

          const AdBlock(page: 'checkout', position: 'middle', limit: 2),

          // ── Payment method tiles ─────────────────────────────────────────
          Container(
            color: const Color(0xFFF1F3F6),
            padding: EdgeInsets.symmetric(vertical: t.spaceSM),
            child: const OrderPaymentOptions(),
          ),

          const AdBlock(page: 'checkout', position: 'bottom', limit: 2),

          SizedBox(height: t.spaceMD),

          // ── Social proof footer ──────────────────────────────────────────
          Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: t.spaceXS),
            padding: EdgeInsets.symmetric(
              vertical: t.spaceXXL,
              horizontal: t.spaceLG,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  t.brandPrimary.withOpacity(0.05),
                  t.brandSecondary.withOpacity(0.03),
                ],
              ),
              borderRadius: BorderRadius.circular(t.radiusMD),
              border: Border.all(color: t.brandPrimary.withOpacity(0.08)),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.verified_user_rounded,
                  size: 36,
                  color: t.brandPrimary.withOpacity(0.5),
                ),
                SizedBox(height: t.spaceSM),
                Text(
                  'Trusted by millions of happy customers',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.black45,
                    height: 1.5,
                  ),
                ),
                SizedBox(height: t.spaceMD),
                Wrap(
                  spacing: t.spaceLG,
                  children: [
                    _SecurityBadge(
                      icon: Icons.lock_rounded,
                      label: '100% Secure',
                      color: const Color(0xFF16A34A),
                    ),
                    _SecurityBadge(
                      icon: Icons.verified_rounded,
                      label: 'Verified',
                      color: t.brandPrimary,
                    ),
                    _SecurityBadge(
                      icon: Icons.replay_rounded,
                      label: 'Easy Returns',
                      color: Colors.amber.shade700,
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 80),
        ],
      ),
    );
  }
}

class _SecurityBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _SecurityBadge({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }
}
