import 'package:exotic/view/widgets/searched_items_widget.dart';
import 'package:flutter/material.dart';
import '../../Test/SearchProduct/models/search_product_model.dart';
import '../../Test/SearchProduct/repos/search_product.dart';

class SearchProductProvider extends ChangeNotifier {
  final SearchProductTesingService _searchService =
      SearchProductTesingService();
  SearchProductResponse? _allData;
  late SearchedItemsList _searchedItemsList;

  List<SearchSuggestion> _filteredSuggestions = [];
  List<SearchSuggestion> get filteredSuggestions => _filteredSuggestions;
  SearchedItemsList get searchedItemsList => _searchedItemsList;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> fetchInitialData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final responseData = await _searchService.searchProduct("");
      _allData = SearchProductResponse.fromJson(responseData);
      _filteredSuggestions = _allData?.suggestions ?? [];
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setSearchedItemsList({required Map<String, dynamic> data}) {
    _searchedItemsList = SearchedItemsList.fromJson(data);
    notifyListeners();
  }

  void searchLocal(String query) {
    if (_allData == null || _allData!.suggestions == null) return;

    if (query.trim().isEmpty) {
      _filteredSuggestions = _allData!.suggestions ?? [];
      notifyListeners();
      return;
    }

    final queryLower = query.toLowerCase();

    _filteredSuggestions =
        _allData!.suggestions!.where((item) {
          final title = item.title?.toLowerCase() ?? '';
          return title.contains(queryLower);
        }).toList();

    notifyListeners();
  }

  void clearSearch() {
    if (_allData != null && _allData!.suggestions != null) {
      _filteredSuggestions = _allData!.suggestions!;
    } else {
      _filteredSuggestions = [];
    }
    notifyListeners();
  }

  String? _selectedCategory;
  String? get selectedCategory => _selectedCategory;

  String? _selectedBrand;
  String? get selectedBrand => _selectedBrand;

  void setCategoryFilter(String? categoryName) {
    if (_selectedCategory == categoryName) {
      _selectedCategory = null;
    } else {
      _selectedCategory = categoryName;
    }
    notifyListeners();
  }

  void setBrandFilter(String? brandName) {
    if (_selectedBrand == brandName) {
      _selectedBrand = null;
    } else {
      _selectedBrand = brandName;
    }
    notifyListeners();
  }

  List<SearchedItems> get filteredProductItems {
    if (_isLoading) return [];
    var items = _searchedItemsList.items;

    if (_selectedCategory != null) {
      items =
          items.where((item) => item.category == _selectedCategory).toList();
    }
    if (_selectedBrand != null) {
      items = items.where((item) => item.brand == _selectedBrand).toList();
    }

    return items;
  }
}
