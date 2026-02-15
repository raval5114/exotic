import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfileScreenSection extends StatelessWidget {
  const ProfileScreenSection({super.key});

  Widget buildProfileItem(IconData icon, String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.blue),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        // padding: const EdgeInsets.symmetric(vertical: 20),
        childAspectRatio: 1.8, // Adjusted for better proportions
        children: [
          buildProfileItem(Icons.inventory_2_outlined, "Orders", () {
            context.push('/orderList');
          }),
          buildProfileItem(Icons.favorite_border, "Wishlist", () {
            context.push('/wishlist');
          }),
          buildProfileItem(Icons.card_giftcard, "Coupons", () {
            context.push('/coupensAndOffers');
          }),
          buildProfileItem(Icons.lock_outline, "Help Center", () {}),
        ],
      ),
    );
  }
}
