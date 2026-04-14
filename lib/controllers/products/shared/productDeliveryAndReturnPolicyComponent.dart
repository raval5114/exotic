import 'package:exotic/data/models/product_orignal.dart';
import 'package:flutter/material.dart';

enum Policies {
  freeDelivery(Icons.local_shipping),
  easyReturns(Icons.assignment_return),
  securePayment(Icons.lock),
  customerSupport(Icons.support_agent);

  final IconData icon;

  const Policies(this.icon);
}

class ProductDeliveryAndReturnPolicyComponent extends StatelessWidget {
  final ProductModel product;
  const ProductDeliveryAndReturnPolicyComponent({
    super.key,
    required this.product,
  });

  Widget _buildPolicyTile({
    required IconData icon,
    required Widget title,
    Widget? subtitle,
  }) {
    return ListTile(
      dense: true,
      leading: Icon(icon, size: 22, color: Colors.grey),
      title: title,
      subtitle: subtitle,
      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
    );
  }

  List<Map<String, dynamic>> policies(ProductModel product) {
    List<Map<String, dynamic>> policies = [];
    if (product.pFreeShipping == "1") {
      policies.add({
        "icon": Icons.local_shipping,
        "title": "Free Delivery by",
        "subtitle": product.pShippingDays ?? "",
      });
    }
    if (product.pRefundWithNonreturn == "1") {
      policies.add({
        "icon": Icons.restart_alt,
        "title": "Return Policy Availiable",
      });
    }
    if (product.pCashOnDelivery == "1") {
      policies.add({
        "icon": Icons.money,
        "title": "Cash on Delivery Available",
      });
    }
    return policies;
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> policiesMapped = policies(product);
    if (policiesMapped.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Delivery & Policies",
            style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 12),
          ...policiesMapped.asMap().entries.map((entry) {
            final policy = entry.value;
            final isLast = entry.key == policiesMapped.length - 1;
            return Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        policy['icon'],
                        size: 20,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            policy['title'],
                            style: const TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 15,
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          if (policy['subtitle'] != null &&
                              policy['subtitle'].toString().isNotEmpty) ...[
                            const SizedBox(height: 2),
                            Text(
                              policy['subtitle'].toString(),
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 13,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
                if (!isLast)
                  const Divider(
                    thickness: 1,
                    height: 24,
                    color: Colors.black12,
                  ),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }
}
