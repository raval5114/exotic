import 'package:exotic/controllers/auth/Signup/SignupController.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class PurpleBlobPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0xFF9747FF);

    final path = Path();

    // Start from the top-right corner
    path.moveTo(size.width, 0);

    // Curve down to form the blob
    path.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.1,
      size.width * 0.75,
      size.height * 0.3,
    );

    path.cubicTo(
      size.width * 0.7,
      size.height * 0.65,
      size.width * 1.05,
      size.height * 0.7,
      size.width * 1.0,
      size.height,
    );

    // Complete the path back to top-right
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _SignupScreenState extends State<SignupScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white, body: SignupController());
  }
}
