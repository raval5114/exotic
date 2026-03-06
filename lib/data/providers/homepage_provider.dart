import 'package:exotic/data/models/Homepage/PageModel.dart';
import 'package:exotic/data/models/homepage_page_model.dart';
import 'package:flutter/material.dart';

class HomepageProvider extends ChangeNotifier {
  List<HomepagePageModel> _tabs = [];
  int _selectedIndex = 0;

  final Map<String, Pagemodel> _pages = {};
  final Map<String, bool> _loading = {};

  List<HomepagePageModel> get tabs => _tabs.reversed.toList();

  void setTabs(List<HomepagePageModel> value) {
    _tabs = value;
    notifyListeners();
  }

  void setSelectedIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  bool isLoading(String slug) => _loading[slug] ?? false;

  Pagemodel? getPage(String slug) => _pages[slug];

  void setLoading(String slug, bool value) {
    _loading[slug] = value;
    notifyListeners();
  }

  void setPage(String slug, Pagemodel page) {
    _pages[slug] = page;
    notifyListeners();
  }
}
