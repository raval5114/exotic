import 'package:exotic/controllers/Homescreen/Homepage/Elements/src/mobile_3d_icon_tray_items.dart';
import 'package:exotic/data/models/Homepage/elements/mobile_3d_icon_tray.dart';
import 'package:flutter/material.dart';

class Mobile3dIconTrayComponent extends StatelessWidget {
  final Mobile3DIconTrayElement element;

  const Mobile3dIconTrayComponent({super.key, required this.element});

  @override
  Widget build(BuildContext context) {
    final config = element.config;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section title if provided
        if (element.title.isNotEmpty) ...[
          Text(
            element.title,
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Color(0xFF111827),
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 14),
        ],

        SizedBox(
          height: 138,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.zero,
            itemCount: element.items.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final item = element.items[index];
              return EnhancedTrayItem(
                item: item,
                labelColor: _parseColor(
                  config.labelColor,
                  fallback: const Color(0xFF374151),
                ),
              );
            },
          ),
        ),
      ],
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
