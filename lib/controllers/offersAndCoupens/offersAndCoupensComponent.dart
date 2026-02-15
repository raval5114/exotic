import 'package:exotic/controllers/offersAndCoupens/src/couponTile.dart';
import 'package:flutter/material.dart';

class OffersAndCouponsComponent extends StatefulWidget {
  const OffersAndCouponsComponent({super.key});

  @override
  State<OffersAndCouponsComponent> createState() =>
      _OffersAndCouponsComponentState();
}

class _OffersAndCouponsComponentState extends State<OffersAndCouponsComponent> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: GridView.builder(
        itemCount: 6, // Example item count
        shrinkWrap: true,
        physics:
            const NeverScrollableScrollPhysics(), // So it can be inside a scrollable page
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // 2 items per row
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 166 / 158, // Width / Height
        ),
        itemBuilder: (context, index) {
          return CouponTile(isScratched: false);
        },
      ),
    );
  }
}
