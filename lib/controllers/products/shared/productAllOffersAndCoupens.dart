import 'package:flutter/material.dart';

class ProductAllOffersAndCouponsComponent extends StatelessWidget {
  final VoidCallback? onTap;

  const ProductAllOffersAndCouponsComponent({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 2),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        title: Text(
          "All offers &\nCoupons",
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            height: 1.3,
            color: Colors.black,
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right,
          size: 24,
          color: Colors.black,
        ),
        onTap: onTap,
      ),
    );
  }
}
