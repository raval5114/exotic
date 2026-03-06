import 'package:flutter/material.dart';

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
}
