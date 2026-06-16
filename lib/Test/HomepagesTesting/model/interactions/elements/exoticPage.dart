import 'package:exotic/Test/HomepagesTesting/model/interactions/shell/interactionShell.dart';

class Exoticpage implements InteractionShell {
  @override
  final String createdAt;
  @override
  final int interactionId;

  @override
  final String interactionType;

  @override
  final String updatedAt;
  final String tabBarName;
  final String pageName;
  final bool isTabBar;
  Exoticpage({
    required this.tabBarName,
    required this.pageName,
    required this.isTabBar,
    required this.createdAt,
    required this.interactionId,
    required this.interactionType,
    required this.updatedAt,
  });

  @override
  InteractionShell fromJson(Map<String, dynamic> json) {
    return Exoticpage(
      tabBarName: json['tabBarName'],
      pageName: json['pageName'],
      isTabBar: json['isTabBar'],
      interactionId: json['interactionId'],
      interactionType: json['interactionType'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'tabBarName': tabBarName,
      'pageName': pageName,
      'isTabBar': isTabBar,
      'interactionId': interactionId,
      'interactionType': interactionType,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
