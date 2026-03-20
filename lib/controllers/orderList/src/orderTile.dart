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
      children: List.generate(widget.maxStars, (index) {
        final isFilled = index < _currentRating;
        return IconButton(
          onPressed: () => _handleTap(index + 1),
          icon: Icon(
            isFilled ? Icons.star : Icons.star_border,
            color: Colors.grey,
            size: 20,
          ),
          constraints: const BoxConstraints(),
        );
      }),
    );
  }
}

// 🧱 Order Tile Widget
class OrderShowingTile extends StatelessWidget {
  final String imagePath;
  final String orderStatus;
  final String productName;
  final String data;
  final Map<String, dynamic> product;
  const OrderShowingTile({
    super.key,
    required this.imagePath,
    required this.orderStatus,
    required this.productName,
    required this.data,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey.shade300),
          bottom: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Icon(Icons.person, size: 55),
        ),
        title: Text(
          "$orderStatus • $data",
          style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color:
                orderStatus == "Canceled On" ? Colors.redAccent : Colors.black,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 12.0, bottom: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                productName,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 12,
                  color: Colors.grey[700],
                ),
              ),
              RatingStars(),
            ],
          ),
        ),
        trailing: GestureDetector(
          onTap:
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OrderdetailsPage(product: product),
                ),
              ),
          child: const Icon(Icons.arrow_forward_ios, size: 14),
        ),
      ),
    );
  }
}
