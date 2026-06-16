import 'package:exotic/data/theme/app_theme.dart';
import 'package:flutter/material.dart';

class OrderPaymentOptionsTileExpandable extends StatefulWidget {
  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? expandedChild;
  final bool enabled;

  const OrderPaymentOptionsTileExpandable({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.expandedChild,
    this.enabled = true,
  });

  @override
  State<OrderPaymentOptionsTileExpandable> createState() =>
      _OrderPaymentOptionsTileExpandableState();
}

class _OrderPaymentOptionsTileExpandableState
    extends State<OrderPaymentOptionsTileExpandable>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late final AnimationController _controller;
  late final Animation<double> _rotateAnim;
  late final Animation<double> _expandAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _rotateAnim = Tween<double>(begin: 0, end: 0.5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _expandAnim = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    if (!widget.enabled) return;
    setState(() => _isExpanded = !_isExpanded);
    _isExpanded ? _controller.forward() : _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<AppTheme>()!;
    final theme = Theme.of(context);

    final Color primaryColor = widget.enabled ? Colors.black87 : Colors.black26;
    final Color subColor = widget.enabled ? Colors.black45 : Colors.black26;
    final Color iconColor =
        _isExpanded && widget.enabled ? t.brandPrimary : subColor;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: EdgeInsets.symmetric(
        horizontal: t.spaceXS,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(t.radiusMD),
        border: Border.all(
          color: _isExpanded && widget.enabled
              ? t.brandPrimary.withOpacity(0.3)
              : Colors.grey.withOpacity(0.12),
          width: _isExpanded ? 1.5 : 1,
        ),
        boxShadow: _isExpanded
            ? [
                BoxShadow(
                  color: t.brandPrimary.withOpacity(0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : [],
      ),
      child: Column(
        children: [
          // ── Header ──────────────────────────────────────────────────────
          InkWell(
            onTap: _toggle,
            borderRadius: BorderRadius.circular(t.radiusMD),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: t.spaceLG,
                vertical: t.spaceMD,
              ),
              child: Row(
                children: [
                  // Leading icon with badge bg on expanded
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: EdgeInsets.all(t.spaceSM),
                    decoration: BoxDecoration(
                      color: _isExpanded && widget.enabled
                          ? t.brandPrimary.withOpacity(0.08)
                          : widget.enabled
                              ? Colors.grey.withOpacity(0.06)
                              : Colors.grey.withOpacity(0.04),
                      borderRadius: BorderRadius.circular(t.radiusSM),
                    ),
                    child: widget.leading != null
                        ? IconTheme(
                            data: IconThemeData(
                              color: iconColor,
                              size: 20,
                            ),
                            child: widget.leading!,
                          )
                        : const SizedBox(width: 20, height: 20),
                  ),

                  SizedBox(width: t.spaceMD),

                  // Title + subtitle
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: primaryColor,
                          ),
                        ),
                        if (widget.subtitle != null) ...[
                          SizedBox(height: 2),
                          Text(
                            widget.subtitle!,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: subColor,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  // Animated chevron
                  RotationTransition(
                    turns: _rotateAnim,
                    child: Icon(
                      Icons.expand_more_rounded,
                      color: widget.enabled ? Colors.black38 : Colors.black12,
                      size: 22,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Expanded content ─────────────────────────────────────────────
          SizeTransition(
            sizeFactor: _expandAnim,
            child: widget.expandedChild != null
                ? Column(
                    children: [
                      Divider(
                        height: 1,
                        indent: t.spaceLG,
                        endIndent: t.spaceLG,
                        color: Colors.grey.withOpacity(0.12),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                          t.spaceLG,
                          t.spaceMD,
                          t.spaceLG,
                          t.spaceLG,
                        ),
                        child: widget.expandedChild!,
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
