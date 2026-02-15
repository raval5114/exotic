import 'package:exotic/data/models/metaData.dart';
import 'package:flutter/material.dart';

class MetaDataProvider extends ChangeNotifier {
  MetaDataModel? _metaData;
  MetaDataModel? get metaData => _metaData;

  void setMetaData(MetaDataModel data) {
    _metaData = data;
    notifyListeners();
  }

  void clearMetaData() {
    _metaData = null;
    notifyListeners();
  }
}
