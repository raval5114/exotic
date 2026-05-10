import 'package:exotic/data/models/brands.dart';
import 'package:flutter/material.dart';

class BrandsProvider extends ChangeNotifier {
  List<Brands> _brands = [];
  void setBrands(List<Map<String, dynamic>> data) {
    _brands = data.map((e) => Brands.fromJson(e)).toList();
    notifyListeners();
  }

  List<Brands> get brands => _brands;
}
