import 'package:exotic/Test/HomepagesTesting/model/interactions/shell/interactionShell.dart';

class ExotichomepageElement implements InteractionShell {
  @override
  final String createdAt;

  @override
  final int interactionId;

  @override
  final String interactionType;

  @override
  final String updatedAt;

  final String elementName;
  final String elementType;
  final String tabBarName;

  ExotichomepageElement({
    required this.createdAt,
    required this.interactionId,
    required this.interactionType,
    required this.updatedAt,
    required this.elementName,
    required this.elementType,
    required this.tabBarName,
  });

  @override
  InteractionShell fromJson(Map<String, dynamic> json) {
    return ExotichomepageElement(
      interactionId: json['interactionId'] as int,
      interactionType: json['interactionType'] as String,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
      elementName: json['elementName'] as String,
      elementType: json['elementType'] as String,
      tabBarName: json['tabBarName'] as String,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'interactionId': interactionId,
      'interactionType': interactionType,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'elementName': elementName,
      'elementType': elementType,
      'tabBarName': tabBarName,
    };
  }
}
