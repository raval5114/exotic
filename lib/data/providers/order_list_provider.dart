import 'package:exotic/data/models/order_list_model.dart';
import 'package:flutter/material.dart';

class OrderListProvider extends ChangeNotifier {
  final List<OrderListModel> _orders = [];
  bool _isLoading = false;

  List<OrderListModel> get orders => _orders;
  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setOrders(List<OrderListModel> data) {
    _orders
      ..clear()
      ..addAll(data);
    notifyListeners();
  }

  void setOrdersFromJson(List<dynamic> data) {
    _orders
      ..clear()
      ..addAll(
        data.map((e) => OrderListModel.fromJson(e as Map<String, dynamic>)),
      );
    notifyListeners();
  }

  void clear() {
    _orders.clear();
    notifyListeners();
  }
}
