import 'package:flutter/material.dart';

class DotsIndicator extends StatelessWidget {
  final int count;
  final int currentIndex;

  const DotsIndicator({
    super.key,
    required this.count,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        count,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: currentIndex == index ? 24 : 6,
          height: 6,
          decoration: BoxDecoration(
            color: currentIndex == index
                ? const Color(0xFF7C3AED)
                : const Color(0xFFDDD6FE),
            borderRadius: BorderRadius.circular(6),
          ),
        ),
      ),
    );
  }
}
