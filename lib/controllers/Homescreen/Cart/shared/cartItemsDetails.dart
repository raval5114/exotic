import 'package:exotic/data/models/cart.dart';
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
    final int coupon = 0;
    final int platformFee = cart.platformFee;
    final bool isFreeDelivery = true;
    final int totalAmount = cart.grandTotal.toInt();
    final int deliveryCharge = 40;

    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Price Details',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          const Divider(thickness: 1, color: Colors.grey),
          const SizedBox(height: 8),
          _priceRow('Price(1)', '₹${price.toString()}'),
          _priceRow(
            'Discount',
            '-₹${discount.toString()}',
            valueColor: Colors.green,
          ),
          _priceRow('Coupons', '0'),
          _priceRow('Platform fee', '${platformFee}'),
          _priceRow(
            'Delivery charges',
            isFreeDelivery == true ? '' : '₹$deliveryCharge',
            trailingWidget: const Text(
              'Free Delivery',
              style: TextStyle(color: Colors.green, fontSize: 13),
            ),
          ),
          const SizedBox(height: 8),
          const Divider(thickness: 1, color: Colors.grey),
          const SizedBox(height: 8),
          _priceRow('Total Amount', '₹${totalAmount.toString()}', isBold: true),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.green.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.verified, color: Colors.green, size: 20),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    '₹$discount saved on this order!',
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
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
    Widget? trailingWidget,
  }) {
    final textStyle = TextStyle(
      fontSize: 14,
      color: isBold ? Colors.black : Colors.grey.shade700,
      fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: Text(label, style: textStyle)),
          if (trailingWidget != null)
            Row(
              children: [
                Text(value, style: textStyle.copyWith(color: valueColor)),
                const SizedBox(width: 6),
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
