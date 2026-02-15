import 'package:flutter/material.dart';

class OrderStatusCompletion extends StatelessWidget {
  final int completionStatus; // 1 to 3

  OrderStatusCompletion({super.key, required this.completionStatus});

  final List<String> steps = ["Address", "Order summary", "Payment"];

  Widget _buildStepCircle(int index) {
    final isCompleted = index < completionStatus - 1;
    final isCurrent = index == completionStatus - 1;

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color:
            isCompleted
                ? Colors.white
                : isCurrent
                ? Colors.blue
                : Colors.grey.shade300,
        border: Border.all(
          color: isCompleted || isCurrent ? Colors.blue : Colors.grey.shade400,
          width: 2,
        ),
      ),
      child: CircleAvatar(
        radius: 13,
        backgroundColor:
            isCompleted ? Colors.blue.shade100 : Colors.transparent,
        child:
            isCompleted
                ? const Icon(Icons.check, size: 16, color: Colors.blue)
                : Text(
                  '${index + 1}',
                  style: TextStyle(
                    color: isCurrent ? Colors.white : Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
      ),
    );
  }

  Widget _buildConnector(bool isActive) {
    return Expanded(
      child: Divider(
        color: isActive ? Colors.blue : Colors.grey.shade300,
        thickness: 2,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Row(
            children: List.generate(steps.length * 2 - 1, (i) {
              if (i.isEven) {
                final index = i ~/ 2;
                return Column(
                  children: [
                    _buildStepCircle(index),
                    const SizedBox(height: 4),
                    Text(
                      steps[index],
                      style: TextStyle(
                        fontSize: 12,
                        color:
                            index == completionStatus - 1
                                ? Colors.black
                                : Colors.grey,
                      ),
                    ),
                  ],
                );
              } else {
                return _buildConnector(i ~/ 2 < completionStatus - 1);
              }
            }),
          ),
        ),
      ],
    );
  }
}
