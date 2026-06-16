import 'package:exotic/Test/HomepagesTesting/model/interactions/shell/interactionShell.dart';

class Exoticcomponents implements InteractionShell {
  @override
  final String createdAt;

  @override
  final int interactionId;

  @override
  final String interactionType;

  @override
  final String updatedAt;
  final String componentName;

  Exoticcomponents({
    required this.componentName,
    required this.createdAt,
    required this.interactionId,
    required this.interactionType,
    required this.updatedAt,
  });

  @override
  InteractionShell fromJson(Map<String, dynamic> json) {
    return Exoticcomponents(
      componentName: json['componentName'],
      interactionId: json['interactionId'],
      interactionType: json['interactionType'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'componentName': componentName,
      'interactionId': interactionId,
      'interactionType': interactionType,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
