import 'package:cantu/ui/MainBottomBar.dart';
import 'package:flutter/material.dart';
import '../../data/ApiService.dart';
import '../../data/model/Product.dart';
import '../home/HomeScreen.dart'; // Ensure you have a HomeScreen for navigation

class ProductDetailsScreen extends StatefulWidget {
  final int productId;

  const ProductDetailsScreen({Key? key, required this.productId}) : super(key: key);

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  bool isFavorite = false;
  int quantity = 1;
  Product? product; // Make product nullable
  bool isLoading = true;
  ApiService api = ApiService();

  @override
  void initState() {
    super.initState();
    _fetchProductDetails();
  }

  Future<void> _fetchProductDetails() async {
    try {
      Product fetchedProduct = await api.fetchProduct(widget.productId.toString());
      bool favoriteStatus = await api.fetchFavoriteByProductId(widget.productId);
      setState(() {
        product = fetchedProduct;
        isFavorite = favoriteStatus;
        isLoading = false;
      });
    } catch (e) {
      // Handle error and possibly navigate to an error screen or show a message
      print('Error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _toggleFavorite() async {
    if (isFavorite) {
      await api.removeFromFavorite(widget.productId);
    } else {
      await api.addProductToFavorite(widget.productId);
    }
    setState(() {
      isFavorite = !isFavorite;
    });
  }

  void _addToCart() async {
    try {
      await api.addToCart(widget.productId, quantity);
      _showAddToCartDialog();
    } catch (e) {
      // Handle error and show a message
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add to cart'),
        ),
      );
    }
  }

  void _showAddToCartDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Product Added',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Text(
                'The product has been added to your cart.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                'Would you like to view your cart?',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'No',
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'Yes',
                style: TextStyle(fontSize: 18, color: Colors.green),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => MainNavigation(initialIndex: 3), // Index 3 for BagScreen
                  ),
                      (route) => false,
                );
              },
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade50,
      appBar: AppBar(
        backgroundColor: Colors.green.shade50,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        title: isLoading ? Text('Loading...') : Text(product?.name ?? 'Product Details', style: TextStyle(color: Colors.black)),
        actions: [
          if (!isLoading && product != null)
            IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.red : Colors.black,
              ),
              onPressed: _toggleFavorite,
            ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : product == null
          ? Center(child: Text('Failed to load product details'))
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.network(
                    product!.imageUrl,
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text(
                product!.name,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    product!.brandName ?? "",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  Text(
                    '\$${product!.price}',
                    style: TextStyle(fontSize: 22, color: Colors.green, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Chip(
                label: Text(product!.categoryName ?? ""),
                backgroundColor: Colors.green.shade100,
              ),
              SizedBox(height: 16),
              Text(
                'Description',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                product!.description ?? "",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Quantity:',
                    style: TextStyle(fontSize: 18),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () {
                          if (quantity > 1) {
                            setState(() {
                              quantity--;
                            });
                          }
                        },
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          '$quantity',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          if (quantity < product!.quantity) {
                            setState(() {
                              quantity++;
                            });
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Cannot exceed available stock'),
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: _addToCart,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    'Add to Bag',
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
