import 'package:exotic/data/theme/app_theme.dart';
import 'package:flutter/material.dart';

class OrderPaymentAmountShowing extends StatelessWidget {
  final int totalAmount;
  final int cashbackAmount;

  const OrderPaymentAmountShowing({
    super.key,
    required this.totalAmount,
    required this.cashbackAmount,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<AppTheme>()!;
    final theme = Theme.of(context);

    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(t.spaceLG),
      width: double.infinity,
      child: Column(
        children: [
          // ── Total Amount ──────────────────────────────────────────────────
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: t.spaceLG,
              vertical: t.spaceMD,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  t.brandPrimary.withOpacity(0.08),
                  t.brandSecondary.withOpacity(0.04),
                ],
              ),
              borderRadius: BorderRadius.circular(t.radiusMD),
              border: Border.all(
                color: t.brandPrimary.withOpacity(0.15),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.receipt_long_rounded,
                      color: t.brandPrimary,
                      size: 18,
                    ),
                    SizedBox(width: t.spaceSM),
                    Text(
                      'Total Amount',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: t.brandPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: t.spaceXS),
                    Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: t.brandPrimary,
                      size: 18,
                    ),
                  ],
                ),
                Text(
                  '₹$totalAmount',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: t.brandPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: t.spaceSM),

          // ── Cashback Banner ───────────────────────────────────────────────
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: t.spaceLG,
              vertical: t.spaceMD,
            ),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFD1FAE5), Color(0xFFECFDF5)],
              ),
              borderRadius: BorderRadius.circular(t.radiusMD),
              border: Border.all(color: const Color(0xFF16A34A).withOpacity(0.2)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.celebration_rounded,
                            size: 16,
                            color: const Color(0xFF16A34A),
                          ),
                          SizedBox(width: t.spaceXS),
                          Text(
                            '5% Cashback',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: const Color(0xFF16A34A),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: t.spaceXS),
                      Text(
                        'Claim now with eligible payment offers',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: const Color(0xFF15803D),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: t.spaceSM),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF16A34A).withOpacity(0.15),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.currency_rupee_rounded,
                    color: Color(0xFF16A34A),
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
