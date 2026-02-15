import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:exotic/controllers/orderDetails/orderDetailsDeliveryStatusComponent.dart';
import 'package:exotic/controllers/orderDetails/src/deliveyStatusStep.dart';

class OrderdetailsController extends StatefulWidget {
  final Map<String, dynamic> product;
  const OrderdetailsController({super.key, required this.product});

  @override
  State<OrderdetailsController> createState() => _OrderdetailsControllerState();
}

class _OrderdetailsControllerState extends State<OrderdetailsController> {
  Widget shoppingDetails(String title, String value, bool isStruck) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            title,
            style: GoogleFonts.roboto(
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          const Spacer(),
          Text(
            "₹$value",
            style: GoogleFonts.roboto(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              decoration: isStruck ? TextDecoration.lineThrough : null,
              color: isStruck ? Colors.grey : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final List<Map<String, dynamic>> deliveryUpdates =
        product['deliveryUpdates'];

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Main Card
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  // Order ID
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 16,
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Order ID - ${product['orderId']}",
                        style: GoogleFonts.roboto(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ),
                  Divider(thickness: 0.6, color: Colors.grey.shade400),

                  // Product Section
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 16,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Left: Details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product['productName'],
                                style: GoogleFonts.roboto(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                "Off-white",
                                style: GoogleFonts.roboto(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                "Seller: Killer",
                                style: GoogleFonts.roboto(
                                  fontSize: 13,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Text(
                                    "₹${product['priceBreakdown']['sellingPrice']}",
                                    style: GoogleFonts.roboto(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    "1 offer",
                                    style: GoogleFonts.roboto(
                                      fontSize: 14,
                                      color: Colors.green,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Right: Image
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            "assets/images/categories/categories_auto.png",
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
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
                          deliveryUpdates
                              .map(
                                (e) => DeliveryStatusStep(
                                  title: "${e['status']}",
                                  subtitle: "${e['subtasks'][0]['status']}",
                                  isCurrent:
                                      e["timestamp"] == null ? false : true,
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
                        Text(
                          "Shopping Details",
                          style: GoogleFonts.roboto(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                  Divider(thickness: 1, color: Colors.grey.shade300),

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
                          "${product['priceBreakdown']['listPrice']}",
                          true,
                        ),
                        shoppingDetails(
                          "Selling Price",
                          "${product['priceBreakdown']['sellingPrice']}",
                          false,
                        ),
                        shoppingDetails(
                          "Delivery",
                          "${product['priceBreakdown']['deliveryCharge']}",
                          false,
                        ),
                        shoppingDetails(
                          "Handling Fee",
                          "${product['priceBreakdown']['handlingFee']}",
                          false,
                        ),
                        shoppingDetails(
                          "Total Price",
                          "${product['priceBreakdown']['totalAmount']}",
                          false,
                        ),
                        const SizedBox(height: 20),
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
