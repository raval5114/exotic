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
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: Colors.grey, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        style: TextStyle(fontFamily: 'Roboto', fontSize: 14),
                        decoration: InputDecoration(
                          hintText:
                              'Search your order heare', // Intentional typo based on image
                          hintStyle: TextStyle(
                            fontFamily: 'Roboto',
                            color: Colors.grey,
                          ),
                          border: InputBorder.none,
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
              child: Row(
                children: [
                  const Icon(Icons.filter_list, size: 22, color: Colors.black),
                  const SizedBox(width: 4),
                  Text(
                    "Filters",
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
