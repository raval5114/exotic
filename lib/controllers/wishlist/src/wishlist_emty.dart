import 'package:flutter/material.dart';

class EmptyWishlistWidget extends StatelessWidget {
  const EmptyWishlistWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          // Purple Dot (Top Left)
          Positioned(top: -40, left: -30, child: _dot(color: Colors.purple)),

          // Blue Triangle (Right)
          Positioned(
            top: -10,
            right: -30,
            child: _triangle(color: Colors.blue),
          ),

          // Blue Triangle (Bottom Left)
          Positioned(
            bottom: 30,
            left: -25,
            child: _triangle(color: Colors.blue),
          ),

          // Purple Dot (Bottom Right)
          Positioned(bottom: 10, right: -20, child: _dot(color: Colors.purple)),

          // Main Content
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Heart Image
              Image.asset('assets/images/wishlist/image.png', height: 120),

              const SizedBox(height: 20),

              const Text(
                'Your wishlist is empty.',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 6),

              const Text(
                'Follow collections you love to\nsee them here.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: Colors.grey, height: 1.4),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 🔵 Purple Dot
  Widget _dot({required Color color}) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }

  // 🔺 Blue Triangle
  Widget _triangle({required Color color}) {
    return CustomPaint(
      size: const Size(14, 14),
      painter: _TrianglePainter(color),
    );
  }
}

class _TrianglePainter extends CustomPainter {
  final Color color;
  _TrianglePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path =
        Path()
          ..moveTo(size.width / 2, 0)
          ..lineTo(0, size.height)
          ..lineTo(size.width, size.height)
          ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
