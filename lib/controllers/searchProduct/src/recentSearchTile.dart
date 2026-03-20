import 'package:flutter/material.dart';

class SearchProductRecentSearchTile extends StatelessWidget {
  final String name;
  final double avatarRadius;
  final double width;
  const SearchProductRecentSearchTile({
    super.key,
    required this.name,
    required this.avatarRadius,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: width * 0.05),
      child: Column(
        children: [
          CircleAvatar(
            radius: avatarRadius,
            backgroundColor: Theme.of(context).colorScheme.secondary,
            child: Icon(
              Icons.shopping_bag,
              size: avatarRadius,
              color: Colors.white,
            ),
          ),
          SizedBox(height: width * 0.02),
          Text(
            "$name",
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: width * 0.03,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
