import 'package:exotic/utils/image_formatter.dart';
import 'package:flutter/material.dart';

class CharmCard extends StatelessWidget {
  final dynamic item;
  final Color borderColor;
  final Color stackedColor;
  final Color textColor;
  final Color backgroud_color;
  const CharmCard({
    required this.item,
    required this.borderColor,
    required this.stackedColor,
    required this.textColor,
    required this.backgroud_color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 210,
      child: Stack(
        children: [
          /// Back stacked layer
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              height: 270,
              width: 200,
              decoration: BoxDecoration(
                color: stackedColor,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),

          /// Main Card
          Positioned(
            top: 0,
            left: 0,
            child: Container(
              height: 280,
              width: 200,
              decoration: BoxDecoration(
                color: backgroud_color,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: borderColor, width: 1.2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  /// Image
                  Expanded(
                    flex: 4,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                      child: Image.memory(
                        base64ToBytes(item.img),
                        width: double.infinity,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),

                  /// Text Section
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: textColor,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            "FROM ${item.price}",
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: textColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
