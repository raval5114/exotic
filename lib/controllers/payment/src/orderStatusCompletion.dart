import 'package:exotic/data/theme/app_theme.dart';
import 'package:flutter/material.dart';

class OrderStatusCompletion extends StatelessWidget {
  final int completionStatus; // 1 to 3

  const OrderStatusCompletion({super.key, required this.completionStatus});

  final List<String> _steps = const ['Address', 'Order Summary', 'Payment'];

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<AppTheme>()!;
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: t.spaceLG, vertical: t.spaceSM),
      child: Row(
        children: List.generate(_steps.length * 2 - 1, (i) {
          if (i.isEven) {
            final index = i ~/ 2;
            final isCompleted = index < completionStatus - 1;
            final isCurrent = index == completionStatus - 1;

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ── Step circle ─────────────────────────────────────────
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isCompleted
                        ? t.brandPrimary
                        : isCurrent
                            ? t.brandPrimary
                            : Colors.white,
                    border: Border.all(
                      color: isCompleted || isCurrent
                          ? t.brandPrimary
                          : Colors.grey.shade300,
                      width: 2,
                    ),
                    boxShadow: isCurrent
                        ? [
                            BoxShadow(
                              color: t.brandPrimary.withOpacity(0.25),
                              blurRadius: 8,
                              spreadRadius: 1,
                            ),
                          ]
                        : null,
                  ),
                  child: Center(
                    child: isCompleted
                        ? const Icon(
                            Icons.check_rounded,
                            size: 16,
                            color: Colors.white,
                          )
                        : Text(
                            '${index + 1}',
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: isCurrent ? Colors.white : Colors.grey,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                  ),
                ),
                SizedBox(height: t.spaceXS),
                // ── Label ───────────────────────────────────────────────
                Text(
                  _steps[index],
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: isCompleted || isCurrent
                        ? t.brandPrimary
                        : Colors.grey,
                    fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w400,
                  ),
                ),
              ],
            );
          } else {
            // ── Connector line ─────────────────────────────────────────
            final isActive = i ~/ 2 < completionStatus - 1;
            return Expanded(
              child: Container(
                height: 2,
                margin: const EdgeInsets.only(bottom: 18),
                decoration: BoxDecoration(
                  gradient: isActive
                      ? LinearGradient(
                          colors: [t.brandPrimary, t.brandSecondary],
                        )
                      : null,
                  color: isActive ? null : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
            );
          }
        }),
      ),
    );
  }
}
