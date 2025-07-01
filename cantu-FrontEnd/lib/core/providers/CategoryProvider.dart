import 'package:flutter/material.dart';

import '../../data/ApiService.dart';
import '../../data/model/Category.dart';


class CategoryProvider with ChangeNotifier {
  final ApiService apiService;
  List<Category> _categories = [];
  bool _isLoading = false;

  CategoryProvider({required this.apiService});

  List<Category> get categories => _categories;
  bool get isLoading => _isLoading;

  Future<void> fetchCategories() async {
    _isLoading = true;
    notifyListeners();

    try {
      _categories = await apiService.fetchCategories();
    } catch (e) {
      // Handle error
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

