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
        border: Border.all(color: Colors.blueAccent.shade200, width: 1.5),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Image.asset(
              'assets/icons/homescreen_searchbar_search_icon.jpg',
              height: 20,
              width: 20,
              fit: BoxFit.contain,
            ),
          ),
          Expanded(
            child: TextField(
              readOnly: true,
              onTap: () => context.push('/searchProductPage'),
              decoration: const InputDecoration(
                hintText: "Search",
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
                hintStyle: TextStyle(color: Colors.black45, fontSize: 16),
              ),
            ),
          ),
          InkWell(
            onTap: () => debugPrint("mic taped"),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Image.asset(
                'assets/icons/homescreen_searchbar_mic_icon.jpg',
                height: 22,
                width: 22,
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(width: 8),
          InkWell(
            onTap: () => debugPrint("camera taped"),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Image.asset(
                'assets/icons/homescreen_searchbar_camera_icon.jpg',
                height: 22,
                width: 22,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
