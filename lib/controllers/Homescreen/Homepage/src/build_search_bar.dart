import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BuildSearchBar extends StatelessWidget {
  const BuildSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/searchProductPage'),
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(
              Icons.search_rounded,
              color: Colors.black45,
              size: 22,
            ),
            const SizedBox(width: 10),
            const Expanded(
              child: Text(
                "Search products, brands...",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black38,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Container(
              width: 1,
              height: 22,
              color: Colors.black12,
              margin: const EdgeInsets.symmetric(horizontal: 8),
            ),
            GestureDetector(
              onTap: () => debugPrint("mic tapped"),
              child: const Icon(
                Icons.mic_none_rounded,
                color: Colors.black45,
                size: 20,
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => debugPrint("camera tapped"),
              child: const Icon(
                Icons.camera_alt_outlined,
                color: Colors.black45,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
