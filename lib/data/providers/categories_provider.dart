import 'package:exotic/data/models/categories.dart';
import 'package:flutter/material.dart';

class CategoriesProvider extends ChangeNotifier {
  List<Category> _categories = [];
  Category? _selectedCategory;

  /// Set all categories (usually parsed from JSON or API)
  void setCategories(List<Category> categories) {
    _categories = categories;
    notifyListeners();
  }

  /// Select a single category
  void setCurrentCategory(Category category) {
    _selectedCategory = category;
    notifyListeners();
  }

  /// Get all categories
  List<Category> get categories => _categories;

  /// Get currently selected category
  Category? get currentCategory => _selectedCategory;

  /// Reset state
  void clear() {
    _categories = [];
    _selectedCategory = null;
    notifyListeners();
  }

  /// Get top-level categories (parentId == 0)
  List<Category> get topLevelCategories {
    return _categories.where((c) => c.isTopLevel).toList();
  }

  /// Get children of a given category
  List<Category> getChildren(String parentId) {
    return _categories.where((c) => c.parentId == parentId).toList();
  }
}
