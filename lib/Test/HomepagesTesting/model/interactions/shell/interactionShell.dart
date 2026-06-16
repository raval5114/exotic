///Interaction shell for testing
///---------------------------------------------
///version 0.0.1
///---------------------------------------------
///this file is only for testing purpose
abstract class InteractionShell {
  int get interactionId;
  String get interactionType;
  String get createdAt;
  String get updatedAt;
  Map<String, dynamic> toJson();
  InteractionShell fromJson(Map<String, dynamic> json);
}
