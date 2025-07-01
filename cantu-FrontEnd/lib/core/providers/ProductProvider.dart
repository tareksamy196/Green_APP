import 'package:flutter/material.dart';

import '../../data/ApiService.dart';
import '../../data/model/Product.dart';


class ProductProvider with ChangeNotifier {
  final ApiService apiService;
  List<Product> _products = [];
  bool _isLoading = false;

  ProductProvider({required this.apiService});

  List<Product> get products => _products;
  bool get isLoading => _isLoading;

  Future<void> fetchProducts() async {
    _isLoading = true;
    notifyListeners();

    try {
      _products = await apiService.fetchProducts();
    } catch (e) {
      // Handle error
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
