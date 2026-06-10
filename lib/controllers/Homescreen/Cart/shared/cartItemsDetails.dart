import 'package:exotic/data/providers/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartPriceingComponent extends StatefulWidget {
  const CartPriceingComponent({super.key});

  @override
  State<CartPriceingComponent> createState() => _CartPriceingComponentState();
}

class _CartPriceingComponentState extends State<CartPriceingComponent> {
  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    final int price = cart.totalMrp;
    final int discount = cart.totalDiscount.toInt();
    //final int coupon = 0;
    final int platformFee = cart.platformFee;
    final bool isFreeDelivery = true;
    final int totalAmount = cart.grandTotal.toInt();
    final int deliveryCharge = 40;

    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Price Details',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
          ),
          const SizedBox(height: 8),
          const Divider(thickness: 1, height: 1, color: Color(0xFFEEEEEE)),
          const SizedBox(height: 8),
          _priceRow(
            'Price (${cart.cartProducts.length} items)',
            '₹${price.toString()}',
          ),
          _priceRow(
            'Discount',
            '-₹${discount.toString()}',
            valueColor: Colors.green,
          ),
          _priceRow('Coupons', '0'),
          _priceRow('Platform fee', '₹$platformFee'),
          _priceRow(
            'Delivery charges',
            isFreeDelivery == true ? '' : '₹$deliveryCharge',
            trailingWidget:
                isFreeDelivery
                    ? const Text(
                      'Free Delivery',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                    : null,
          ),
          const SizedBox(height: 8),
          const Divider(thickness: 1, height: 1, color: Color(0xFFEEEEEE)),
          const SizedBox(height: 8),
          _priceRow(
            'Total Amount',
            '₹${totalAmount.toString()}',
            isBold: true,
            fontSize: 15,
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.green.shade200),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.stars_rounded,
                  color: Colors.green.shade600,
                  size: 16,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'You will save ₹$discount on this order',
                    style: TextStyle(
                      color: Colors.green.shade700,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _priceRow(
    String label,
    String value, {
    bool isBold = false,
    Color? valueColor,
    double? fontSize,
    Widget? trailingWidget,
  }) {
    final textStyle = TextStyle(
      fontSize: fontSize ?? 13,
      color: isBold ? Colors.black : Colors.grey.shade600,
      fontWeight: isBold ? FontWeight.w700 : FontWeight.w400,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: textStyle),
          if (trailingWidget != null)
            Row(
              children: [
                if (value.isNotEmpty) ...[
                  Text(
                    value,
                    style: textStyle.copyWith(
                      color: valueColor,
                      decoration:
                          trailingWidget != null && isBold == false
                              ? TextDecoration.lineThrough
                              : null,
                    ),
                  ),
                  const SizedBox(width: 4),
                ],
                trailingWidget,
              ],
            )
          else
            Text(value, style: textStyle.copyWith(color: valueColor)),
        ],
      ),
    );
  }
}
