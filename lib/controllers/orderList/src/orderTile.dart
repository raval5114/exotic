import 'package:exotic/data/models/order_list_model.dart';
import 'package:exotic/view/orderDetails/orderDetails.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RatingStars extends StatefulWidget {
  final int maxStars;
  final double initialRating;
  final void Function(double)? onRatingChanged;

  const RatingStars({
    super.key,
    this.maxStars = 5,
    this.initialRating = 0,
    this.onRatingChanged,
  });

  @override
  State<RatingStars> createState() => _RatingStarsState();
}

class _RatingStarsState extends State<RatingStars> {
  double _currentRating = 0;

  @override
  void initState() {
    super.initState();
    _currentRating = widget.initialRating;
  }

  void _handleTap(int index) {
    setState(() {
      _currentRating = index.toDouble();
    });
    if (widget.onRatingChanged != null) {
      widget.onRatingChanged!(_currentRating);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(widget.maxStars, (index) {
        final isFilled = index < _currentRating;
        return GestureDetector(
          onTap: () => _handleTap(index + 1),
          child: Padding(
            padding: const EdgeInsets.only(right: 2.0),
            child: Icon(
              isFilled ? Icons.star_rounded : Icons.star_outline_rounded,
              color: isFilled ? Colors.amber.shade500 : Colors.grey.shade300,
              size: 16,
            ),
          ),
        );
      }),
    );
  }
}

// Order Tile Widget
class OrderShowingTile extends StatelessWidget {
  final OrderListModel product;
  const OrderShowingTile({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap:
            () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OrderdetailsPage(product: product),
              ),
            ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 65,
                height: 65,
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade100),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child:
                      product.productImage!.isNotEmpty
                          ? Image.network(
                            product.productImage!,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (context, error, stackTrace) => const Icon(
                                  Icons.image_not_supported,
                                  color: Colors.grey,
                                ),
                          )
                          : Icon(
                            Icons.inventory_2_outlined,
                            color: Colors.grey.shade400,
                            size: 28,
                          ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${product.orderStatus} • ${product.date}",
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        color:
                            product.orderStatus!.toLowerCase().contains(
                                  "cancel",
                                )
                                ? Colors.red.shade600
                                : const Color(0xFF9747FF),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      product.productName!,
                      style: const TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Text(
                          "Rate Item: ",
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        RatingStars(),
                      ],
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 24, left: 8),
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
