import 'package:exotic/data/models/user.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  User? user;
  void setUser(User user) {
    this.user = user;
    notifyListeners();
  }

  void clearUser() {
    this.user = null;
  }
}
