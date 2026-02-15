import 'package:exotic/data/models/product_orignal.dart';
import 'package:flutter/material.dart';

class ProductBankOffersComponent extends StatelessWidget {
  final ProductModel product;
  const ProductBankOffersComponent({super.key, required this.product});
  List<Map<String, dynamic>> getBankOffersMapped(ProductModel product) {
    List<Map<String, dynamic>> productMapped = [
      {
        "icon": Icons.credit_card,
        "label": "Credit Card EMI",
        "amount": "₹500/month",
        "iconColor": Colors.green,
      },
      {
        "icon": Icons.credit_card_outlined,
        "label": "Debit EMI",
        "amount": "₹600/month",
        "iconColor": Colors.orange,
      },
    ];
    return productMapped;
  }

  Widget _buildBankOfferTile({
    required IconData icon,
    required String label,
    required String amount,
    Color iconColor = Colors.black,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 130, // Can be adjusted based on screen size if needed
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: iconColor, size: 20),
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              amount,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> productMapped = getBankOffersMapped(product);
    return Container(
      margin: const EdgeInsets.only(bottom: 3),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.credit_card, size: 18),
              SizedBox(width: 6),
              Text(
                "Bank offers",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, constraints) {
              return ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight:
                      MediaQuery.of(context).size.height *
                      0.15, // max 15% of screen
                ),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: productMapped.length,
                  itemBuilder: (context, index) {
                    final offer = productMapped[index];
                    return _buildBankOfferTile(
                      icon: offer["icon"],
                      label: offer["label"],
                      amount: offer["amount"],
                      iconColor: offer["iconColor"] ?? Colors.black,
                      onTap: offer["onTap"],
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
