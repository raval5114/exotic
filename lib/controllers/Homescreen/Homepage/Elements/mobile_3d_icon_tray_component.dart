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
      padding: const EdgeInsets.symmetric(vertical: 16),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(
          colors: [
            _parseColor(config.baseColor, fallback: Colors.white),
            _parseColor(
              config.baseColor,
              fallback: Colors.white,
            ).withOpacity(0.97),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SizedBox(
        height: 111,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: element.items.length,
          separatorBuilder: (_, __) => const SizedBox(width: 18),
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
