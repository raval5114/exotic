import 'package:exotic/data/models/Homepage/elements/Items/mobile_3d_icon_tray.dart';
import 'package:flutter/material.dart';

class EnhancedTrayItem extends StatelessWidget {
  final Mobile3DIconTrayItem item;
  final Color labelColor;

  const EnhancedTrayItem({required this.item, required this.labelColor});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        // TODO: navigation logic using item.url
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 78,
            width: 78,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              gradient: const LinearGradient(
                colors: [Color(0xFFFFFFFF), Color(0xFFF7F8FA)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 8),
                ),
                const BoxShadow(
                  color: Colors.white,
                  offset: Offset(-3, -3),
                  blurRadius: 6,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Image.network(
                item.img,
                fit: BoxFit.contain,
                errorBuilder:
                    (_, __, ___) =>
                        const Icon(Icons.image_not_supported, size: 26),
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: 90,
            child: Text(
              item.label,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 13,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.2,
                height: 1.3,
                color: labelColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
