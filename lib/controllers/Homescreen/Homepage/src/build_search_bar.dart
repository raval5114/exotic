import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

Widget _buildSearchBar(BuildContext context) {
  return Container(
    height: 45,
    padding: const EdgeInsets.symmetric(horizontal: 12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
    ),
    child: const Row(
      children: [
        Icon(Icons.camera_alt, size: 20),
        SizedBox(width: 8),
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              hintText: "Search",
              border: InputBorder.none,
            ),
          ),
        ),
        Icon(Icons.mic, size: 20),
        SizedBox(width: 8),
        Icon(Icons.search, size: 20),
      ],
    ),
  );
}

class BuildSearchBar extends StatelessWidget {
  const BuildSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFF9747FF).withOpacity(0.5),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.only(right: 12.0),
            child: Icon(
              Icons.search_rounded,
              color: Color(0xFF9747FF),
              size: 24,
            ),
          ),
          Expanded(
            child: TextField(
              readOnly: true,
              onTap: () => context.push('/searchProductPage'),
              decoration: InputDecoration(
                hintText: "Search",
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
                hintStyle: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: Colors.black45),
              ),
            ),
          ),
          InkWell(
            onTap: () => debugPrint("mic taped"),
            child: const Padding(
              padding: EdgeInsets.all(4.0),
              child: Icon(
                Icons.mic_none_rounded,
                color: Color(0xFF9747FF),
                size: 22,
              ),
            ),
          ),
          const SizedBox(width: 8),
          InkWell(
            onTap: () => debugPrint("camera taped"),
            child: const Padding(
              padding: EdgeInsets.all(4.0),
              child: Icon(
                Icons.camera_alt_outlined,
                color: Color(0xFF9747FF),
                size: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
