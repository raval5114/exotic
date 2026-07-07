import 'package:exotic/data/models/order_list_model.dart';
import 'package:exotic/view/orderDetails/orderDetails.dart';
import 'package:exotic/utils/cachedImage.dart';
import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────────────────
// RatingStars — interactive star rating widget
// ─────────────────────────────────────────────────────────────────────────────
class RatingStars extends StatefulWidget {
  final int maxStars;
  final double initialRating;
  final void Function(double)? onRatingChanged;

  const RatingStars({
    super.key,
    this.maxStars = 5,
    this.initialRating = 0,
    this.onRatingChanged,
  });

  @override
  State<RatingStars> createState() => _RatingStarsState();
}

class _RatingStarsState extends State<RatingStars> {
  double _currentRating = 0;

  @override
  void initState() {
    super.initState();
    _currentRating = widget.initialRating;
  }

  void _handleTap(int index) {
    setState(() {
      _currentRating = index.toDouble();
    });
    widget.onRatingChanged?.call(_currentRating);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(widget.maxStars, (index) {
        final isFilled = index < _currentRating;
        return GestureDetector(
          onTap: () => _handleTap(index + 1),
          child: Padding(
            padding: const EdgeInsets.only(right: 3.0),
            child: Icon(
              isFilled ? Icons.star_rounded : Icons.star_outline_rounded,
              color: isFilled ? const Color(0xFFFFC107) : const Color(0xFFD1D5DB),
              size: 18,
            ),
          ),
        );
      }),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _StatusBadge — pill-shaped badge with contextual colours per order status
// ─────────────────────────────────────────────────────────────────────────────
class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  static _StatusColors _resolve(String raw) {
    final s = raw.trim().toLowerCase();
    if (s.contains('cancel') || s.contains('fail') || s.contains('return')) {
      return const _StatusColors(
        bg: Color(0xFFFFEBEE),
        fg: Color(0xFFB71C1C),
        dot: Color(0xFFEF5350),
      );
    }
    if (s.contains('deliver') || s.contains('complet') || s.contains('success')) {
      return const _StatusColors(
        bg: Color(0xFFE8F5E9),
        fg: Color(0xFF1B5E20),
        dot: Color(0xFF43A047),
      );
    }
    if (s.contains('transit') || s.contains('ship') || s.contains('dispatch')) {
      return const _StatusColors(
        bg: Color(0xFFE8EAF6),
        fg: Color(0xFF1A237E),
        dot: Color(0xFF3949AB),
      );
    }
    if (s.contains('process') || s.contains('pend') || s.contains('pack') || s.contains('place')) {
      return const _StatusColors(
        bg: Color(0xFFFFF3E0),
        fg: Color(0xFFBF360C),
        dot: Color(0xFFFF7043),
      );
    }
    return const _StatusColors(
      bg: Color(0xFFF3F4F6),
      fg: Color(0xFF374151),
      dot: Color(0xFF9CA3AF),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = _resolve(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: colors.bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: colors.dot, shape: BoxShape.circle),
          ),
          const SizedBox(width: 5),
          Text(
            status,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 9.5,
              fontWeight: FontWeight.w700,
              color: colors.fg,
              letterSpacing: 0.6,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusColors {
  final Color bg;
  final Color fg;
  final Color dot;
  const _StatusColors({required this.bg, required this.fg, required this.dot});
}

// ─────────────────────────────────────────────────────────────────────────────
// _AccentStripe — left-edge accent bar that mirrors the status colour
// ─────────────────────────────────────────────────────────────────────────────
Color _statusAccentColor(String? status) {
  final s = (status ?? '').trim().toLowerCase();
  if (s.contains('cancel') || s.contains('fail') || s.contains('return')) return const Color(0xFFEF5350);
  if (s.contains('deliver') || s.contains('complet') || s.contains('success')) return const Color(0xFF43A047);
  if (s.contains('transit') || s.contains('ship') || s.contains('dispatch')) return const Color(0xFF3949AB);
  if (s.contains('process') || s.contains('pend') || s.contains('pack') || s.contains('place')) return const Color(0xFFFF7043);
  return const Color(0xFF7C3AED); // brandPrimary fallback
}

// ─────────────────────────────────────────────────────────────────────────────
// OrderShowingTile — premium order list card
// ─────────────────────────────────────────────────────────────────────────────
class OrderShowingTile extends StatelessWidget {
  final OrderListModel product;
  const OrderShowingTile({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final accentColor = _statusAccentColor(product.orderStatus);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.055),
            blurRadius: 14,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Left accent stripe ──────────────────────────────────────
              Container(width: 4, color: accentColor),

              // ── Card body ───────────────────────────────────────────────
              Expanded(
                child: Material(
                  color: Colors.white,
                  child: InkWell(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => OrderdetailsPage(product: product),
                      ),
                    ),
                    splashColor: const Color(0xFF7C3AED).withValues(alpha: 0.06),
                    highlightColor: const Color(0xFF7C3AED).withValues(alpha: 0.03),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ── Top row: status badge · order ID · date ──────
                          Row(
                            children: [
                              _StatusBadge(status: product.orderStatus ?? 'Pending'),
                              const SizedBox(width: 8),
                              if (product.orderId != null && product.orderId!.isNotEmpty)
                                Expanded(
                                  child: Text(
                                    '#${product.orderId}',
                                    style: const TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 11,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xFFB0B7C3),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )
                              else
                                const Spacer(),
                              const SizedBox(width: 8),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.calendar_today_outlined,
                                    size: 11,
                                    color: Color(0xFFB0B7C3),
                                  ),
                                  const SizedBox(width: 4),
                                   Text(
                                    product.date ?? '',
                                    style: const TextStyle(
                                      fontFamily: 'NunitoSans',
                                      fontSize: 11,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xFFB0B7C3),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          // ── Middle row: image · product info ─────────────
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Product image
                              Container(
                                width: 72,
                                height: 72,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      accentColor.withValues(alpha: 0.08),
                                      accentColor.withValues(alpha: 0.03),
                                    ],
                                  ),
                                  border: Border.all(
                                    color: accentColor.withValues(alpha: 0.15),
                                    width: 1,
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(9),
                                  child: product.productImage != null &&
                                          product.productImage!.isNotEmpty
                                      ? AppCachedImage(
                                          imageUrl: product.productImage!,
                                          fit: BoxFit.cover,
                                        )
                                      : Icon(
                                          Icons.inventory_2_outlined,
                                          color: accentColor.withValues(alpha: 0.5),
                                          size: 30,
                                        ),
                                ),
                              ),

                              const SizedBox(width: 14),

                              // Product info column
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Product name
                                    Text(
                                      product.productName ?? '',
                                      style: const TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF1F2937),
                                        height: 1.4,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),

                                    const SizedBox(height: 8),

                                    // Price · qty row
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          '\$${product.price?.toStringAsFixed(2) ?? '0.00'}',
                                          style: const TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                            color: Color(0xFF7C3AED), // brandPrimary
                                          ),
                                        ),
                                        if (product.quantity != null) ...[
                                          const SizedBox(width: 10),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 7, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFF3F4F6),
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                            child: Text(
                                              'Qty ${product.quantity}',
                                              style: const TextStyle(
                                                fontFamily: 'NunitoSans',
                                                fontSize: 10,
                                                fontWeight: FontWeight.w600,
                                                color: Color(0xFF6B7280),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          // ── Divider ──────────────────────────────────────
                          Divider(
                            height: 1,
                            thickness: 1,
                            color: const Color(0xFFF3F4F6),
                          ),

                          const SizedBox(height: 10),

                          // ── Bottom row: rating · view details ────────────
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Rating
                              Row(
                                children: [
                                   const Text(
                                     'Rate: ',
                                     style: TextStyle(
                                       fontFamily: 'NunitoSans',
                                       fontSize: 11,
                                       fontWeight: FontWeight.w500,
                                       color: Color(0xFF9CA3AF),
                                     ),
                                   ),
                                  const RatingStars(),
                                ],
                              ),

                              // View details link
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                   Text(
                                     'View Details',
                                     style: TextStyle(
                                       fontFamily: 'Poppins',
                                       fontSize: 11,
                                       fontWeight: FontWeight.w600,
                                       color: accentColor,
                                     ),
                                   ),
                                  const SizedBox(width: 2),
                                  Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    size: 10,
                                    color: accentColor,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
