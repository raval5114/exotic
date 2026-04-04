import 'package:flutter/material.dart';

class SearchProductRecentSearchTile extends StatelessWidget {
  final String name;
  final String? imagePath;
  final double avatarRadius;
  final double width;
  final bool isHighlighted;

  const SearchProductRecentSearchTile({
    super.key,
    required this.name,
    this.imagePath,
    required this.avatarRadius,
    required this.width,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    bool isNetworkImage = imagePath?.startsWith('http') ?? false;

    return Padding(
      padding: EdgeInsets.only(right: width * 0.05),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(isHighlighted ? 2 : 0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border:
                  isHighlighted
                      ? Border.all(
                        color: const Color(0xFFFF528A), // Vibrant accent color
                        width: 2,
                      )
                      : null,
            ),
            child: CircleAvatar(
              radius: avatarRadius,
              backgroundColor: Colors.grey.shade100,
              backgroundImage:
                  imagePath != null
                      ? (isNetworkImage
                          ? NetworkImage(imagePath!)
                          : AssetImage(imagePath!) as ImageProvider)
                      : null,
              child:
                  imagePath == null
                      ? Icon(
                        Icons.shopping_bag,
                        size: avatarRadius,
                        color: Theme.of(context).colorScheme.secondary,
                      )
                      : null,
            ),
          ),
          SizedBox(height: width * 0.02),
          Text(
            name,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: width * 0.03,
              fontWeight: isHighlighted ? FontWeight.bold : FontWeight.w400,
              color: isHighlighted ? const Color(0xFFFF528A) : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
