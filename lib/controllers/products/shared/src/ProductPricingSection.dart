import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ProductPricingSection extends StatelessWidget {
  final String discount;
  final String discountedPrice;
  final String initialPrice;
  const ProductPricingSection({
    super.key,
    required this.discount,
    required this.discountedPrice,
    required this.initialPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 20),
      child: Row(
        children: [
          Row(children: [Icon(Icons.arrow_downward, color: Colors.green)]),
          Text(
            '$discount%',
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w700,
              color: Colors.green,
              fontSize: 18,
            ),
          ),
          Gap(10),
          Text(
            "₹$discountedPrice",
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
          Gap(10),
          Text(
            "₹$initialPrice",
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w700,
              decoration: TextDecoration.lineThrough,
              decorationColor: Colors.black38,
              color: Colors.black38,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}
