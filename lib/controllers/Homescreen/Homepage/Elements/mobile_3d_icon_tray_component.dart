import 'package:exotic/controllers/Homescreen/Homepage/Elements/src/mobile_3d_icon_tray_items.dart';
import 'package:exotic/data/models/Homepage/elements/mobile_3d_icon_tray.dart';
import 'package:flutter/material.dart';

class Mobile3dIconTrayComponent extends StatelessWidget {
  final Mobile3DIconTrayElement element;

  const Mobile3dIconTrayComponent({super.key, required this.element});

  @override
  Widget build(BuildContext context) {
    final config = element.config;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(
            height: 120, // Increased height
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: element.items.length,
              separatorBuilder: (_, __) => const SizedBox(width: 24),
              itemBuilder: (context, index) {
                final item = element.items[index];
                return EnhancedTrayItem(
                  item: item,
                  labelColor: _parseColor(
                    config.labelColor,
                    fallback: Colors.black87,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Color _parseColor(String hex, {required Color fallback}) {
    try {
      if (hex.isEmpty) return fallback;
      final cleanedHex = hex.replaceAll('#', '');
      return Color(int.parse('0xFF$cleanedHex'));
    } catch (_) {
      return fallback;
    }
  }
}
