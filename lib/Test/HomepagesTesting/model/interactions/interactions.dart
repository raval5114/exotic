import 'package:exotic/Test/HomepagesTesting/model/interactions/elements/exoticComponents.dart';
import 'package:exotic/Test/HomepagesTesting/model/interactions/elements/exoticHomepageElement.dart';
import 'package:exotic/Test/HomepagesTesting/model/interactions/elements/exoticPage.dart';
import 'package:exotic/Test/HomepagesTesting/model/interactions/elements/exoticProduct.dart';
import 'package:exotic/Test/HomepagesTesting/model/interactions/shell/interactionShell.dart';

class Interactions {
  List<InteractionShell> interactions = [];
  Interactions();
  void addInteraction(InteractionShell interaction) {
    if (interaction.interactionType == "page") {
      interactions.add(interaction as Exoticpage);
    } else if (interaction.interactionType == "product") {
      interactions.add(interaction as ExoticProduct);
    } else if (interaction.interactionType == "component") {
      interactions.add(interaction as Exoticcomponents);
    } else if (interaction.interactionType == "homepage-element") {
      interactions.add(interaction as ExotichomepageElement);
    }
  }

  List<InteractionShell> getAllInteractions() {
    return interactions;
  }

  List<InteractionShell> getPages() {
    return interactions
        .where((element) => element.interactionType == "page")
        .toList();
  }

  List<InteractionShell> getProducts() {
    return interactions
        .where((element) => element.interactionType == "product")
        .toList();
  }

  List<InteractionShell> getComponents() {
    return interactions
        .where((element) => element.interactionType == "component")
        .toList();
  }

  List<ExotichomepageElement> getHomepageElements() {
    return interactions.whereType<ExotichomepageElement>().toList();
  }

  Map<String, dynamic> toJson() {
    return {'interactions': interactions.map((e) => e.toJson()).toList()};
  }

  factory Interactions.fromJson(Map<String, dynamic> json) {
    final instance = Interactions();
    for (final e in (json['interactions'] as List<dynamic>)) {
      final map = e as Map<String, dynamic>;
      final type = map['interactionType'] as String;
      if (type == 'page') {
        instance.interactions.add(
          Exoticpage(
            tabBarName: map['tabBarName'],
            pageName: map['pageName'],
            isTabBar: map['isTabBar'],
            interactionId: map['interactionId'],
            interactionType: map['interactionType'],
            createdAt: map['createdAt'],
            updatedAt: map['updatedAt'],
          ),
        );
      } else if (type == 'product') {
        instance.interactions.add(
          ExoticProduct(
            product: map['product'],
            interactionId: map['interactionId'],
            interactionType: map['interactionType'],
            createdAt: map['createdAt'],
            updatedAt: map['updatedAt'],
          ),
        );
      } else if (type == 'component') {
        instance.interactions.add(
          Exoticcomponents(
            componentName: map['componentName'],
            interactionId: map['interactionId'],
            interactionType: map['interactionType'],
            createdAt: map['createdAt'],
            updatedAt: map['updatedAt'],
          ),
        );
      } else if (type == 'homepageElement') {
        instance.interactions.add(
          ExotichomepageElement(
            elementName: map['elementName'] as String,
            elementType: map['elementType'] as String,
            tabBarName: map['tabBarName'] as String,
            interactionId: map['interactionId'] as int,
            interactionType: map['interactionType'] as String,
            createdAt: map['createdAt'] as String,
            updatedAt: map['updatedAt'] as String,
          ),
        );
      }
    }
    return instance;
  }
}
