import 'package:exotic/Test/HomepagesTesting/model/interactions/elements/exoticHomepageElement.dart';
import 'package:exotic/Test/HomepagesTesting/model/interactions/providers/interaction_provider.dart';
import 'package:exotic/data/models/Homepage/elements/Items/mobile_3d_icon_tray.dart';
import 'package:exotic/data/models/Interaction/interactions.dart';
import 'package:exotic/data/providers/interaction_provider.dart';
import 'package:exotic/utils/image_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EnhancedTrayItem extends StatelessWidget {
  final Mobile3DIconTrayItem item;
  final Color labelColor;
  final String tab;
  const EnhancedTrayItem({
    required this.item,
    required this.labelColor,
    required this.tab,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // TODO: navigation logic using item.url
        // context.read<InteractionProvider>().addInteraction(
        //   interactionType: InteractionType.mobile3dIconGallery,
        //   pageName: "HomePage/3d-icon-tray/${item.label}",
        // );
        context.read<InteractionTestProvider>().addInteraction(
          ExotichomepageElement(
            createdAt: DateTime.now().toString(),
            interactionId: 1,
            interactionType: "homepage-element",
            updatedAt: DateTime.now().toString(),
            elementName: "${item.label}",
            elementType: "mobile-icon-tray",
            tabBarName: tab,
          ),
        );
      },
      child: SizedBox(
        width: 78,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 96,
              width: 78,
              child: Stack(
                alignment: Alignment.bottomCenter,
                clipBehavior: Clip.none,
                children: [
                  // 3D Tray Base — brand purple tinted
                  Container(
                    height: 30,
                    width: 72,
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEDE9FE), // Light purple top
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0xFFBFB5F2), // Depth bottom
                          offset: Offset(0, 5),
                        ),
                        BoxShadow(
                          color: Colors.black12,
                          offset: Offset(0, 8),
                          blurRadius: 5,
                        ),
                      ],
                    ),
                  ),
                  // Floating Icon/Image
                  Positioned(
                    bottom: 22,
                    child: Container(
                      height: 64,
                      width: 64,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.memory(
                          base64ToBytes(item.img),
                          fit: BoxFit.fill,
                          errorBuilder:
                              (_, __, ___) => const Icon(
                                Icons.image_not_supported,
                                size: 24,
                                color: Colors.grey,
                              ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 7),
            SizedBox(
              width: 78,
              child: Text(
                item.label,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.1,
                  height: 1.3,
                  color: labelColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
