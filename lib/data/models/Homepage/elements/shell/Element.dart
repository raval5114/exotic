abstract class PageElement {
  String get title;
  int get elementId;
  String get elementType;
  ElementConfig get config;
  List<Items> get items;
}

abstract class Items {}

abstract class ElementConfig {}
