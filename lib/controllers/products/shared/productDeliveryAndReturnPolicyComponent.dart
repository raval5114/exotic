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
    return Container(
      margin: const EdgeInsets.only(bottom: 2),
      color: Colors.white,
      child: Column(
        children:
            policiesMapped.map((policy) {
              return _buildPolicyTile(
                icon: policy['icon'],
                title: Text(policy['title']),
                subtitle:
                    policy['subtitle'] == null
                        ? (policy['subtitle'])
                        : Text(""),
              );
            }).toList(),
      ),
    );
  }
}
