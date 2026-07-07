import 'package:flutter/material.dart';

class OrderListSearchingComponent extends StatefulWidget {
  const OrderListSearchingComponent({super.key});

  @override
  State<OrderListSearchingComponent> createState() =>
      _OrderListSearchingComponentState();
}

class _OrderListSearchingComponentState
    extends State<OrderListSearchingComponent> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                height: 46,
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  border: Border.all(color: Colors.grey.shade200),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.search_rounded,
                      color: Color(0xFF9747FF),
                      size: 22,
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: TextField(
                        style: TextStyle(fontFamily: 'Roboto', fontSize: 14),
                        decoration: InputDecoration(
                          hintText: 'Search your orders here...',
                          hintStyle: TextStyle(
                            fontFamily: 'Roboto',
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                          border: InputBorder.none,
                          isDense: true,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            InkWell(
              onTap: () {
                // TODO: Trigger filter dialog or logic
              },
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF9747FF).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.tune_rounded,
                      size: 20,
                      color: Color(0xFF9747FF),
                    ),
                    SizedBox(width: 6),
                    Text(
                      "Filter",
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF9747FF),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
