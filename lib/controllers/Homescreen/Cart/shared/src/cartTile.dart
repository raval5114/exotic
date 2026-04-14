import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:exotic/utils/cachedImage.dart';

class CartTile extends StatelessWidget {
  final String productName;
  final String category;
  final String sellerName;
  final int itemsForOff;
  final double priceForOff;
  final int discount;
  final double discountedPrice;
  final double intialPrice;
  final String image;
  final DateTime deliveryBy;
  final bool isFreeDelivery;
  final VoidCallback onRemove;
  final VoidCallback buyThisNow;
  final VoidCallback saveForLater;
  final int quantity;
  final VoidCallback onAdd;
  final VoidCallback onMinus;
  final bool isHighlighted;

  const CartTile({
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
    required this.deliveryBy,
    required this.isFreeDelivery,
    required this.onRemove,
    required this.buyThisNow,
    required this.saveForLater,
    required this.quantity,
    required this.onAdd,
    required this.onMinus,
    this.isHighlighted = false,
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

  Widget _quantityController() {
    return Container(
      height: 28,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: quantity > 1 ? onMinus : null,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(6),
              bottomLeft: Radius.circular(6),
            ),
            child: Container(
              width: 28,
              alignment: Alignment.center,
              child: Icon(
                Icons.remove, 
                size: 14, 
                color: quantity > 1 ? Colors.black87 : Colors.grey.shade400,
              ),
            ),
          ),
          Container(
            width: 27,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              border: Border(
                left: BorderSide(color: Colors.grey.shade200),
                right: BorderSide(color: Colors.grey.shade200),
              ),
            ),
            child: Text(
              quantity.toString(),
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
          InkWell(
            onTap: onAdd,
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(6),
              bottomRight: Radius.circular(6),
            ),
            child: Container(
              width: 28,
              alignment: Alignment.center,
              child: const Icon(Icons.add, size: 14, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  Widget _extraOffSection() {
    final safeItemsForOff = itemsForOff == 0 ? 1 : itemsForOff;
    final remaining = (itemsForOff - quantity).clamp(0, itemsForOff);
    final progress = (quantity / safeItemsForOff).clamp(0.0, 1.0);

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
                        text: remaining > 0
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
            "$quantity of $itemsForOff items added",
            style: const TextStyle(fontSize: 10, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final formattedDeliveryDate = DateFormat('MMM d, EEE').format(deliveryBy);

    final card = Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: isHighlighted ? const Color(0xFFFF528A) : Colors.transparent,
          width: isHighlighted ? 1.5 : 0,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (itemsForOff > 0) _extraOffSection(),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Container(
                        width: 85,
                        height: 95,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: AppCachedImage(imageUrl: image, fit: BoxFit.cover),
                        ),
                      ),
                      const SizedBox(height: 12),
                      _quantityController(),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          productName,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          category,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "Seller: $sellerName",
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              "₹${discountedPrice.toInt()}",
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              "₹${intialPrice.toInt()}",
                              style: TextStyle(
                                decoration: TextDecoration.lineThrough,
                                color: Colors.grey.shade500,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.green.shade50,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                "$discount% OFF",
                                style: const TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(
                              isFreeDelivery ? Icons.local_shipping : Icons.local_shipping_outlined,
                              size: 14,
                              color: isFreeDelivery ? Colors.green : Colors.grey.shade600,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                "Delivery by $formattedDeliveryDate | ${isFreeDelivery ? 'Free' : '₹40'}",
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: isFreeDelivery ? Colors.green : Colors.grey.shade700,
                                ),
                                overflow: TextOverflow.ellipsis,
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

            const SizedBox(height: 12),
            Container(
              color: Colors.grey.shade50,
              padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: _actionButton(
                      icon: Icons.delete_outline,
                      label: "Remove",
                      onPressed: onRemove,
                    ),
                  ),
                  Container(width: 1, height: 24, color: Colors.grey.shade300),
                  Expanded(
                    child: _actionButton(
                      icon: Icons.bookmark_border,
                      label: "Save",
                      onPressed: saveForLater,
                    ),
                  ),
                  Container(width: 1, height: 24, color: Colors.grey.shade300),
                  Expanded(
                    child: _actionButton(
                      icon: Icons.flash_on,
                      label: "Buy Now",
                      onPressed: buyThisNow,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    if (isHighlighted) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFF528A).withOpacity(0.15),
              blurRadius: 12,
              spreadRadius: 3,
            ),
          ],
        ),
        child: card,
      );
    }
    return card;
  }
}
