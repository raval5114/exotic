import 'package:exotic/controllers/orderDetails/src/deliveyStatusStep.dart';
import 'package:exotic/view/orderCancelationPages/orderCancelPage.dart';
import 'package:flutter/material.dart';

class DeliveryTimeline extends StatelessWidget {
  final Map<String, dynamic> data;
  final List<DeliveryStatusStep> steps;
  final int? visibleStepCount;

  const DeliveryTimeline({
    super.key,
    required this.steps,
    required this.data,
    this.visibleStepCount,
  });

  @override
  Widget build(BuildContext context) {
    final displaySteps =
        visibleStepCount != null
            ? steps.take(visibleStepCount!).toList()
            : steps;

    return Column(
      children: [
        ...displaySteps.asMap().entries.map((entry) {
          final index = entry.key;
          final step = entry.value;
          final isLast = index == displaySteps.length - 1;

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color:
                          step.isCurrent
                              ? Colors.green
                              : step.isCompleted
                              ? Colors.grey
                              : Colors.white,
                      border: Border.all(
                        color:
                            step.isCurrent || step.isCompleted
                                ? Colors.green
                                : Colors.grey,
                        width: 2,
                      ),
                      shape: BoxShape.circle,
                    ),
                  ),
                  if (!isLast)
                    Container(
                      width: 2,
                      height: 40,
                      color: Colors.grey.shade200,
                    ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding:
                      step.isCurrent
                          ? const EdgeInsets.symmetric(horizontal: 12, vertical: 8)
                          : EdgeInsets.zero,
                  decoration:
                      step.isCurrent
                          ? BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(8),
                          )
                          : null,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        step.title,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: step.isCurrent ? Colors.green : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        step.subtitle,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }).toList(),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  side: BorderSide(width: 1, color: Colors.grey.shade300),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () => _showEditSheet(context),
                icon: const Icon(Icons.edit_outlined, color: Colors.black87, size: 20),
                label: const Text(
                  "Edit Order",
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    color: Colors.black87,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  side: BorderSide(width: 1, color: Colors.grey.shade300),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {},
                icon: const Icon(Icons.chat_bubble_outline_rounded, color: Colors.black87, size: 20),
                label: const Text(
                  "Chat with us",
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    color: Colors.black87,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showEditSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder: (bottomSheetContext) {
        return SizedBox(
          height: 250,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                title: Text(
                  "What do you need help with?",
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ),
                ),
              ),
              const Divider(height: 0),
              ListTile(
                title: Text("I want to change my phone number"),
                trailing: const Icon(Icons.keyboard_arrow_right_rounded),
                onTap: () {}, // Implement logic here
              ),
              ListTile(
                title: Text("I want to change the delivery address"),
                trailing: const Icon(Icons.keyboard_arrow_right_rounded),
                onTap: () {}, // Implement logic here
              ),
              ListTile(
                title: Text("I want to cancel my order"),
                trailing: const Icon(Icons.keyboard_arrow_right_rounded),
                onTap: () {
                  Navigator.pop(
                    bottomSheetContext,
                  ); // Close the current bottom sheet safely
                  Future.delayed(const Duration(milliseconds: 200), () {
                    showModalBottomSheet(
                      context: context, // Use original parent context
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(12),
                        ),
                      ),
                      builder: (_) => _confirmCancelationSheet(context),
                    );
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _confirmCancelationSheet(BuildContext parentContext) {
    return Padding(
      padding: const EdgeInsets.all(16).copyWith(bottom: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CircleAvatar(
                radius: 14,
                backgroundColor: Colors.blueAccent,
                child: Icon(Icons.percent, size: 16, color: Colors.white),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  "You saved ₹575 on this product!",
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  "assets/images/categories/categories_auto.png", // Replace with actual image
                  height: 50,
                  width: 50,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            "If you cancel now, you may not be able to avail this deal again. Do you still want to cancel?",
            style: TextStyle(fontFamily: 'Roboto', fontSize: 14),
          ),
          const SizedBox(height: 20),
          const Divider(height: 1),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(
                      parentContext,
                    ); // ✅ Proper parent context used here
                  },
                  child: Text(
                    "Don’t Cancel",
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              Container(height: 48, width: 0.5, color: Colors.grey.shade400),
              Expanded(
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(
                      parentContext,
                    ); // Close the current bottom sheet
                    Navigator.push(
                      parentContext,
                      MaterialPageRoute(
                        builder: (context) => OrderCancelPage(product: data),
                      ),
                    );
                  },
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w500,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
