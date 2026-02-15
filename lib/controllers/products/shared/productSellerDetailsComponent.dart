import 'package:exotic/view/venderStore/venderStore.dart';
import 'package:flutter/material.dart';

class Productsellerdetailscomponent extends StatelessWidget {
  final String sellerName;
  final bool isTrusted;
  final double ratings;

  const Productsellerdetailscomponent({
    Key? key,
    required this.sellerName,
    required this.isTrusted,
    required this.ratings,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 2),
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Row(
        children: [
          const Icon(Icons.storefront, color: Colors.blue),
          const SizedBox(width: 6),

          /// Seller name and rating should wrap inside Flexible to avoid overflow
          Expanded(
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    sellerName,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black12),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    children: [
                      Text(
                        ratings.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 2),
                      const Icon(Icons.star, color: Colors.green, size: 16),
                    ],
                  ),
                ),
                const SizedBox(width: 6),
                const Icon(Icons.brightness_1, size: 6, color: Colors.black54),
                const SizedBox(width: 6),
                if (isTrusted)
                  Row(
                    children: const [
                      Icon(Icons.verified, color: Colors.purple, size: 18),
                      SizedBox(width: 4),
                      Text(
                        "Trusted",
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),

          /// Right arrow stays at the end
          InkWell(
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => VenderStore(
                          venderName: '$sellerName',
                          ratings: '5',
                          followings: "1200",
                          products: [],
                          raters: "1200",
                        ),
                  ),
                ),
            child: const Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }
}
