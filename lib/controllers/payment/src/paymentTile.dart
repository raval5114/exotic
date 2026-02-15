import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PaymentTile extends StatelessWidget {
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
  Widget _actionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        minimumSize: const Size(0, 36),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      onPressed: onPressed,
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.black),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.black),
          ),
        ],
      ),
    );
  }

  Widget _extraOffSection() {
    final safeItemsForOff = itemsForOff == 0 ? 1 : itemsForOff;
    final remaining = (itemsForOff - qty).clamp(0, itemsForOff);
    final progress = (qty / safeItemsForOff).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      color: Colors.grey.shade100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text:
                            remaining > 0
                                ? "Add $remaining more item${remaining > 1 ? 's' : ''} to get "
                                : "Offer unlocked! You've earned ",
                      ),
                      TextSpan(
                        text: "Extra ₹${priceForOff.toInt()} off",
                        style: const TextStyle(color: Colors.green),
                      ),
                    ],
                  ),
                  style: const TextStyle(fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (remaining > 0)
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(padding: EdgeInsets.zero),
                  child: const Text("Add", style: TextStyle(fontSize: 12)),
                ),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: Colors.grey.shade300,
              color: Colors.green,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            "$qty of $itemsForOff items added",
            style: const TextStyle(fontSize: 10, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final formattedDeliveryDate = DateFormat('MMM d, EEE').format(deliveryBy);

    return Card(
      margin: const EdgeInsets.all(4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (itemsForOff > 0) _extraOffSection(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    SizedBox(
                      width: 73,
                      height: 80,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child:
                            Placeholder(), // Replace with Image.network(image)
                      ),
                    ),
                    DropdownButton<int>(
                      value: qty,
                      dropdownColor: Colors.white,
                      style: const TextStyle(fontSize: 12),
                      iconSize: 18,
                      underline: const SizedBox(),
                      items:
                          List.generate(10, (index) => index + 1)
                              .map(
                                (e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(
                                    "Qty: $e",
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                      onChanged: (_) {},
                    ),
                  ],
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        productName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        category,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        "Seller: $sellerName",
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Text(
                            "↓$discount%",
                            style: const TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "₹${discountedPrice.toInt()}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "₹${intialPrice.toInt()}",
                            style: const TextStyle(
                              decoration: TextDecoration.lineThrough,
                              color: Colors.grey,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "Delivery by $formattedDeliveryDate, ${isFreeDelivery ? 'Free' : '₹40'}",
                        style: TextStyle(
                          fontSize: 10,
                          color: isFreeDelivery ? Colors.green : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    DropdownButton<int>(
                      value: qty,
                      hint: const Text("Qty"),
                      dropdownColor: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      style: const TextStyle(fontSize: 12),
                      iconSize: 18,
                      underline: const SizedBox(),
                      items:
                          List.generate(10, (index) => index + 1)
                              .map(
                                (e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(
                                    "$e",
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ),
                              )
                              .toList(),
                      onChanged: (_) {},
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
