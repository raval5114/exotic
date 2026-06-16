import 'package:exotic/data/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PaymentTile extends StatefulWidget {
  final String productName;
  final String category;
  final String sellerName;
  final int itemsForOff;
  final double priceForOff;
  final int discount;
  final double discountedPrice;
  final double intialPrice;
  final String image;
  final int qty;
  final DateTime deliveryBy;
  final bool isFreeDelivery;

  const PaymentTile({
    super.key,
    required this.productName,
    required this.category,
    required this.sellerName,
    this.itemsForOff = 0,
    this.priceForOff = 0,
    required this.discount,
    required this.discountedPrice,
    required this.intialPrice,
    required this.image,
    required this.qty,
    required this.deliveryBy,
    required this.isFreeDelivery,
  });

  @override
  State<PaymentTile> createState() => _PaymentTileState();
}

class _PaymentTileState extends State<PaymentTile> {
  late int _selectedQty;

  @override
  void initState() {
    super.initState();
    _selectedQty = widget.qty;
  }

  Widget _extraOffSection(AppTheme t, ThemeData theme) {
    final safeItemsForOff = widget.itemsForOff == 0 ? 1 : widget.itemsForOff;
    final remaining = (widget.itemsForOff - _selectedQty).clamp(
      0,
      widget.itemsForOff,
    );
    final progress = (_selectedQty / safeItemsForOff).clamp(0.0, 1.0);
    final unlocked = remaining == 0;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: t.spaceLG,
        vertical: t.spaceSM,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: unlocked
              ? [
                  const Color(0xFF16A34A).withOpacity(0.08),
                  const Color(0xFF16A34A).withOpacity(0.04),
                ]
              : [
                  t.brandPrimary.withOpacity(0.06),
                  t.brandPrimary.withOpacity(0.02),
                ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                unlocked ? Icons.celebration_rounded : Icons.local_offer_rounded,
                size: 14,
                color: unlocked ? const Color(0xFF16A34A) : t.brandPrimary,
              ),
              SizedBox(width: t.spaceXS),
              Expanded(
                child: Text.rich(
                  TextSpan(
                    style: theme.textTheme.bodySmall,
                    children: [
                      TextSpan(
                        text: unlocked
                            ? 'Offer unlocked! You\'ve earned '
                            : 'Add $remaining more item${remaining > 1 ? 's' : ''} to get ',
                      ),
                      TextSpan(
                        text: 'Extra ₹${widget.priceForOff.toInt()} off',
                        style: TextStyle(
                          color: unlocked
                              ? const Color(0xFF16A34A)
                              : t.brandPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (!unlocked)
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    'Add',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: t.brandPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: t.spaceXS),
          ClipRRect(
            borderRadius: BorderRadius.circular(t.radiusSM),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 5,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(
                unlocked ? const Color(0xFF16A34A) : t.brandPrimary,
              ),
            ),
          ),
          SizedBox(height: 2),
          Text(
            '$_selectedQty of ${widget.itemsForOff} items added',
            style: theme.textTheme.labelSmall?.copyWith(color: Colors.black38),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<AppTheme>()!;
    final theme = Theme.of(context);
    final formattedDate = DateFormat('EEE, MMM d').format(widget.deliveryBy);

    return Container(
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.itemsForOff > 0) _extraOffSection(t, theme),

          Padding(
            padding: EdgeInsets.all(t.spaceLG),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Product image + qty picker ───────────────────────────
                Column(
                  children: [
                    Container(
                      width: 84,
                      height: 96,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(t.radiusMD),
                        color: const Color(0xFFF5F5F5),
                        border: Border.all(
                          color: Colors.grey.withOpacity(0.12),
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(t.radiusMD),
                        child: widget.image.isNotEmpty
                            ? Image.network(
                                widget.image,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) =>
                                    const _ImagePlaceholder(),
                              )
                            : const _ImagePlaceholder(),
                      ),
                    ),
                    SizedBox(height: t.spaceXS),

                    // Qty selector
                    Container(
                      height: 30,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey.withOpacity(0.2),
                        ),
                        borderRadius: BorderRadius.circular(t.radiusSM),
                      ),
                      child: DropdownButton<int>(
                        value: _selectedQty,
                        dropdownColor: Colors.white,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: Colors.black87,
                        ),
                        iconSize: 16,
                        underline: const SizedBox(),
                        isDense: true,
                        padding: EdgeInsets.symmetric(horizontal: t.spaceXS),
                        borderRadius: BorderRadius.circular(t.radiusMD),
                        items: List.generate(10, (i) => i + 1)
                            .map(
                              (e) => DropdownMenuItem(
                                value: e,
                                child: Text('Qty: $e'),
                              ),
                            )
                            .toList(),
                        onChanged: (v) {
                          if (v != null) setState(() => _selectedQty = v);
                        },
                      ),
                    ),
                  ],
                ),

                SizedBox(width: t.spaceMD),

                // ── Product details ──────────────────────────────────────
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.productName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                          height: 1.3,
                        ),
                      ),
                      SizedBox(height: t.spaceXS),
                      Text(
                        widget.category,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.black38,
                        ),
                      ),
                      Text(
                        'Seller: ${widget.sellerName}',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: Colors.black38,
                        ),
                      ),

                      SizedBox(height: t.spaceSM),

                      // ── Price row ────────────────────────────────────────
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: t.spaceXS,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: t.spaceXS + 2,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF16A34A).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '${widget.discount}% off',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: const Color(0xFF16A34A),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          Text(
                            '₹${widget.discountedPrice.toInt()}',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            '₹${widget.intialPrice.toInt()}',
                            style: theme.textTheme.labelSmall?.copyWith(
                              decoration: TextDecoration.lineThrough,
                              color: Colors.black38,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: t.spaceXS),

                      // ── Delivery info ────────────────────────────────────
                      Row(
                        children: [
                          Icon(
                            widget.isFreeDelivery
                                ? Icons.local_shipping_rounded
                                : Icons.local_shipping_outlined,
                            size: 13,
                            color: widget.isFreeDelivery
                                ? const Color(0xFF16A34A)
                                : Colors.black54,
                          ),
                          SizedBox(width: t.spaceXS),
                          Text(
                            widget.isFreeDelivery
                                ? 'Free delivery by $formattedDate'
                                : 'Delivery ₹40 · $formattedDate',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: widget.isFreeDelivery
                                  ? const Color(0xFF16A34A)
                                  : Colors.black54,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── Action row ─────────────────────────────────────────────────────
          Divider(height: 1, color: Colors.grey.withOpacity(0.1)),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: t.spaceSM,
              vertical: t.spaceXS,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _ActionBtn(
                  icon: Icons.edit_outlined,
                  label: 'Edit',
                  onTap: () {},
                ),
                Container(
                  width: 1,
                  height: 20,
                  color: Colors.grey.withOpacity(0.2),
                ),
                _ActionBtn(
                  icon: Icons.favorite_border_rounded,
                  label: 'Save for later',
                  onTap: () {},
                ),
                Container(
                  width: 1,
                  height: 20,
                  color: Colors.grey.withOpacity(0.2),
                ),
                _ActionBtn(
                  icon: Icons.delete_outline_rounded,
                  label: 'Remove',
                  onTap: () {},
                  isDestructive: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDestructive;

  const _ActionBtn({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<AppTheme>()!;
    final color = isDestructive ? t.brandPink : Colors.black54;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(t.radiusSM),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: t.spaceSM,
          vertical: t.spaceSM,
        ),
        child: Row(
          children: [
            Icon(icon, size: 15, color: color),
            SizedBox(width: t.spaceXS),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF0EAF8),
      child: Icon(
        Icons.image_outlined,
        color: Colors.purple.withOpacity(0.3),
        size: 32,
      ),
    );
  }
}
