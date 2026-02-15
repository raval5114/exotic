import 'package:flutter/material.dart';

class DeliveryAddressConfirmationWidget extends StatelessWidget {
  final String name;
  final String address;
  final String phoneNumber;
  final VoidCallback onChange;

  const DeliveryAddressConfirmationWidget({
    super.key,
    required this.name,
    required this.address,
    required this.phoneNumber,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                "Deliver to :",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const Spacer(),
              OutlinedButton(
                onPressed: onChange,
                style: OutlinedButton.styleFrom(
                  shape: BeveledRectangleBorder(
                    borderRadius: BorderRadius.circular(3),
                  ),
                  side: BorderSide(color: Colors.grey.shade400),
                ),
                child: const Text(
                  "Change",
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 4),
          Text(address, style: const TextStyle(fontSize: 14)),
          const SizedBox(height: 8),
          Text(
            phoneNumber,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
