import 'package:flutter/material.dart';
import 'package:cantu/data/ApiService.dart';
import '../../data/model/wishlist.dart';
import '../details/ProductDetail.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  _WishlistScreenState createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  late Future<List<WishlistItem>> _wishlistItems;
  ApiService api = ApiService();

  @override
  void initState() {
    super.initState();
    _wishlistItems = api.fetchWishlistItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade50,
      appBar: AppBar(
        title: const Text('Wishlist'),
        backgroundColor: Colors.green.shade50,
      ),
      body: FutureBuilder<List<WishlistItem>>(
        future: _wishlistItems,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Failed to load wishlist items: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No items in wishlist'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final item = snapshot.data![index];
              return Card(
                color: Colors.green.shade100,
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(10.0),
                  leading: Image.network(
                    item.pic,
                    fit: BoxFit.cover,
                    width: 50,
                    height: 50,
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.image_not_supported),
                  ),
                  title: Text(
                    item.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(item.description),
                  trailing: Text(
                    '\$${item.price}',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailsScreen(productId: item.productId),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
