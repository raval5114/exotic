import 'package:exotic/data/models/order_list_model.dart';
import 'package:flutter/material.dart';
import 'package:exotic/controllers/orderDetails/orderDetailsDeliveryStatusComponent.dart';
import 'package:exotic/controllers/orderDetails/src/deliveyStatusStep.dart';

class OrderdetailsController extends StatefulWidget {
  final OrderListModel product;
  const OrderdetailsController({super.key, required this.product});

  @override
  State<OrderdetailsController> createState() => _OrderdetailsControllerState();
}

class _OrderdetailsControllerState extends State<OrderdetailsController> {
  Widget shoppingDetails(
    String title,
    String value,
    bool isStruck, {
    bool isTotal = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
              color: isTotal ? Colors.black87 : Colors.grey.shade700,
            ),
          ),
          const Spacer(),
          Text(
            "₹$value",
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.w800 : FontWeight.w600,
              decoration: isStruck ? TextDecoration.lineThrough : null,
              color:
                  isTotal
                      ? const Color(0xFF9747FF)
                      : (isStruck ? Colors.grey.shade400 : Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final List<DeliveryUpdate>? deliveryUpdates = product.deliveryUpdates;

    return Container(
      color: Colors.grey.shade100,
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Main Card
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  // Order ID
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Order ID - ${product.orderId}",
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  Divider(thickness: 0.6, color: Colors.grey.shade400),

                  // Product Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Left: Details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.productName ?? 'Unknown Product',
                                style: const TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black87,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Text(
                                    "₹${product.priceBreakdown?.sellingPrice ?? '0'}",
                                    style: const TextStyle(
                                      fontFamily: 'Roboto',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF9747FF),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 16),
                        // Right: Image
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child:
                                (product.productImage != null &&
                                        product.productImage
                                            .toString()
                                            .isNotEmpty)
                                    ? Image.network(
                                      product.productImage!,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              const Icon(
                                                Icons.image_not_supported,
                                                color: Colors.grey,
                                              ),
                                    )
                                    : Icon(
                                      Icons.inventory_2_outlined,
                                      color: Colors.grey.shade400,
                                      size: 32,
                                    ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Delivery Status
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 16,
                    ),
                    child: DeliveryTimeline(
                      visibleStepCount: 3,
                      steps:
                          deliveryUpdates!
                              .map(
                                (e) => DeliveryStatusStep(
                                  title: "${e.status}",
                                  subtitle: "${e.subtasks![0].status}",
                                  isCurrent: e.timestamp == null ? false : true,
                                ),
                              )
                              .toList(),
                      data: product,
                    ),
                  ),

                  Divider(thickness: 3, color: Colors.grey.shade200),

                  // Shopping Details Header
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 16,
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.receipt_long_rounded,
                          color: Color(0xFF9747FF),
                          size: 22,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          "Price Breakdown",
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                  Divider(thickness: 1, color: Colors.grey.shade200, height: 1),

                  // Price Breakdown
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        shoppingDetails(
                          "Listing Value",
                          "${product.priceBreakdown!.listPrice ?? '0'}",
                          true,
                        ),
                        shoppingDetails(
                          "Selling Price",
                          "${product.priceBreakdown!.sellingPrice ?? '0'}",
                          false,
                        ),
                        shoppingDetails(
                          "Delivery",
                          "${product.priceBreakdown!.deliveryCharge ?? '0'}",
                          false,
                        ),
                        shoppingDetails(
                          "Handling Fee",
                          "${product.priceBreakdown!.handlingFee ?? '0'}",
                          false,
                        ),
                        const SizedBox(height: 8),
                        const Divider(thickness: 1),
                        const SizedBox(height: 8),
                        shoppingDetails(
                          "Total Price",
                          "${product.priceBreakdown!.totalAmount ?? '0'}",
                          false,
                          isTotal: true,
                        ),
                        const SizedBox(height: 24),
                      ],
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
