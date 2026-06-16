import 'package:exotic/data/theme/app_theme.dart';
import 'package:flutter/material.dart';

class DeliveryAddressConfirmationWidget extends StatelessWidget {
  final String name;
  final String address;
  final String phoneNumber;
  final VoidCallback onChange;

  const DeliveryAddressConfirmationWidget({
    super.key,
    required this.name,
    required this.address,
    required this.phoneNumber,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<AppTheme>()!;
    final theme = Theme.of(context);

    return Container(
      color: Colors.white,
      width: double.infinity,
      padding: EdgeInsets.all(t.spaceLG),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header row ────────────────────────────────────────────────────
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(t.spaceSM),
                decoration: BoxDecoration(
                  color: t.brandPrimary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(t.radiusSM),
                ),
                child: Icon(
                  Icons.location_on_rounded,
                  color: t.brandPrimary,
                  size: 18,
                ),
              ),
              SizedBox(width: t.spaceSM),
              Text(
                'Deliver to',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
              const Spacer(),
              OutlinedButton(
                onPressed: onChange,
                style: OutlinedButton.styleFrom(
                  foregroundColor: t.brandSecondary,
                  side: BorderSide(color: t.brandSecondary, width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(t.radiusSM),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: t.spaceMD,
                    vertical: t.spaceXS,
                  ),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'Change',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: t.brandSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: t.spaceMD),
          const Divider(height: 1, color: Color(0xFFF0F0F0)),
          SizedBox(height: t.spaceMD),

          // ── Name ──────────────────────────────────────────────────────────
          Text(
            name,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),

          SizedBox(height: t.spaceXS),

          // ── Address ───────────────────────────────────────────────────────
          Text(
            address,
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.black54,
              height: 1.5,
            ),
          ),

          SizedBox(height: t.spaceXS),

          // ── Phone ─────────────────────────────────────────────────────────
          Row(
            children: [
              Icon(Icons.phone_outlined, size: 14, color: Colors.black38),
              SizedBox(width: t.spaceXS),
              Text(
                phoneNumber,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
