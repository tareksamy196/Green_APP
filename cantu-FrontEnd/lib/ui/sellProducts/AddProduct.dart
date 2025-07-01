import 'dart:ffi';
import 'dart:io';
import 'package:cantu/data/ApiService.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/model/BrandModel.dart';
import '../../data/model/Category.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});
  
  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedCategory;
  String? _selectedBrand;
  String? _productName;
  double? _productPrice;
  int? _productQuantity;
  XFile? _productImage;
  final ImagePicker _picker = ImagePicker();
  List<Category> _categories = [];
  List<Brand> _brands = [];
  bool _isLoadingCategories = true;
  bool _isLoadingBrands = false;
  ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {

    setState(() {
      _isLoadingCategories = true;
    });
    try {
      final categories = await apiService.fetchCategories();
      setState(() {
        _categories = categories;
        _isLoadingCategories = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingCategories = false;
      });
      // Handle error
      print('Failed to load categories: $e');
    }
  }

  Future<void> _fetchBrands(String categoryId) async {
    setState(() {
      _isLoadingBrands = true;
    });
    try {
      final brands = await apiService.fetchBrands(categoryId);
      setState(() {
        _brands = brands;
        _isLoadingBrands = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingBrands = false;
      });
      // Handle error
      print('Failed to load brands: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade50,
      appBar: AppBar(
        title: Center(child:Text('Sell Product', textAlign: TextAlign.center,)),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.green.shade50,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Category Dropdown
              _isLoadingCategories
                  ? Center(child: CircularProgressIndicator())
                  : DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Select Category',
                  prefixIcon: Icon(Icons.category),
                  border: OutlineInputBorder(),
                ),
                value: _selectedCategory,
                items: _categories.map((Category category) {
                  return DropdownMenuItem<String>(
                    value: category.id.toString(),
                    child: Row(
                      children: [
                        Icon(Icons.category), // Example icon
                        SizedBox(width: 8),
                        Text(category.name),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                    _selectedBrand = null; // Reset brand when category changes
                    _brands = [];
                  });
                  if (value != null) {
                    _fetchBrands(value);
                  }
                },
                validator: (value) {
                  if (value == null) return 'Please select a category';
                  return null;
                },
              ),
              SizedBox(height: 16),
              // Brand Dropdown
              if (_selectedCategory != null)
                _isLoadingBrands
                    ? Center(child: CircularProgressIndicator())
                    : DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Select Brand',
                    prefixIcon: Icon(Icons.branding_watermark),
                    border: OutlineInputBorder(),
                  ),
                  value: _selectedBrand,
                  items: _brands.map((Brand brand) {
                    return DropdownMenuItem<String>(
                      value: brand.id.toString(),
                      child: Row(
                        children: [
                          Icon(Icons.branding_watermark), // Example icon
                          SizedBox(width: 8),
                          Text(brand.name),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedBrand = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) return 'Please select a brand';
                    return null;
                  },
                ),
              SizedBox(height: 16),
              // Product Name TextField
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Product Name',
                  prefixIcon: Icon(Icons.drive_file_rename_outline),
                  border: OutlineInputBorder(),
                ),
                onSaved: (value) {
                  _productName = value;
                },
                validator: (value) {
                  if (value!.isEmpty) return 'Please enter a product name';
                  return null;
                },
              ),
              SizedBox(height: 16),
              // Product Price TextField
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Product Price',
                  prefixIcon: Icon(Icons.attach_money),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onSaved: (value) {
                  _productPrice = double.tryParse(value!);
                },
                validator: (value) {
                  if (value!.isEmpty) return 'Please enter a product price';
                  if (double.tryParse(value) == null) return 'Enter a valid price';
                  return null;
                },
              ),
              SizedBox(height: 16),
              // Product Quantity TextField
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Product Quantity',
                  prefixIcon: Icon(Icons.production_quantity_limits),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onSaved: (value) {
                  _productQuantity = int.tryParse(value!);
                },
                validator: (value) {
                  if (value!.isEmpty) return 'Please enter a product quantity';
                  if (int.tryParse(value) == null) return 'Enter a valid quantity';
                  return null;
                },
              ),
              SizedBox(height: 16),
              // Image Picker
              ElevatedButton.icon(
                onPressed: () async {
                  final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
                  setState(() {
                    _productImage = pickedFile;
                  });
                },
                icon: Icon(Icons.photo),
                label: Text('Pick Product Image'),
              ),
              SizedBox(height: 16),
              if (_productImage != null)
                Center(
                  child: Image.file(
                    File(_productImage!.path),
                    height: 100,
                    width: 100,
                  ),
                ),
              SizedBox(height: 16),
              // Submit Button
               Center(
                child: ElevatedButton(
                  onPressed: _submitForm,
                  child: Text('Add Product'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (_productImage != null) {
        try {
          // Upload image to Firebase Storage
          final ref = FirebaseStorage.instance
              .ref()
              .child('product_images')
              .child('${DateTime.now().toIso8601String()}.jpg');
          await ref.putFile(File(_productImage!.path));
          final imageUrl = await ref.getDownloadURL();
          // TODO: Create product here using imageUrl and other product details
          await apiService.createRequest( _productName ?? "",int.parse(_selectedCategory ?? '0'),int.parse(_selectedBrand ?? '0'), _productPrice ?? 0.0,_productQuantity ?? 0 ,imageUrl);
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Product added successfully')));

          // Clear form
          _formKey.currentState!.reset();
          setState(() {
            _selectedCategory = null;
            _selectedBrand = null;
            _productImage = null;
            _productQuantity = null;
          });
        } catch (error) {
          print(error);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to add product')));
        }
      } else {
        print('Please select an image');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please select an image')));
      }
    }
  }
}
