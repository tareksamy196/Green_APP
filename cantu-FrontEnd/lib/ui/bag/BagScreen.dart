import 'package:cantu/data/ApiService.dart';
import 'package:flutter/material.dart';
import '../../data/model/CartModel.dart';
import '../order/PaymentScreen.dart';

import 'CartItem.dart';

class BagScreen extends StatefulWidget {
  const BagScreen({super.key});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<BagScreen> {
  late Future<Cart> futureCart;
  ApiService api = ApiService();

  @override
  void initState() {
    super.initState();
    fetchCartItems();
  }

  void fetchCartItems() {
    setState(() {
      futureCart = api.fetchCartItems();
    });
  }

  Future<void> _checkout() async {
    int? orderId = await api.checkout();
    fetchCartItems();
    if (orderId != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentScreen(orderId: orderId),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Checkout failed. Please try again.')),
      );
    }
  }

  Future<void> _deleteCartItem(int productId,int quantity) async {
    final success = await api.deleteCartItem(productId,quantity);
    if (success) {
      fetchCartItems(); // Refresh cart items after deletion
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete item. Please try again.')),
      );
    }
  }

  Future<void> _updateCartItemQuantity(int productId, int quantity) async {
    final success = await api.updateCartItemQuantity(productId, quantity);
    if (success) {
      fetchCartItems(); // Refresh cart items after updating quantity
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update quantity. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade50,
      appBar: AppBar(
        backgroundColor: Colors.green.shade50,
        title: Text('Cart'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: fetchCartItems,
          ),
        ],
      ),
      body: FutureBuilder<Cart>(
        future: futureCart,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.cartItems.isEmpty) {
            return Center(child: Text('No items in cart.'));
          } else {
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.cartItems.length,
                    itemBuilder: (context, index) {
                      final cartItem = snapshot.data!.cartItems[index];
                      return CartItemCard(
                        cartItem: cartItem,
                        onItemDeleted: () => _deleteCartItem(cartItem.productId,cartItem.quantity),
                        onQuantityChanged: (newQuantity) {
                          if (newQuantity > 0) {
                            _updateCartItemQuantity(cartItem.productId, newQuantity);
                          } else {
                            _deleteCartItem(cartItem.productId,cartItem.quantity);
                          }
                        },
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: _checkout,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Text(
                      'Checkout',
                      style: TextStyle(
                        color: Colors.green.shade900,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
