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
      padding: const EdgeInsets.only(top: 20, bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFDFDFD),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 138,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              itemCount: element.items.length,
              separatorBuilder: (_, __) => const SizedBox(width: 15),
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
