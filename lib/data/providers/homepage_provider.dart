import 'package:exotic/data/models/Homepage/PageModel.dart';
import 'package:flutter/material.dart';

class HomepageProvider extends ChangeNotifier {
  Pagemodel? _page;

  Pagemodel? get page => _page;

  bool get hasPage => _page != null;

  void setPage(Pagemodel page) {
    _page = page;
    notifyListeners();
  }

  void clearPage() {
    _page = null;
    notifyListeners();
  }
}
