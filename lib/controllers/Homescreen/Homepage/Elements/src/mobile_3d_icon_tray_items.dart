import 'package:exotic/data/models/Homepage/elements/Items/mobile_3d_icon_tray.dart';
import 'package:exotic/utils/image_formatter.dart';
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
          SizedBox(
            height: 95,
            width: 80,
            child: Stack(
              alignment: Alignment.bottomCenter,
              clipBehavior: Clip.none,
              children: [
                // 3D Tray Base
                Container(
                  height: 32,
                  width: 80,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFCE1E8), // Light pink top
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0xFFF6BACB), // Thicker 3D depth bottom
                        offset: Offset(0, 6),
                      ),
                      BoxShadow(
                        color: Colors.black12,
                        offset: Offset(0, 10),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                ),
                // Floating Icon/Image
                Positioned(
                  bottom: 24, // Sits on top of the base
                  child: Container(
                    height: 66,
                    width: 66,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.memory(
                        base64ToBytes(item.img),
                        fit: BoxFit.fill,
                        errorBuilder: (_, __, ___) =>
                            const Icon(Icons.image_not_supported, size: 26),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
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
