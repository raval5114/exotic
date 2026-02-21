import 'package:flutter/material.dart';

class FixedCategoryItem extends StatelessWidget {
  final dynamic item;

  const FixedCategoryItem({required this.item});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 4,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey.shade100,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                item.img,
                fit: BoxFit.cover,
                errorBuilder:
                    (_, __, ___) =>
                        const Icon(Icons.image_not_supported, size: 18),
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Expanded(
          flex: 1,
          child: Text(
            item.title,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontSize: 11,
              fontWeight: FontWeight.w500,
              height: 1.1,
            ),
          ),
        ),
      ],
    );
  }
}
