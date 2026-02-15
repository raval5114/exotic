import 'package:flutter/material.dart';

class LoginBlobPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final darkPurple =
        Paint()..color = const Color(0xFF9747FF); // Vibrant purple
    final lightPurple =
        Paint()..color = const Color(0xFFDDE6FF); // Light purple (background)

    // Top-left purple circle (bleeds off screen)
    canvas.drawCircle(
      Offset(-size.width * 0.3, size.height * 0.1),
      size.width * 0.7,
      darkPurple,
    );

    // Light lavender blob below top-left purple
    final lightPath =
        Path()
          ..moveTo(size.width * 0.3, 0)
          ..quadraticBezierTo(
            size.width * 0.1,
            size.height * 0.25,
            size.width * 0.6,
            size.height * 0.4,
          )
          ..quadraticBezierTo(
            size.width * 0.95,
            size.height * 0.45,
            size.width,
            0,
          )
          ..close();
    canvas.drawPath(lightPath, lightPurple);

    // Top-right medium purple oval
    final rightPath =
        Path()
          ..moveTo(size.width * 0.8, size.height * 0.35)
          ..quadraticBezierTo(
            size.width * 0.92,
            size.height * 0.42,
            size.width * 0.9,
            size.height * 0.6,
          )
          ..quadraticBezierTo(
            size.width * 0.88,
            size.height * 0.75,
            size.width,
            size.height * 0.6,
          )
          ..lineTo(size.width, size.height * 0.35)
          ..close();
    canvas.drawPath(rightPath, darkPurple);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
