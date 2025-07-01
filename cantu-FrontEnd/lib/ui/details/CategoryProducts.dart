import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/ApiService.dart';
import '../../data/model/BrandModel.dart';
import '../../data/model/Category.dart';
import '../../data/model/Product.dart';
import 'ProductDetail.dart'; // Update with actual import paths

class CategoryProductsScreen extends StatefulWidget {
  final Category category;

  const CategoryProductsScreen({Key? key, required this.category}) : super(key: key);

  @override
  _CategoryProductsScreenState createState() => _CategoryProductsScreenState();
}

class _CategoryProductsScreenState extends State<CategoryProductsScreen> {
  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  List<Brand> _brands = [];
  String? _selectedBrand;
  bool _isLoading = true;
  ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final products = await apiService.fetchProductsByCategory(widget.category.id);
      final brands = await apiService.fetchBrands(widget.category.id.toString());
      _products = products;
      setState(() {
        _filteredProducts = products;
        _brands = brands;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Failed to load products or brands: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade50,
      appBar: AppBar(
        backgroundColor: Colors.green.shade50,
        title: Text('Products in ${widget.category.name}'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButtonFormField<String>(
              hint: Text('Filter by Brand'),
              value: _selectedBrand,
              items: _brands.map((Brand brand) {
                return DropdownMenuItem<String>(
                  value: brand.id.toString(),
                  child: Text(brand.name),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedBrand = value;
                  // Filter products by selected brand
                  print('brand');
                  print(_selectedBrand);
                  print(_products[0].brandId.toString());

                  if (value != null) {
                    _filteredProducts = _products.where((product) => product.brandId.toString() == _selectedBrand).toList();
                  } else {
                    // Reload all products if no brand is selected
                    _fetchData();
                  }
                });
              },
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: _filteredProducts.map((product) => _buildProductListItem(product)).toList(),
              ),
            )
          ),
        ],
      ),
    );
  }

  Widget _buildProductListItem(Product product) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductDetailsScreen(productId: product.id),
            ),
          );
        },
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          decoration: BoxDecoration(
            color: Colors.teal,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.network(
                  product.imageUrl,
                  width: 100.0,
                  height: 100.0,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      '\$${product.price}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14.0,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
    );
  }
}


