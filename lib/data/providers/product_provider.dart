import 'package:flutter/material.dart';
import 'package:exotic/data/models/product_orignal.dart';

class ProductProvider extends ChangeNotifier {
  ProductModel? _product;

  int _index = 0;

  String _mrpPrice = "";
  String _sellingPrice = "";
  String _images = "";
  String _discount = "";

  ProductModel? get product => _product;
  int get selectedIndex => _index;
  String get mrpPrice => _mrpPrice;
  String get sellingPrice => _sellingPrice;
  String get images => _images;
  String get discount => _discount;

  bool get hasVariants =>
      _product?.variants != null && _product!.variants!.isNotEmpty;

  void setProduct(ProductModel p) {
    _product = p;
    _index = 0;
    _updateFromIndex();
    notifyListeners();
  }

  void setVariantIndex(int index) {
    if (!hasVariants) return;
    if (index < 0 || index >= _product!.variants!.length) return;

    _index = index;
    _updateFromIndex();
    notifyListeners();
  }

  void _updateFromIndex() {
    if (_product == null) return;

    if (hasVariants) {
      if (_index >= _product!.variants!.length) {
        _index = 0;
      }

      final v = _product!.variants![_index];
      _mrpPrice = v.mrpPrice;
      _sellingPrice = v.pvSellingPrice;
      _images = v.pvGalleryImages;
      _discount = v.pvDiscount;
    } else {
      _mrpPrice = _product!.pMrpPrice ?? "";
      _sellingPrice = _product!.pSellingPrice ?? "";
      _images = _product!.pGalleryImages ?? "";
      _discount = _product!.pDiscount ?? "";
    }
  }
}
